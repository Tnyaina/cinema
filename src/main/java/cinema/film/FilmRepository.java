package cinema.film;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface FilmRepository extends JpaRepository<Film, Long> {

    Optional<Film> findByTitre(String titre);

    List<Film> findByTitreContainingIgnoreCase(String titre);

    // Recherche multi-critères
    @Query("SELECT f FROM Film f WHERE " +
           "(:titre IS NULL OR LOWER(f.titre) LIKE LOWER(CONCAT('%', :titre, '%'))) AND " +
           "(:ageMin IS NULL OR f.ageMin <= :ageMin) AND " +
           "(:dureeMin IS NULL OR f.dureeMinutes >= :dureeMin) AND " +
           "(:dureeMax IS NULL OR f.dureeMinutes <= :dureeMax) AND " +
           "(:dateDebut IS NULL OR f.dateSortie >= :dateDebut) AND " +
           "(:dateFin IS NULL OR f.dateSortie <= :dateFin) AND " +
           "(:langueId IS NULL OR f.langueOriginale.id = :langueId)")
    List<Film> rechercherParCriteres(
            @Param("titre") String titre,
            @Param("ageMin") Integer ageMin,
            @Param("dureeMin") Integer dureeMin,
            @Param("dureeMax") Integer dureeMax,
            @Param("dateDebut") LocalDate dateDebut,
            @Param("dateFin") LocalDate dateFin,
            @Param("langueId") Long langueId
    );

    // Recherche sans critère textuel (évite le problème LOWER avec bytea)
    @Query("SELECT f FROM Film f WHERE " +
           "(:ageMin IS NULL OR f.ageMin <= :ageMin) AND " +
           "(:dureeMax IS NULL OR f.dureeMinutes <= :dureeMax) AND " +
           "(:langueId IS NULL OR f.langueOriginale.id = :langueId)")
    List<Film> rechercherParCriteresSansTexte(
            @Param("ageMin") Integer ageMin,
            @Param("dureeMax") Integer dureeMax,
            @Param("langueId") Long langueId
    );
}