package cinema.tarif;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface TarifSeanceRepository extends JpaRepository<TarifSeance, Long> {
    
    @Query("SELECT t FROM TarifSeance t WHERE t.seance.id = :seanceId")
    List<TarifSeance> findBySeanceId(@Param("seanceId") Long seanceId);
    
    @Query("SELECT t FROM TarifSeance t WHERE t.seance.id = :seanceId AND t.typePlace.id = :typePlaceId")
    Optional<TarifSeance> findBySeanceIdAndTypePlaceId(
        @Param("seanceId") Long seanceId, 
        @Param("typePlaceId") Long typePlaceId
    );
    
    @Query("SELECT t FROM TarifSeance t WHERE t.seance.id = :seanceId AND t.categoriePersonne.id = :categoriePersonneId")
    List<TarifSeance> findBySeanceIdAndCategoriePersonneId(
        @Param("seanceId") Long seanceId,
        @Param("categoriePersonneId") Long categoriePersonneId
    );
}
