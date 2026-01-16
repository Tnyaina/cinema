package cinema.tarif;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import cinema.referentiel.categoriepersonne.CategoriePersonne;
import cinema.referentiel.categoriepersonne.CategoriePersonneRepository;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.Set;
import java.util.HashSet;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional
public class ConfigurationTarifaireService {

    private final ConfigurationTarifaireRepository configurationTarifaireRepository;
    private final CategoriePersonneRepository categoriePersonneRepository;

    /**
     * Crée une nouvelle configuration tarifaire
     */
    public ConfigurationTarifaire creerConfiguration(ConfigurationTarifaire configuration) {
        if (!configuration.estValide()) {
            throw new IllegalArgumentException("La configuration tarifaire n'est pas valide");
        }
        
        // Vérifier qu'il n'existe pas déjà une configuration pour cette catégorie
        if (configurationTarifaireRepository.existsByCategoriePersonneId(
                configuration.getCategoriePersonne().getId())) {
            throw new IllegalArgumentException(
                "Une configuration existe déjà pour cette catégorie de personne");
        }
        
        // Vérifier qu'on ne crée pas une référence circulaire
        if (configuration.aUneReference()) {
            verifierAbsenceReferenceCirculaire(
                configuration.getCategoriePersonne().getId(),
                configuration.getCategorieReference().getId());
        }
        
        return configurationTarifaireRepository.save(configuration);
    }

    /**
     * Modifie une configuration tarifaire
     */
    public ConfigurationTarifaire modifierConfiguration(Long id, ConfigurationTarifaire configurationMaj) {
        ConfigurationTarifaire config = obtenirConfigurationById(id);
        
        if (!configurationMaj.estValide()) {
            throw new IllegalArgumentException("La configuration tarifaire n'est pas valide");
        }
        
        // Vérifier que la catégorie ne change pas vers une catégorie déjà configurée
        if (!config.getCategoriePersonne().getId().equals(configurationMaj.getCategoriePersonne().getId())) {
            if (configurationTarifaireRepository.existsByCategoriePersonneId(
                    configurationMaj.getCategoriePersonne().getId())) {
                throw new IllegalArgumentException(
                    "Une configuration existe déjà pour cette catégorie de personne");
            }
        }
        
        // Vérifier qu'on ne crée pas une référence circulaire
        if (configurationMaj.aUneReference()) {
            verifierAbsenceReferenceCirculaire(
                configurationMaj.getCategoriePersonne().getId(),
                configurationMaj.getCategorieReference().getId());
        }
        
        config.setCategoriePersonne(configurationMaj.getCategoriePersonne());
        config.setCategorieReference(configurationMaj.getCategorieReference());
        config.setCoefficientMultiplicateur(configurationMaj.getCoefficientMultiplicateur());
        config.setDescription(configurationMaj.getDescription());
        
        return configurationTarifaireRepository.save(config);
    }

    /**
     * Vérifie qu'il n'y a pas de référence circulaire
     */
    private void verifierAbsenceReferenceCirculaire(Long categorieId, Long referenceCible) {
        if (categorieId.equals(referenceCible)) {
            throw new IllegalArgumentException("Une catégorie ne peut pas se référencer elle-même");
        }
        
        // Vérifier les références en chaîne
        Set<Long> categoriesVisitees = new HashSet<>();
        verifierChaineReference(referenceCible, categoriesVisitees, categorieId);
    }

    private void verifierChaineReference(Long categorieId, Set<Long> categoriesVisitees, Long categorieOriginale) {
        if (categoriesVisitees.contains(categorieId)) {
            return; // Déjà vérifiée
        }
        
        categoriesVisitees.add(categorieId);
        
        configurationTarifaireRepository.findByCategoriePersonneId(categorieId)
            .ifPresent(config -> {
                if (config.aUneReference()) {
                    Long prochaineReference = config.getCategorieReference().getId();
                    if (prochaineReference.equals(categorieOriginale)) {
                        throw new IllegalArgumentException("Cette configuration créerait une référence circulaire");
                    }
                    verifierChaineReference(prochaineReference, categoriesVisitees, categorieOriginale);
                }
            });
    }

    /**
     * Supprime une configuration tarifaire
     */
    public void supprimerConfiguration(Long id) {
        ConfigurationTarifaire config = obtenirConfigurationById(id);
        
        // Vérifier si cette catégorie est utilisée comme référence par d'autres
        if (configurationTarifaireRepository.existsByCategorieReferenceId(
                config.getCategoriePersonne().getId())) {
            throw new IllegalArgumentException(
                "Impossible de supprimer cette configuration car elle est utilisée comme référence par d'autres catégories");
        }
        
        configurationTarifaireRepository.deleteById(id);
    }

    /**
     * Obtient une configuration par ID
     */
    @Transactional(readOnly = true)
    public ConfigurationTarifaire obtenirConfigurationById(Long id) {
        return configurationTarifaireRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Configuration tarifaire non trouvée avec l'ID: " + id));
    }

    /**
     * Obtient toutes les configurations dans l'ordre de dépendance
     */
    @Transactional(readOnly = true)
    public List<ConfigurationTarifaire> obtenirToutesLesConfigurations() {
        return configurationTarifaireRepository.findAllOrderedByDependency();
    }

    /**
     * Obtient les catégories autonomes (sans référence - tarifs fixes)
     */
    @Transactional(readOnly = true)
    public List<ConfigurationTarifaire> obtenirCategoriesAutonomes() {
        return configurationTarifaireRepository.findByCategorieReferenceIsNull();
    }

    /**
     * Calcule les tarifs en cascade selon les relations de référence
     * @param tarifsBase Map des tarifs de base pour les catégories autonomes
     * @return Map complète des tarifs calculés pour toutes les catégories
     */
    @Transactional(readOnly = true)
    public Map<String, Double> calculerTarifsEnCascade(Map<String, Double> tarifsBase) {
        List<ConfigurationTarifaire> configurations = obtenirToutesLesConfigurations();
        Map<String, Double> tarifsCalcules = new HashMap<>(tarifsBase);
        
        // Calculer les tarifs en respectant l'ordre de dépendance
        for (ConfigurationTarifaire config : configurations) {
            String categorieNom = config.getCategoriePersonne().getLibelle();
            
            if (!config.aUneReference()) {
                // Catégorie autonome - doit avoir un tarif de base
                if (!tarifsCalcules.containsKey(categorieNom)) {
                    throw new IllegalArgumentException(
                        "Tarif de base manquant pour la catégorie autonome: " + categorieNom);
                }
            } else {
                // Catégorie avec référence - calculer selon la référence
                String referenceNom = config.getCategorieReference().getLibelle();
                if (!tarifsCalcules.containsKey(referenceNom)) {
                    throw new IllegalArgumentException(
                        "Impossible de calculer le tarif pour " + categorieNom + 
                        " : le tarif de référence " + referenceNom + " n'est pas disponible");
                }
                Double tarifReference = tarifsCalcules.get(referenceNom);
                Double tarifCalcule = config.calculerTarif(tarifReference);
                tarifsCalcules.put(categorieNom, tarifCalcule);
            }
        }
        
        return tarifsCalcules;
    }

    /**
     * Obtient le coefficient multiplicateur pour une catégorie donnée
     */
    @Transactional(readOnly = true)
    public Double obtenirCoefficientParCategorie(Long categoriePersonneId) {
        return configurationTarifaireRepository.findByCategoriePersonneId(categoriePersonneId)
            .map(ConfigurationTarifaire::getCoefficientMultiplicateur)
            .orElse(1.0); // Coefficient par défaut si pas configuré
    }

    /**
     * Calcule le tarif pour une catégorie selon sa référence configurée
     * Si la catégorie n'a pas de configuration, retourne le tarif de base
     */
    @Transactional(readOnly = true)
    public Double calculerTarifParCategorie(Map<String, Double> tarifsBase, String categorieNom) {
        // Chercher la configuration pour cette catégorie
        List<CategoriePersonne> categories = categoriePersonneRepository.findAll();
        CategoriePersonne categorie = categories.stream()
            .filter(c -> c.getLibelle().equals(categorieNom))
            .findFirst()
            .orElse(null);
            
        if (categorie == null) {
            return tarifsBase.getOrDefault(categorieNom, 0.0);
        }
        
        return configurationTarifaireRepository.findByCategoriePersonneId(categorie.getId())
            .map(config -> {
                if (!config.aUneReference()) {
                    // Catégorie autonome
                    return tarifsBase.getOrDefault(categorieNom, 0.0);
                } else {
                    // Catégorie avec référence
                    String referenceNom = config.getCategorieReference().getLibelle();
                    Double tarifReference = tarifsBase.get(referenceNom);
                    if (tarifReference == null) {
                        throw new IllegalArgumentException("Tarif de référence non trouvé pour " + referenceNom);
                    }
                    return config.calculerTarif(tarifReference);
                }
            })
            .orElse(tarifsBase.getOrDefault(categorieNom, 0.0));
    }

    /**
     * Initialise les configurations par défaut si aucune n'existe
     */
    @Transactional
    public void initialiserConfigurationsParDefaut() {
        if (configurationTarifaireRepository.count() == 0) {
            List<CategoriePersonne> categories = categoriePersonneRepository.findAll();
            
            CategoriePersonne categorieAdulte = categories.stream()
                .filter(c -> c.getLibelle().equalsIgnoreCase("Adulte"))
                .findFirst()
                .orElse(null);
                
            for (CategoriePersonne categorie : categories) {
                ConfigurationTarifaire config = new ConfigurationTarifaire();
                config.setCategoriePersonne(categorie);
                
                if (categorie.getLibelle().equalsIgnoreCase("Adulte")) {
                    // Adulte est autonome (pas de référence)
                    config.setCategorieReference(null);
                    config.setCoefficientMultiplicateur(1.0);
                    config.setDescription("Catégorie autonome - tarif de base");
                } else if (categorie.getLibelle().equalsIgnoreCase("Enfant") && categorieAdulte != null) {
                    config.setCategorieReference(categorieAdulte);
                    config.setCoefficientMultiplicateur(0.5);
                    config.setDescription("50% du tarif Adulte");
                } else if (categorie.getLibelle().equalsIgnoreCase("Senior") && categorieAdulte != null) {
                    config.setCategorieReference(categorieAdulte);
                    config.setCoefficientMultiplicateur(1.5);
                    config.setDescription("150% du tarif Adulte");
                } else if (categorieAdulte != null) {
                    config.setCategorieReference(categorieAdulte);
                    config.setCoefficientMultiplicateur(1.0);
                    config.setDescription("Même tarif que l'Adulte");
                } else {
                    // Si pas d'adulte, les autres sont autonomes
                    config.setCategorieReference(null);
                    config.setCoefficientMultiplicateur(1.0);
                    config.setDescription("Catégorie autonome");
                }
                
                configurationTarifaireRepository.save(config);
            }
        }
    }

    /**
     * Obtient toutes les configurations qui dépendent d'une catégorie donnée
     * (toutes les configurations qui utilisent cette catégorie comme référence)
     */
    @Transactional(readOnly = true)
    public List<ConfigurationTarifaire> obtenirConfigurationsDependantesDe(Long categoriePersonneId) {
        return configurationTarifaireRepository.findByCategorieReferenceId(categoriePersonneId);
    }
}
