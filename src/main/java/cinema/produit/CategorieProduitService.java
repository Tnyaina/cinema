package cinema.produit;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class CategorieProduitService {

    private final CategorieProduitRepository categorieProduitRepository;

    public CategorieProduit creerCategorie(CategorieProduit categorie) {
        return categorieProduitRepository.save(categorie);
    }

    public CategorieProduit obtenirCategorieById(Long id) {
        return categorieProduitRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Catégorie non trouvée"));
    }

    public CategorieProduit obtenirCategorieByNom(String nom) {
        return categorieProduitRepository.findByNom(nom)
                .orElseThrow(() -> new RuntimeException("Catégorie non trouvée"));
    }

    public List<CategorieProduit> obtenirToutesCategories() {
        return categorieProduitRepository.findAll();
    }

    public CategorieProduit modifierCategorie(Long id, CategorieProduit categorieMaj) {
        CategorieProduit categorie = obtenirCategorieById(id);
        categorie.setNom(categorieMaj.getNom());
        return categorieProduitRepository.save(categorie);
    }

    public void supprimerCategorie(Long id) {
        categorieProduitRepository.deleteById(id);
    }
}