package cinema.tarif;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface ConfigurationTarifaireRepository extends JpaRepository<ConfigurationTarifaire, Long> {

    /**
     * Trouve la configuration par catégorie de personne
     */
    Optional<ConfigurationTarifaire> findByCategoriePersonneId(Long categoriePersonneId);

    /**
     * Trouve les configurations qui référencent une catégorie donnée
     */
    List<ConfigurationTarifaire> findByCategorieReferenceId(Long categorieReferenceId);

    /**
     * Récupère les catégories autonomes (sans référence)
     */
    List<ConfigurationTarifaire> findByCategorieReferenceIsNull();

    /**
     * Récupère les catégories avec référence
     */
    List<ConfigurationTarifaire> findByCategorieReferenceIsNotNull();

    /**
     * Récupère toutes les configurations triées par coefficient
     */
    @Query("SELECT c FROM ConfigurationTarifaire c " +
           "LEFT JOIN FETCH c.categorieReference " +
           "ORDER BY c.coefficientMultiplicateur ASC")
    List<ConfigurationTarifaire> findAllOrderedByCoefficient();

    /**
     * Vérifie si une catégorie de personne a déjà une configuration
     */
    boolean existsByCategoriePersonneId(Long categoriePersonneId);

    /**
     * Vérifie si une catégorie est utilisée comme référence
     */
    boolean existsByCategorieReferenceId(Long categorieReferenceId);

    /**
     * Trouve les configurations dans l'ordre de dépendance (références d'abord)
     */
    @Query("SELECT c FROM ConfigurationTarifaire c " +
           "LEFT JOIN FETCH c.categorieReference " +
           "ORDER BY CASE WHEN c.categorieReference IS NULL THEN 0 ELSE 1 END, c.categoriePersonne.libelle")
    List<ConfigurationTarifaire> findAllOrderedByDependency();
}