package cinema.publicite.paiement;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface PaiementPubliciteDetailsRepository extends JpaRepository<PaiementPubliciteDetails, Long> {
    
    List<PaiementPubliciteDetails> findByPaiementPubliciteId(Long paiementPubliciteId);
    
    List<PaiementPubliciteDetails> findByDiffusionPublicitaireId(Long diffusionPublicitaireId);
    
    List<PaiementPubliciteDetails> findByPaiementPublicite(PaiementPublicite paiementPublicite);
}
