package cinema.salle;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class SalleService {

    private final SalleRepository salleRepository;

    public Salle creerSalle(Salle salle) {
        if (!salle.estValide()) {
            throw new IllegalArgumentException("La salle n'est pas valide");
        }
        return salleRepository.save(salle);
    }

    public Salle modifierSalle(Long id, Salle salleMaj) {
        Salle salle = obtenirSalleById(id);
        if (!salleMaj.estValide()) {
            throw new IllegalArgumentException("La salle n'est pas valide");
        }
        salle.setNom(salleMaj.getNom());
        salle.setCapacite(salleMaj.getCapacite());
        return salleRepository.save(salle);
    }

    public void supprimerSalle(Long id) {
        salleRepository.deleteById(id);
    }

    @Transactional(readOnly = true)
    public Salle obtenirSalleById(Long id) {
        return salleRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Salle non trouvée avec l'ID: " + id));
    }

    @Transactional(readOnly = true)
    public List<Salle> obtenirToutesLesSalles() {
        return salleRepository.findAll();
    }

    @Transactional(readOnly = true)
    public List<Salle> rechercherParNom(String nom) {
        return salleRepository.findByNomContainingIgnoreCase(nom);
    }
}

