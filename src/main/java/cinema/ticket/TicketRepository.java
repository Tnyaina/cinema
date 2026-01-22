package cinema.ticket;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface TicketRepository extends JpaRepository<Ticket, Long> {

    @Query("SELECT t FROM Ticket t WHERE t.reservation.id = :reservationId ORDER BY t.id")
    List<Ticket> findByReservationId(@Param("reservationId") Long reservationId);

    @Query("SELECT t FROM Ticket t WHERE t.seance.id = :seanceId ORDER BY t.place.numero")
    List<Ticket> findBySeanceId(@Param("seanceId") Long seanceId);

    @Query("SELECT t FROM Ticket t WHERE t.status.id = :statusId ORDER BY t.id")
    List<Ticket> findByStatusId(@Param("statusId") Long statusId);

    // Requête pour obtenir les places déjà vendues/réservées pour une séance
    // Exclut les places annulées, expirées ou utilisées
    @Query("SELECT t.place.id FROM Ticket t WHERE t.seance.id = :seanceId AND t.status.code IN ('RESERVEE', 'CONFIRMEE', 'PAYEE')")
    List<Long> findPlacesReserveesBySeanceId(@Param("seanceId") Long seanceId);

    // Vérifier si une place est déjà réservée/confirmée/payée pour une séance
    // Exclut les places annulées, expirées ou utilisées
    @Query("SELECT COUNT(t) > 0 FROM Ticket t WHERE t.seance.id = :seanceId AND t.place.id = :placeId AND t.status.code IN ('RESERVEE', 'CONFIRMEE', 'PAYEE')")
    boolean isPlaceReservee(@Param("seanceId") Long seanceId, @Param("placeId") Long placeId);

    // Compter les places réservées/confirmées/payées pour une séance
    @Query("SELECT COUNT(t) FROM Ticket t WHERE t.seance.id = :seanceId AND t.status.code IN ('RESERVEE', 'CONFIRMEE', 'PAYEE')")
    long countPlacesVenduesBySeance(@Param("seanceId") Long seanceId);

    // Statistiques de trésorerie - utilise tous les tickets sauf les annulés
    @Query("SELECT SUM(t.prix) FROM Ticket t WHERE t.seance.debut >= :debut AND t.seance.debut <= :fin AND t.status.code != 'ANNULEE'")
    Double calculerCATotalParPeriode(@Param("debut") LocalDateTime debut, @Param("fin") LocalDateTime fin);

    @Query("SELECT COUNT(t) FROM Ticket t WHERE t.seance.debut >= :debut AND t.seance.debut <= :fin AND t.status.code != 'ANNULEE'")
    Long countTicketsVendusParPeriode(@Param("debut") LocalDateTime debut, @Param("fin") LocalDateTime fin);

    @Query("SELECT COUNT(t) FROM Ticket t WHERE t.seance.debut >= :debut AND t.seance.debut <= :fin AND t.status.code = 'ANNULEE'")
    Long countTicketsAnnulesParPeriode(@Param("debut") LocalDateTime debut, @Param("fin") LocalDateTime fin);

    // Récupère le taux d'occupation par séance pour calculer la moyenne en Java - utilise tous les tickets sauf les annulés
    @Query("SELECT CAST(COUNT(t) AS FLOAT) / s.salle.capacite * 100 FROM Ticket t JOIN Seance s ON t.seance.id = s.id WHERE s.debut >= :debut AND s.debut <= :fin AND t.status.code != 'ANNULEE' GROUP BY s.id, s.salle.capacite")
    List<Double> calculerTauxOccupationParSeanceParPeriode(@Param("debut") LocalDateTime debut, @Param("fin") LocalDateTime fin);
}
