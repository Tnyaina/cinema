package cinema.referentiel.versionlangue;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import cinema.referentiel.langue.Langue;
import cinema.referentiel.langue.LangueRepository;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional
public class VersionLangueService {

    private final VersionLangueRepository versionLangueRepository;
    private final LangueRepository langueRepository;

    // CRUD Operations
    public VersionLangue creerVersionLangue(VersionLangue versionLangue) {
        if (!versionLangue.estValide()) {
            throw new IllegalArgumentException("Version de langue invalide");
        }
        return versionLangueRepository.save(versionLangue);
    }

    public VersionLangue modifierVersionLangue(VersionLangue versionLangue) {
        if (!versionLangue.estValide()) {
            throw new IllegalArgumentException("Version de langue invalide");
        }
        if (versionLangue.getId() == null || !versionLangueRepository.existsById(versionLangue.getId())) {
            throw new IllegalArgumentException("Version de langue non trouvée");
        }
        return versionLangueRepository.save(versionLangue);
    }

    public void supprimerVersionLangue(Long id) {
        if (!versionLangueRepository.existsById(id)) {
            throw new IllegalArgumentException("Version de langue non trouvée");
        }
        versionLangueRepository.deleteById(id);
    }

    public VersionLangue obtenirVersionLangueById(Long id) {
        return versionLangueRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Version de langue non trouvée avec l'id: " + id));
    }

    public List<VersionLangue> obtenirToutesLesVersionsLangue() {
        return versionLangueRepository.findAll();
    }

    // Lookups pour autres services
    public List<VersionLangue> obtenirVersionLangueParCode(String code) {
        return versionLangueRepository.findByCodeContaining(code);
    }

    public Optional<VersionLangue> obtenirVersionLangueParCodeExact(String code) {
        return versionLangueRepository.findByCodeExact(code);
    }

    public List<Langue> obtenirToutesLesLangues() {
        return langueRepository.findAll();
    }

    public Langue obtenirLangueById(Long id) {
        return langueRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Langue non trouvée avec l'id: " + id));
    }

    // Helper methods
    public long compterVersionsLangue() {
        return versionLangueRepository.count();
    }

    public boolean existeVersionLangue(Long id) {
        return versionLangueRepository.existsById(id);
    }
}
