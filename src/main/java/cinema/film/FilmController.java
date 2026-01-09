package cinema.film;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import java.util.List;

@Controller
@RequestMapping("/films")
@RequiredArgsConstructor
public class FilmController {

    private final FilmService filmService;

    @GetMapping
    public String listerFilms(
            @RequestParam(required = false) Long genre,
            @RequestParam(required = false) Long langue,
            @RequestParam(required = false) Integer ageMin,
            @RequestParam(required = false) Integer duree,
            Model model) {
        
        List<Film> films;
        
        // Appliquer les filtres si présents
        if (langue != null || ageMin != null || duree != null) {
            films = filmService.rechercherParCriteresSansTexte(
                ageMin,         // ageMin
                duree,          // dureeMax
                langue          // langueId
            );
            
            // Filtrer par genre si nécessaire
            if (genre != null) {
                final Long genreId = genre;
                films = films.stream()
                    .filter(f -> f.getGenres() != null && 
                            f.getGenres().stream().anyMatch(g -> g.getId().equals(genreId)))
                    .toList();
            }
        } else {
            films = filmService.obtenirTousLesFilms();
        }
        
        model.addAttribute("films", films);
        model.addAttribute("genres", filmService.obtenirTousLesGenres());
        model.addAttribute("langues", filmService.obtenirToutesLesLangues());
        model.addAttribute("page", "films/index");
        model.addAttribute("pageTitle", "Films");
        model.addAttribute("pageActive", "films");
        return "layout";
    }

    @GetMapping("/{id}")
    public String afficherDetail(@PathVariable Long id, Model model) {
        Film film = filmService.obtenirFilmById(id);
        model.addAttribute("film", film);
        model.addAttribute("page", "films/detail");
        model.addAttribute("pageTitle", film.getTitre());
        model.addAttribute("pageActive", "films");
        return "layout";
    }

    @GetMapping("/nouveau")
    public String formulaireCreation(Model model) {
        model.addAttribute("film", new Film());
        model.addAttribute("langues", filmService.obtenirToutesLesLangues());
        model.addAttribute("genres", filmService.obtenirTousLesGenres());
        model.addAttribute("page", "films/formulaire");
        model.addAttribute("pageTitle", "Ajouter un film");
        model.addAttribute("pageActive", "films");
        return "layout";
    }

    @PostMapping
    public String creerFilm(Film film, 
                           @RequestParam(required = false) Long langueOriginaleId,
                           @RequestParam(required = false) Long[] genreIds) {
        if (langueOriginaleId != null) {
            film.setLangueOriginale(filmService.obtenirLangueById(langueOriginaleId));
        }
        if (genreIds != null && genreIds.length > 0) {
            filmService.ajouterGenresAuFilm(film, genreIds);
        }
        Film filmCree = filmService.creerFilm(film);
        return "redirect:/films/" + filmCree.getId();
    }

    @GetMapping("/{id}/modifier")
    public String formulaireModification(@PathVariable Long id, Model model) {
        Film film = filmService.obtenirFilmById(id);
        model.addAttribute("film", film);
        model.addAttribute("langues", filmService.obtenirToutesLesLangues());
        model.addAttribute("genres", filmService.obtenirTousLesGenres());
        model.addAttribute("page", "films/formulaire");
        model.addAttribute("pageTitle", "Modifier " + film.getTitre());
        model.addAttribute("pageActive", "films");
        return "layout";
    }

    @PostMapping("/{id}")
    public String modifierFilm(@PathVariable Long id, Film film, 
                               @RequestParam(required = false) Long langueOriginaleId,
                               @RequestParam(required = false) Long[] genreIds) {
        if (langueOriginaleId != null) {
            film.setLangueOriginale(filmService.obtenirLangueById(langueOriginaleId));
        }
        filmService.modifierFilm(id, film, genreIds);
        return "redirect:/films/" + id;
    }

    @PostMapping("/{id}/supprimer")
    public String supprimerFilm(@PathVariable Long id) {
        filmService.supprimerFilm(id);
        return "redirect:/films";
    }
}