package cinema.produit;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class ProduitService {

    private final ProduitRepository produitRepository;
    private final CategorieProduitRepository categorieProduitRepository;

    public Produit creerProduit(Produit produit) {
        return produitRepository.save(produit);
    }

    public Produit obtenirProduitById(Long id) {
        return produitRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Produit non trouvé"));
    }

    public Produit obtenirProduitByNom(String nom) {
        return produitRepository.findByNom(nom)
                .orElseThrow(() -> new RuntimeException("Produit non trouvé"));
    }

    public List<Produit> obtenirTousProduits() {
        return produitRepository.findAll();
    }

    public List<Produit> rechercherProduits(String nom) {
        return produitRepository.findByNomContainingIgnoreCase(nom);
    }

    public List<Produit> obtenirProduitsParCategorie(Long categorieId) {
        return produitRepository.findByCategorieId(categorieId);
    }

    public Produit modifierProduit(Long id, Produit produitMaj) {
        Produit produit = obtenirProduitById(id);
        produit.setNom(produitMaj.getNom());
        produit.setDescription(produitMaj.getDescription());
        produit.setCategorie(produitMaj.getCategorie());
        return produitRepository.save(produit);
    }

    public void supprimerProduit(Long id) {
        produitRepository.deleteById(id);
    }
}