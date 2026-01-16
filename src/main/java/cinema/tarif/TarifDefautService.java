package cinema.tarif;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import cinema.referentiel.typeplace.TypePlace;
import cinema.referentiel.typeplace.TypePlaceRepository;
import cinema.referentiel.categoriepersonne.CategoriePersonne;
import cinema.referentiel.categoriepersonne.CategoriePersonneRepository;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.ArrayList;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional
public class TarifDefautService {

    private final TarifDefautRepository tarifDefautRepository;
    private final TypePlaceRepository typePlaceRepository;
    private final CategoriePersonneRepository categoriePersonneRepository;
    private final ConfigurationTarifaireService configurationTarifaireService;

    public TarifDefaut creerTarifDefaut(TarifDefaut tarifDefaut) {
        if (!tarifDefaut.estValide()) {
            throw new IllegalArgumentException("Le tarif défaut n'est pas valide");
        }
        
        // Vérifier que la combinaison typePlace + categoriePersonne n'existe pas déjà
        if (tarifDefaut.getTypePlace() != null && tarifDefaut.getCategoriePersonne() != null) {
            tarifDefautRepository.findByTypePlaceIdAndCategoriePersonneId(
                tarifDefaut.getTypePlace().getId(),
                tarifDefaut.getCategoriePersonne().getId()
            ).ifPresent(existing -> {
                throw new IllegalArgumentException(
                    "Un tarif existe déjà pour cette combinaison de type de place et catégorie de personne"
                );
            });
        }
        
        return tarifDefautRepository.save(tarifDefaut);
    }

    public TarifDefaut modifierTarifDefaut(Long id, TarifDefaut tarifDefautMaj) {
        TarifDefaut tarifDefaut = obtenirTarifDefautById(id);
        
        if (!tarifDefautMaj.estValide()) {
            throw new IllegalArgumentException("Le tarif défaut n'est pas valide");
        }
        
        // Vérifier que la combinaison n'existe pas déjà ailleurs
        if (tarifDefautMaj.getTypePlace() != null && tarifDefautMaj.getCategoriePersonne() != null) {
            tarifDefautRepository.findByTypePlaceIdAndCategoriePersonneId(
                tarifDefautMaj.getTypePlace().getId(),
                tarifDefautMaj.getCategoriePersonne().getId()
            ).ifPresent(existing -> {
                if (!existing.getId().equals(id)) {
                    throw new IllegalArgumentException(
                        "Un tarif existe déjà pour cette combinaison de type de place et catégorie de personne"
                    );
                }
            });
        }
        
        tarifDefaut.setTypePlace(tarifDefautMaj.getTypePlace());
        tarifDefaut.setCategoriePersonne(tarifDefautMaj.getCategoriePersonne());
        tarifDefaut.setPrix(tarifDefautMaj.getPrix());
        
        return tarifDefautRepository.save(tarifDefaut);
    }

    public void supprimerTarifDefaut(Long id) {
        tarifDefautRepository.deleteById(id);
    }

    @Transactional(readOnly = true)
    public TarifDefaut obtenirTarifDefautById(Long id) {
        return tarifDefautRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Tarif défaut non trouvé avec l'ID: " + id));
    }

    @Transactional(readOnly = true)
    public List<TarifDefaut> obtenirTousTarifDefauts() {
        return tarifDefautRepository.findAllOrdered();
    }

    @Transactional(readOnly = true)
    public List<TarifDefaut> obtenirTarifDefautParTypePlace(Long typePlaceId) {
        return tarifDefautRepository.findByTypePlaceId(typePlaceId);
    }

    @Transactional(readOnly = true)
    public List<TarifDefaut> obtenirTarifDefautParCategoriePersonne(Long categoriePersonneId) {
        return tarifDefautRepository.findByCategoriePersonneId(categoriePersonneId);
    }

    @Transactional(readOnly = true)
    public List<TypePlace> obtenirTousLesTypesPlace() {
        return typePlaceRepository.findAll();
    }

    @Transactional(readOnly = true)
    public List<CategoriePersonne> obtenirToutesLesCategoriesPersonne() {
        return categoriePersonneRepository.findAll();
    }

    @Transactional(readOnly = true)
    public TypePlace obtenirTypePlaceById(Long typePlaceId) {
        return typePlaceRepository.findById(typePlaceId)
            .orElseThrow(() -> new RuntimeException("Type de place non trouvé avec l'ID: " + typePlaceId));
    }

    @Transactional(readOnly = true)
    public CategoriePersonne obtenirCategoriePersonneById(Long categoriePersonneId) {
        return categoriePersonneRepository.findById(categoriePersonneId)
            .orElseThrow(() -> new RuntimeException("Catégorie de personne non trouvée avec l'ID: " + categoriePersonneId));
    }

    /**
     * Crée automatiquement les tarifs pour toutes les catégories de personne 
     * basé sur un tarif de référence et un type de place
     */
    public List<TarifDefaut> creerTarifsAutomatiques(Long typePlaceId, Double tarifReference) {
        TypePlace typePlace = obtenirTypePlaceById(typePlaceId);
        List<CategoriePersonne> categories = obtenirToutesLesCategoriesPersonne();
        List<TarifDefaut> tarifsCreees = new ArrayList<>();
        
        for (CategoriePersonne categorie : categories) {
            // Vérifier si un tarif existe déjà pour cette combinaison
            if (tarifDefautRepository.findByTypePlaceIdAndCategoriePersonneId(
                    typePlaceId, categorie.getId()).isEmpty()) {
                
                // Calculer le tarif selon la configuration tarifaire
                Double coefficient = configurationTarifaireService
                    .obtenirCoefficientParCategorie(categorie.getId());
                Double tarifCalcule = Math.round(tarifReference * coefficient * 100.0) / 100.0;
                
                TarifDefaut tarif = new TarifDefaut(typePlace, categorie, tarifCalcule);
                tarifsCreees.add(tarifDefautRepository.save(tarif));
            }
        }
        
        return tarifsCreees;
    }

    /**
     * Met à jour tous les tarifs existants selon la nouvelle configuration tarifaire
     * Recalcule tous les tarifs basés sur les coefficients configurés
     */
    public void mettreAJourTarifsSelonConfiguration() {
        try {
            // Grouper les tarifs par type de place
            List<TarifDefaut> tousLesTarifs = obtenirTousTarifDefauts();
            Map<Long, List<TarifDefaut>> tarifsParTypePlace = tousLesTarifs.stream()
                .collect(Collectors.groupingBy(t -> 
                    t.getTypePlace() != null ? t.getTypePlace().getId() : 0L));
            
            for (List<TarifDefaut> tarifsTypePlace : tarifsParTypePlace.values()) {
                // Construire la map des tarifs de base pour ce type de place
                Map<String, Double> tarifsBase = new HashMap<>();
                for (TarifDefaut tarif : tarifsTypePlace) {
                    tarifsBase.put(tarif.getCategoriePersonne().getLibelle(), tarif.getPrix());
                }
                
                // Calculer tous les tarifs selon la configuration
                Map<String, Double> tarifsCalcules = configurationTarifaireService
                    .calculerTarifsEnCascade(tarifsBase);
                
                // Mettre à jour les tarifs
                for (TarifDefaut tarif : tarifsTypePlace) {
                    String categorieNom = tarif.getCategoriePersonne().getLibelle();
                    if (tarifsCalcules.containsKey(categorieNom)) {
                        tarif.setPrix(tarifsCalcules.get(categorieNom));
                        tarifDefautRepository.save(tarif);
                    }
                }
            }
        } catch (RuntimeException e) {
            // Si erreur de configuration, ignorer la mise à jour automatique
        }
    }
}
