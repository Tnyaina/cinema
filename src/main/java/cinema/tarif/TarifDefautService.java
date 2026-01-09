package cinema.tarif;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import cinema.referentiel.typeplace.TypePlace;
import cinema.referentiel.typeplace.TypePlaceRepository;
import cinema.referentiel.categoriepersonne.CategoriePersonne;
import cinema.referentiel.categoriepersonne.CategoriePersonneRepository;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class TarifDefautService {

    private final TarifDefautRepository tarifDefautRepository;
    private final TypePlaceRepository typePlaceRepository;
    private final CategoriePersonneRepository categoriePersonneRepository;

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
}
