package cinema.seance;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import cinema.film.Film;
import cinema.film.FilmRepository;
import cinema.salle.Salle;
import cinema.salle.SalleRepository;
import cinema.referentiel.versionlangue.VersionLangue;
import cinema.referentiel.versionlangue.VersionLangueRepository;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class SeanceService {

    private final SeanceRepository seanceRepository;
    private final FilmRepository filmRepository;
    private final SalleRepository salleRepository;
    private final VersionLangueRepository versionLangueRepository;

    public Seance creerSeance(Seance seance) {
        if (!seance.estValide()) {
            throw new IllegalArgumentException("La séance n'est pas valide");
        }
        return seanceRepository.save(seance);
    }

    public Seance modifierSeance(Long id, Seance seanceMaj) {
        Seance seance = obtenirSeanceById(id);
        if (!seanceMaj.estValide()) {
            throw new IllegalArgumentException("La séance n'est pas valide");
        }
        seance.setFilm(seanceMaj.getFilm());
        seance.setSalle(seanceMaj.getSalle());
        seance.setDebut(seanceMaj.getDebut());
        seance.setFin(seanceMaj.getFin());
        seance.setVersionLangue(seanceMaj.getVersionLangue());
        return seanceRepository.save(seance);
    }

    public void supprimerSeance(Long id) {
        seanceRepository.deleteById(id);
    }

    @Transactional(readOnly = true)
    public Seance obtenirSeanceById(Long id) {
        return seanceRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Séance non trouvée avec l'ID: " + id));
    }

    @Transactional(readOnly = true)
    public List<Seance> obtenirSeancesParFilm(Long filmId) {
        return seanceRepository.findByFilmId(filmId);
    }

    @Transactional(readOnly = true)
    public List<Seance> obtenirSeancesParSalle(Long salleId) {
        return seanceRepository.findBySalleId(salleId);
    }

    @Transactional(readOnly = true)
    public List<Seance> obtenirToutesLesSeances() {
        return seanceRepository.findAll();
    }

    @Transactional(readOnly = true)
    public List<Film> obtenirTousLesFilms() {
        return filmRepository.findAll();
    }

    @Transactional(readOnly = true)
    public Film obtenirFilmById(Long filmId) {
        return filmRepository.findById(filmId)
            .orElseThrow(() -> new RuntimeException("Film non trouvé avec l'ID: " + filmId));
    }

    @Transactional(readOnly = true)
    public List<Salle> obtenirToutesLesSalles() {
        return salleRepository.findAll();
    }

    @Transactional(readOnly = true)
    public Salle obtenirSalleById(Long salleId) {
        return salleRepository.findById(salleId)
            .orElseThrow(() -> new RuntimeException("Salle non trouvée avec l'ID: " + salleId));
    }

    @Transactional(readOnly = true)
    public List<VersionLangue> obtenirToutesLesVersionsLangue() {
        return versionLangueRepository.findAll();
    }

    @Transactional(readOnly = true)
    public VersionLangue obtenirVersionLangueById(Long versionLangueId) {
        return versionLangueRepository.findById(versionLangueId)
            .orElseThrow(() -> new RuntimeException("Version langue non trouvée avec l'ID: " + versionLangueId));
    }
}
