package cinema.tarif;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import cinema.seance.Seance;
import cinema.seance.SeanceRepository;
import cinema.referentiel.typeplace.TypePlace;
import cinema.referentiel.typeplace.TypePlaceRepository;
import cinema.referentiel.categoriepersonne.CategoriePersonne;
import cinema.referentiel.categoriepersonne.CategoriePersonneRepository;
import java.util.List;
import java.util.Map;
import java.util.ArrayList;

@Service
@RequiredArgsConstructor
@Transactional
public class TarifSeanceService {

    private final TarifSeanceRepository tarifSeanceRepository;
    private final SeanceRepository seanceRepository;
    private final TypePlaceRepository typePlaceRepository;
    private final CategoriePersonneRepository categoriePersonneRepository;
    private final ConfigurationTarifaireService configurationTarifaireService;

    public TarifSeance creerTarifSeance(TarifSeance tarifSeance) {
        if (!tarifSeance.estValide()) {
            throw new IllegalArgumentException("Le tarif de séance n'est pas valide");
        }
        
        // Vérifier que la combinaison seance + typePlace + categoriePersonne n'existe pas déjà
        if (tarifSeance.getSeance() != null) {
            tarifSeanceRepository.findBySeanceIdAndTypePlaceId(
                tarifSeance.getSeance().getId(),
                tarifSeance.getTypePlace() != null ? tarifSeance.getTypePlace().getId() : null
            ).ifPresent(existing -> {
                throw new IllegalArgumentException(
                    "Un tarif existe déjà pour cette séance et ce type de place"
                );
            });
        }
        
        return tarifSeanceRepository.save(tarifSeance);
    }

    public TarifSeance modifierTarifSeance(Long id, TarifSeance tarifSeanceMaj) {
        TarifSeance tarifSeance = obtenirTarifSeanceById(id);
        
        if (!tarifSeanceMaj.estValide()) {
            throw new IllegalArgumentException("Le tarif de séance n'est pas valide");
        }
        
        // Vérifier que la combinaison n'existe pas déjà ailleurs
        if (tarifSeanceMaj.getSeance() != null) {
            tarifSeanceRepository.findBySeanceIdAndTypePlaceId(
                tarifSeanceMaj.getSeance().getId(),
                tarifSeanceMaj.getTypePlace() != null ? tarifSeanceMaj.getTypePlace().getId() : null
            ).ifPresent(existing -> {
                if (!existing.getId().equals(id)) {
                    throw new IllegalArgumentException(
                        "Un tarif existe déjà pour cette séance et ce type de place"
                    );
                }
            });
        }
        
        tarifSeance.setSeance(tarifSeanceMaj.getSeance());
        tarifSeance.setTypePlace(tarifSeanceMaj.getTypePlace());
        tarifSeance.setCategoriePersonne(tarifSeanceMaj.getCategoriePersonne());
        tarifSeance.setPrix(tarifSeanceMaj.getPrix());
        
        return tarifSeanceRepository.save(tarifSeance);
    }

    public void supprimerTarifSeance(Long id) {
        tarifSeanceRepository.deleteById(id);
    }

    public void creerTarifSeancesEnMasse(Long seanceId, List<Long> typePlaceIds, 
            List<Long> categoriePersonneIds, List<Double> prix) {
        
        if (prix == null || prix.isEmpty()) {
            throw new IllegalArgumentException("Au moins un tarif doit être créé");
        }
        
        // Récupérer la séance une seule fois
        Seance seance = obtenirSeanceById(seanceId);
        
        // Créer chaque tarif de séance
        for (int i = 0; i < prix.size(); i++) {
            TarifSeance tarifSeance = new TarifSeance();
            tarifSeance.setSeance(seance);
            tarifSeance.setPrix(prix.get(i));
            
            // Assigner typePlace si fourni
            if (typePlaceIds != null && i < typePlaceIds.size() && typePlaceIds.get(i) != null) {
                tarifSeance.setTypePlace(obtenirTypePlaceById(typePlaceIds.get(i)));
            }
            
            // Assigner categoriePersonne si fourni
            if (categoriePersonneIds != null && i < categoriePersonneIds.size() && categoriePersonneIds.get(i) != null) {
                tarifSeance.setCategoriePersonne(obtenirCategoriePersonneById(categoriePersonneIds.get(i)));
            }
            
            // Créer le tarif (sans vérifier les doublons puisque l'utilisateur peut les spécifier intentionnellement)
            if (tarifSeance.estValide()) {
                tarifSeanceRepository.save(tarifSeance);
            }
        }
    }

    @Transactional(readOnly = true)
    public TarifSeance obtenirTarifSeanceById(Long id) {
        return tarifSeanceRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Tarif de séance non trouvé avec l'ID: " + id));
    }

    @Transactional(readOnly = true)
    public List<TarifSeance> obtenirTousTarifSeances() {
        return tarifSeanceRepository.findAllOrdered();
    }

    @Transactional(readOnly = true)
    public List<TarifSeance> obtenirTarifSeanceParSeance(Long seanceId) {
        return tarifSeanceRepository.findBySeanceId(seanceId);
    }

    @Transactional(readOnly = true)
    public List<TarifSeance> obtenirTarifSeanceParTypePlace(Long typePlaceId) {
        return tarifSeanceRepository.findByTypePlaceId(typePlaceId);
    }

    @Transactional(readOnly = true)
    public List<TarifSeance> obtenirTarifSeanceParCategoriePersonne(Long categoriePersonneId) {
        return tarifSeanceRepository.findByCategoriePersonneId(categoriePersonneId);
    }

    @Transactional(readOnly = true)
    public List<Seance> obtenirToutesLesSeances() {
        return seanceRepository.findAll();
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
    public Seance obtenirSeanceById(Long seanceId) {
        return seanceRepository.findById(seanceId)
            .orElseThrow(() -> new RuntimeException("Séance non trouvée avec l'ID: " + seanceId));
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
     * pour une séance et un type de place, basé sur un tarif de référence
     */
    public List<TarifSeance> creerTarifsSeanceAutomatiques(Long seanceId, Long typePlaceId, Double tarifReference) {
        Seance seance = obtenirSeanceById(seanceId);
        TypePlace typePlace = obtenirTypePlaceById(typePlaceId);
        List<CategoriePersonne> categories = obtenirToutesLesCategoriesPersonne();
        List<TarifSeance> tarifsCreees = new ArrayList<>();
        
        for (CategoriePersonne categorie : categories) {
            // Vérifier si un tarif existe déjà pour cette combinaison
            if (tarifSeanceRepository.findBySeanceIdAndTypePlaceIdAndCategoriePersonneId(
                    seanceId, typePlaceId, categorie.getId()).isEmpty()) {
                
                // Calculer le tarif selon la configuration tarifaire
                Double coefficient = configurationTarifaireService
                    .obtenirCoefficientParCategorie(categorie.getId());
                Double tarifCalcule = Math.round(tarifReference * coefficient * 100.0) / 100.0;
                
                TarifSeance tarif = new TarifSeance(seance, typePlace, categorie, tarifCalcule);
                tarifsCreees.add(tarifSeanceRepository.save(tarif));
            }
        }
        
        return tarifsCreees;
    }

    /**
     * Crée les tarifs pour une séance en masse avec configuration automatique
     * Le tarif de référence est utilisé pour calculer tous les autres tarifs
     */
    public List<TarifSeance> creerTarifsSeanceEnMasseAvecConfiguration(
            Long seanceId, Map<Long, Double> tarifsReferenceParTypePlace) {
        
        List<TarifSeance> tousLesTarifsCreees = new ArrayList<>();
        
        for (Map.Entry<Long, Double> entry : tarifsReferenceParTypePlace.entrySet()) {
            Long typePlaceId = entry.getKey();
            Double tarifReference = entry.getValue();
            
            List<TarifSeance> tarifsTypePlace = creerTarifsSeanceAutomatiques(
                seanceId, typePlaceId, tarifReference);
            tousLesTarifsCreees.addAll(tarifsTypePlace);
        }
        
        return tousLesTarifsCreees;
    }
}
