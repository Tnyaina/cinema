package cinema.referentiel.categoriepersonne;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.Optional;
import java.util.List;

@Repository
public interface CategoriePersonneRepository extends JpaRepository<CategoriePersonne, Long> {
    
    @Query("SELECT cp FROM CategoriePersonne cp WHERE cp.libelle = :libelle")
    Optional<CategoriePersonne> findByLibelle(@Param("libelle") String libelle);
    
    Optional<CategoriePersonne> findByLibelleIgnoreCase(String libelle);
    
    List<CategoriePersonne> findAll();
}
