package cinema.tarif;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface TarifDefautRepository extends JpaRepository<TarifDefaut, Long> {
    
    @Query("SELECT t FROM TarifDefaut t WHERE t.typePlace.id = :typePlaceId")
    List<TarifDefaut> findByTypePlaceId(@Param("typePlaceId") Long typePlaceId);
    
    @Query("SELECT t FROM TarifDefaut t WHERE t.categoriePersonne.id = :categoriePersonneId")
    List<TarifDefaut> findByCategoriePersonneId(@Param("categoriePersonneId") Long categoriePersonneId);
    
    @Query("SELECT t FROM TarifDefaut t WHERE t.typePlace.id = :typePlaceId AND t.categoriePersonne.id = :categoriePersonneId")
    Optional<TarifDefaut> findByTypePlaceIdAndCategoriePersonneId(
        @Param("typePlaceId") Long typePlaceId,
        @Param("categoriePersonneId") Long categoriePersonneId
    );
    
    @Query("SELECT t FROM TarifDefaut t ORDER BY t.typePlace.libelle, t.categoriePersonne.libelle")
    List<TarifDefaut> findAllOrdered();
}
