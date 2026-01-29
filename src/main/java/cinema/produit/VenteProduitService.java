package cinema.produit;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class VenteProduitService {

    private final VenteProduitRepository venteProduitRepository;
    private final ProduitRepository produitRepository;
    private final TarifProduitRepository tarifProduitRepository;

    public VenteProduit creerVente(VenteProduit vente) {
        return venteProduitRepository.save(vente);
    }

    public VenteProduit obtenirVenteById(Long id) {
        return venteProduitRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Vente non trouvée"));
    }

    public List<VenteProduit> obtenirToutesVentes() {
        return venteProduitRepository.findAll();
    }

    public List<VenteProduit> obtenirVentesParProduit(Long produitId) {
        return venteProduitRepository.findByProduitId(produitId);
    }

    public List<VenteProduit> obtenirVentesParPeriode(LocalDateTime debut, LocalDateTime fin) {
        return venteProduitRepository.findByDateVenteBetween(debut, fin);
    }

    public Double obtenirTotalVentesParPeriode(LocalDateTime debut, LocalDateTime fin) {
        Double total = venteProduitRepository.getTotalVentesBetween(debut, fin);
        return total != null ? total : 0.0;
    }

    public VenteProduit enregistrerVente(Long produitId, Integer quantite) {
        Produit produit = produitRepository.findById(produitId)
                .orElseThrow(() -> new RuntimeException("Produit non trouvé"));

        // Obtenir le tarif actif
        LocalDate today = LocalDate.now();
        TarifProduit tarif = tarifProduitRepository.findTarifActifByProduitAndDate(produitId, today)
                .orElseThrow(() -> new RuntimeException("Aucun tarif actif trouvé pour ce produit"));

        BigDecimal prixUnitaire = tarif.getPrix();
        BigDecimal total = prixUnitaire.multiply(BigDecimal.valueOf(quantite));

        VenteProduit vente = new VenteProduit(produit, quantite, prixUnitaire, total, LocalDateTime.now());
        return venteProduitRepository.save(vente);
    }

    public void supprimerVente(Long id) {
        venteProduitRepository.deleteById(id);
    }
}