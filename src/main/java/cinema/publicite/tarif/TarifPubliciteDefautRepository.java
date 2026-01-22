package cinema.publicite.tarif;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.time.LocalDate;
import java.util.Optional;

@Repository
public interface TarifPubliciteDefautRepository extends JpaRepository<TarifPubliciteDefaut, Long> {

    @Query("SELECT t FROM TarifPubliciteDefaut t WHERE t.typeDiffusion.id = :typeDiffusionId AND t.dateDebut <= :date ORDER BY t.dateDebut DESC LIMIT 1")
    Optional<TarifPubliciteDefaut> findLatestTarifByTypeDiffusion(@Param("typeDiffusionId") Long typeDiffusionId, @Param("date") LocalDate date);
}
