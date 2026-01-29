package cinema.produit;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional
public class TarifProduitService {

    private final TarifProduitRepository tarifProduitRepository;
    private final ProduitRepository produitRepository;

    public TarifProduit creerTarif(TarifProduit tarif) {
        return tarifProduitRepository.save(tarif);
    }

    public TarifProduit obtenirTarifById(Long id) {
        return tarifProduitRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Tarif non trouvé"));
    }

    public List<TarifProduit> obtenirTarifsParProduit(Long produitId) {
        return tarifProduitRepository.findByProduitId(produitId);
    }

    public Optional<TarifProduit> obtenirTarifActif(Long produitId, LocalDate date) {
        return tarifProduitRepository.findTarifActifByProduitAndDate(produitId, date);
    }

    public TarifProduit modifierTarif(Long id, TarifProduit tarifMaj) {
        TarifProduit tarif = obtenirTarifById(id);
        tarif.setPrix(tarifMaj.getPrix());
        tarif.setDateDebut(tarifMaj.getDateDebut());
        tarif.setDateFin(tarifMaj.getDateFin());
        return tarifProduitRepository.save(tarif);
    }

    public void supprimerTarif(Long id) {
        tarifProduitRepository.deleteById(id);
    }
}