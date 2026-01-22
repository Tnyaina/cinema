package cinema.publicite.paiement;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.time.LocalDate;
import java.util.List;

@Repository
public interface PaiementPubliciteRepository extends JpaRepository<PaiementPublicite, Long> {

    @Query("SELECT p FROM PaiementPublicite p WHERE p.societe.id = :societeId ORDER BY p.datePaiement DESC")
    List<PaiementPublicite> findBySocieteId(@Param("societeId") Long societeId);

    @Query("SELECT SUM(p.montant) FROM PaiementPublicite p WHERE p.societe.id = :societeId")
    Double sumMontantBySocieteId(@Param("societeId") Long societeId);

    @Query("SELECT p FROM PaiementPublicite p WHERE p.datePaiement >= :dateDebut AND p.datePaiement <= :dateFin ORDER BY p.datePaiement DESC")
    List<PaiementPublicite> findByDatePaiementBetween(@Param("dateDebut") LocalDate dateDebut, @Param("dateFin") LocalDate dateFin);
}
