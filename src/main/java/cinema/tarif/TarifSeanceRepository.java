package cinema.tarif;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface TarifSeanceRepository extends JpaRepository<TarifSeance, Long> {
    
    @Query("SELECT t FROM TarifSeance t WHERE t.seance.id = :seanceId ORDER BY t.typePlace.libelle, t.categoriePersonne.libelle")
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
    
    @Query("SELECT t FROM TarifSeance t WHERE t.typePlace.id = :typePlaceId ORDER BY t.seance.debut DESC")
    List<TarifSeance> findByTypePlaceId(@Param("typePlaceId") Long typePlaceId);
    
    @Query("SELECT t FROM TarifSeance t WHERE t.categoriePersonne.id = :categoriePersonneId ORDER BY t.seance.debut DESC")
    List<TarifSeance> findByCategoriePersonneId(@Param("categoriePersonneId") Long categoriePersonneId);
    
    @Query("SELECT t FROM TarifSeance t ORDER BY t.seance.debut DESC, t.typePlace.libelle, t.categoriePersonne.libelle")
    List<TarifSeance> findAllOrdered();
    
    @Modifying
    @Query("DELETE FROM TarifSeance t WHERE t.seance.id = :seanceId")
    void deleteBySeanceId(@Param("seanceId") Long seanceId);
}


