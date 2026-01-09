package cinema.referentiel.categoriepersonne;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class CategoriePersonneService {

    private final CategoriePersonneRepository categoriePersonneRepository;

    public CategoriePersonne creerCategoriePersonne(CategoriePersonne categoriePersonne) {
        if (categoriePersonne.getLibelle() == null || categoriePersonne.getLibelle().trim().isEmpty()) {
            throw new IllegalArgumentException("Le libellé de la catégorie ne peut pas être vide");
        }
        
        // Vérifier l'unicité du libellé
        if (categoriePersonneRepository.findByLibelleIgnoreCase(categoriePersonne.getLibelle()).isPresent()) {
            throw new IllegalArgumentException("Une catégorie avec ce libellé existe déjà");
        }
        
        return categoriePersonneRepository.save(categoriePersonne);
    }

    public CategoriePersonne modifierCategoriePersonne(Long id, CategoriePersonne categorieMaj) {
        CategoriePersonne categoriePersonne = obtenirCategoriePersonneById(id);
        
        if (categorieMaj.getLibelle() == null || categorieMaj.getLibelle().trim().isEmpty()) {
            throw new IllegalArgumentException("Le libellé de la catégorie ne peut pas être vide");
        }
        
        // Vérifier l'unicité du libellé (sauf pour la même catégorie)
        categoriePersonneRepository.findByLibelleIgnoreCase(categorieMaj.getLibelle()).ifPresent(existing -> {
            if (!existing.getId().equals(id)) {
                throw new IllegalArgumentException("Une catégorie avec ce libellé existe déjà");
            }
        });
        
        categoriePersonne.setLibelle(categorieMaj.getLibelle());
        return categoriePersonneRepository.save(categoriePersonne);
    }

    public void supprimerCategoriePersonne(Long id) {
        categoriePersonneRepository.deleteById(id);
    }

    @Transactional(readOnly = true)
    public CategoriePersonne obtenirCategoriePersonneById(Long id) {
        return categoriePersonneRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Catégorie de personne non trouvée avec l'ID: " + id));
    }

    @Transactional(readOnly = true)
    public List<CategoriePersonne> obtenirToutesLesCategoriesPersonne() {
        return categoriePersonneRepository.findAll();
    }
}
