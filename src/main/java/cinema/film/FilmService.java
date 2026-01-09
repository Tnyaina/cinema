package cinema.film;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import cinema.referentiel.langue.Langue;
import cinema.referentiel.langue.LangueRepository;
import cinema.referentiel.genre.Genre;
import cinema.referentiel.genre.GenreRepository;
import java.time.LocalDate;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class FilmService {

    private final FilmRepository filmRepository;
    private final LangueRepository langueRepository;
    private final GenreRepository genreRepository;

    public Film creerFilm(Film film) {
        if (!film.estValide()) {
            throw new IllegalArgumentException("Le film n'est pas valide");
        }
        return filmRepository.save(film);
    }

    public Film modifierFilm(Long id, Film filmMaj) {
        Film film = obtenirFilmById(id);
        if (!filmMaj.estValide()) {
            throw new IllegalArgumentException("Le film n'est pas valide");
        }
        film.setTitre(filmMaj.getTitre());
        film.setDescription(filmMaj.getDescription());
        film.setDureeMinutes(filmMaj.getDureeMinutes());
        film.setDateSortie(filmMaj.getDateSortie());
        film.setAgeMin(filmMaj.getAgeMin());
        film.setLangueOriginale(filmMaj.getLangueOriginale());
        return filmRepository.save(film);
    }

    public Film modifierFilm(Long id, Film filmMaj, Long[] genreIds) {
        Film film = modifierFilm(id, filmMaj);
        if (genreIds != null && genreIds.length > 0) {
            ajouterGenresAuFilm(film, genreIds);
            filmRepository.save(film);
        } else {
            // Si pas de genres, vider les genres existants
            film.getGenres().clear();
            filmRepository.save(film);
        }
        return film;
    }

    public void supprimerFilm(Long id) {
        filmRepository.deleteById(id);
    }

    @Transactional(readOnly = true)
    public Film obtenirFilmById(Long id) {
        return filmRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Film non trouvé avec l'ID: " + id));
    }

    @Transactional(readOnly = true)
    public List<Film> obtenirTousLesFilms() {
        return filmRepository.findAll();
    }

    @Transactional(readOnly = true)
    public Film obtenirFilmParTitre(String titre) {
        return filmRepository.findByTitre(titre)
            .orElseThrow(() -> new RuntimeException("Film non trouvé avec le titre: " + titre));
    }

    @Transactional(readOnly = true)
    public List<Film> rechercherParTitre(String titre) {
        return filmRepository.findByTitreContainingIgnoreCase(titre);
    }

    @Transactional(readOnly = true)
    public List<Film> rechercherParCriteres(
            String titre,
            Integer ageMin,
            Integer dureeMin,
            Integer dureeMax,
            LocalDate dateDebut,
            LocalDate dateFin,
            Long langueId) {
        return filmRepository.rechercherParCriteres(
                titre,
                ageMin,
                dureeMin,
                dureeMax,
                dateDebut,
                dateFin,
                langueId
        );
    }

    @Transactional(readOnly = true)
    public List<Film> rechercherParCriteresSansTexte(
            Integer ageMin,
            Integer dureeMax,
            Long langueId) {
        return filmRepository.rechercherParCriteresSansTexte(ageMin, dureeMax, langueId);
    }

    @Transactional(readOnly = true)
    public List<Film> rechercherParDuree(Integer dureeMin, Integer dureeMax) {
        return rechercherParCriteres(null, null, dureeMin, dureeMax, null, null, null);
    }

    @Transactional(readOnly = true)
    public List<Film> rechercherParAgeMin(Integer ageMin) {
        return rechercherParCriteres(null, ageMin, null, null, null, null, null);
    }

    @Transactional(readOnly = true)
    public List<Film> rechercherParPeriodeSortie(LocalDate dateDebut, LocalDate dateFin) {
        return rechercherParCriteres(null, null, null, null, dateDebut, dateFin, null);
    }

    @Transactional(readOnly = true)
    public List<Film> rechercherParLangue(Long langueId) {
        return rechercherParCriteres(null, null, null, null, null, null, langueId);
    }
    
    @Transactional(readOnly = true)
    public List<Film> rechercherFilms(String keyword) {
        return filmRepository.findByTitreContainingIgnoreCase(keyword);
    }

    @Transactional(readOnly = true)
    public List<Langue> obtenirToutesLesLangues() {
        return langueRepository.findAll();
    }

    @Transactional(readOnly = true)
    public List<Genre> obtenirTousLesGenres() {
        return genreRepository.findAll();
    }

    @Transactional(readOnly = true)
    public Langue obtenirLangueById(Long id) {
        return langueRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Langue non trouvée avec l'ID: " + id));
    }

    public void ajouterGenresAuFilm(Film film, Long[] genreIds) {
        if (genreIds != null) {
            film.getGenres().clear();
            for (Long genreId : genreIds) {
                Genre genre = genreRepository.findById(genreId)
                    .orElseThrow(() -> new RuntimeException("Genre non trouvé avec l'ID: " + genreId));
                film.addGenre(genre);
            }
        }
    }
}