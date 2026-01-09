package cinema.ticket;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface TicketRepository extends JpaRepository<Ticket, Long> {

    @Query("SELECT t FROM Ticket t WHERE t.reservation.id = :reservationId ORDER BY t.id")
    List<Ticket> findByReservationId(@Param("reservationId") Long reservationId);

    @Query("SELECT t FROM Ticket t WHERE t.seance.id = :seanceId ORDER BY t.place.numero")
    List<Ticket> findBySeanceId(@Param("seanceId") Long seanceId);

    @Query("SELECT t FROM Ticket t WHERE t.status.id = :statusId ORDER BY t.id")
    List<Ticket> findByStatusId(@Param("statusId") Long statusId);

    // Requête pour obtenir les places déjà vendues pour une séance
    @Query("SELECT t.place.id FROM Ticket t WHERE t.seance.id = :seanceId AND t.status.code IN ('PAYE', 'CONFIRMEE')")
    List<Long> findPlacesReserveesBySeanceId(@Param("seanceId") Long seanceId);

    // Vérifier si une place est déjà réservée pour une séance
    @Query("SELECT COUNT(t) > 0 FROM Ticket t WHERE t.seance.id = :seanceId AND t.place.id = :placeId AND t.status.code IN ('PAYE', 'CONFIRMEE')")
    boolean isPlaceReservee(@Param("seanceId") Long seanceId, @Param("placeId") Long placeId);

    // Compter les places vendues pour une séance
    @Query("SELECT COUNT(t) FROM Ticket t WHERE t.seance.id = :seanceId AND t.status.code IN ('PAYE', 'CONFIRMEE')")
    long countPlacesVenduesBySeance(@Param("seanceId") Long seanceId);
}
