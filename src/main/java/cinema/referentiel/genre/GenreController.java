package cinema.referentiel.genre;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@Controller
@RequestMapping("/genres")
@RequiredArgsConstructor
public class GenreController {

    private final GenreService genreService;

    @GetMapping
    public String listerGenres(Model model) {
        model.addAttribute("genres", genreService.obtenirTousLesGenres());
        model.addAttribute("page", "genres/index");
        model.addAttribute("pageTitle", "Genres");
        model.addAttribute("pageActive", "genres");
        return "layout";
    }

    @GetMapping("/{id}")
    public String afficherDetail(@PathVariable Long id, Model model) {
        Genre genre = genreService.obtenirGenreById(id);
        model.addAttribute("genre", genre);
        model.addAttribute("page", "genres/detail");
        model.addAttribute("pageTitle", "Genre");
        model.addAttribute("pageActive", "genres");
        return "layout";
    }

    @GetMapping("/nouveau")
    public String formulaireCreation(Model model) {
        model.addAttribute("genre", new Genre());
        model.addAttribute("page", "genres/formulaire");
        model.addAttribute("pageTitle", "Ajouter un genre");
        model.addAttribute("pageActive", "genres");
        return "layout";
    }

    @PostMapping
    public String creerGenre(
            @RequestParam String libelle) {
        
        Genre genre = new Genre();
        genre.setLibelle(libelle);
        
        try {
            Genre genreCreee = genreService.creerGenre(genre);
            return "redirect:/genres/" + genreCreee.getId();
        } catch (IllegalArgumentException e) {
            return "redirect:/genres/nouveau?error=" + encodeError(e.getMessage());
        }
    }

    @GetMapping("/{id}/modifier")
    public String formulaireModification(@PathVariable Long id, Model model) {
        Genre genre = genreService.obtenirGenreById(id);
        model.addAttribute("genre", genre);
        model.addAttribute("page", "genres/formulaire");
        model.addAttribute("pageTitle", "Modifier le genre");
        model.addAttribute("pageActive", "genres");
        return "layout";
    }

    @PostMapping("/{id}")
    public String modifierGenre(
            @PathVariable Long id,
            @RequestParam String libelle) {
        
        Genre genreMaj = new Genre();
        genreMaj.setLibelle(libelle);
        
        try {
            genreService.modifierGenre(id, genreMaj);
            return "redirect:/genres/" + id;
        } catch (IllegalArgumentException e) {
            return "redirect:/genres/" + id + "/modifier?error=" + encodeError(e.getMessage());
        }
    }

    @GetMapping("/{id}/supprimer")
    public String confirmationSuppression(@PathVariable Long id, Model model) {
        Genre genre = genreService.obtenirGenreById(id);
        model.addAttribute("genre", genre);
        model.addAttribute("page", "genres/confirmation-suppression");
        model.addAttribute("pageTitle", "Confirmer la suppression");
        model.addAttribute("pageActive", "genres");
        return "layout";
    }

    @PostMapping("/{id}/supprimer")
    public String supprimerGenre(@PathVariable Long id) {
        genreService.supprimerGenre(id);
        return "redirect:/genres?success=genre_supprime";
    }

    private String encodeError(String message) {
        try {
            return URLEncoder.encode(message, StandardCharsets.UTF_8);
        } catch (Exception e) {
            return "erreur";
        }
    }
}
