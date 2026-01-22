package cinema.publicite.tarif;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.time.LocalDate;
import java.util.Optional;

@Repository
public interface TarifPublicitePersonnaliseRepository extends JpaRepository<TarifPublicitePersonnalise, Long> {

    @Query("SELECT t FROM TarifPublicitePersonnalise t WHERE t.societe.id = :societeId AND t.typeDiffusion.id = :typeDiffusionId AND t.dateDebut <= :date ORDER BY t.dateDebut DESC LIMIT 1")
    Optional<TarifPublicitePersonnalise> findLatestTarifBySocieteAndType(@Param("societeId") Long societeId, @Param("typeDiffusionId") Long typeDiffusionId, @Param("date") LocalDate date);
}
