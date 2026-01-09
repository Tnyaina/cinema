package cinema.seance;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@Controller
@RequestMapping("/seances")
@RequiredArgsConstructor
public class SeanceController {

    private final SeanceService seanceService;

    @GetMapping
    public String listerSeances(
            @RequestParam(required = false) Long film,
            @RequestParam(required = false) Long salle,
            Model model) {
        
        List<Seance> seances;
        
        if (film != null) {
            seances = seanceService.obtenirSeancesParFilm(film);
        } else if (salle != null) {
            seances = seanceService.obtenirSeancesParSalle(salle);
        } else {
            seances = seanceService.obtenirToutesLesSeances();
        }
        
        model.addAttribute("seances", seances);
        model.addAttribute("films", seanceService.obtenirTousLesFilms());
        model.addAttribute("salles", seanceService.obtenirToutesLesSalles());
        model.addAttribute("page", "seances/index");
        model.addAttribute("pageTitle", "Séances");
        model.addAttribute("pageActive", "seances");
        return "layout";
    }

    @GetMapping("/{id}")
    public String afficherDetail(@PathVariable Long id, Model model) {
        Seance seance = seanceService.obtenirSeanceById(id);
        model.addAttribute("seance", seance);
        model.addAttribute("page", "seances/detail");
        model.addAttribute("pageTitle", "Séance - " + seance.getFilm().getTitre());
        model.addAttribute("pageActive", "seances");
        return "layout";
    }

    @GetMapping("/nouveau")
    public String formulaireCreation(Model model) {
        model.addAttribute("seance", new Seance());
        model.addAttribute("films", seanceService.obtenirTousLesFilms());
        model.addAttribute("salles", seanceService.obtenirToutesLesSalles());
        model.addAttribute("versionLangues", seanceService.obtenirToutesLesVersionsLangue());
        model.addAttribute("page", "seances/formulaire");
        model.addAttribute("pageTitle", "Ajouter une séance");
        model.addAttribute("pageActive", "seances");
        return "layout";
    }

    @PostMapping
    public String creerSeance(
            Seance seance,
            @RequestParam(required = false) Long filmId,
            @RequestParam(required = false) Long salleId,
            @RequestParam(required = false) Long versionLangueId) {
        
        if (filmId != null) {
            seance.setFilm(seanceService.obtenirFilmById(filmId));
        }
        if (salleId != null) {
            seance.setSalle(seanceService.obtenirSalleById(salleId));
        }
        if (versionLangueId != null) {
            seance.setVersionLangue(seanceService.obtenirVersionLangueById(versionLangueId));
        }
        
        Seance seanceCree = seanceService.creerSeance(seance);
        return "redirect:/seances/" + seanceCree.getId();
    }

    @GetMapping("/{id}/modifier")
    public String formulaireModification(@PathVariable Long id, Model model) {
        Seance seance = seanceService.obtenirSeanceById(id);
        model.addAttribute("seance", seance);
        model.addAttribute("films", seanceService.obtenirTousLesFilms());
        model.addAttribute("salles", seanceService.obtenirToutesLesSalles());
        model.addAttribute("versionLangues", seanceService.obtenirToutesLesVersionsLangue());
        model.addAttribute("page", "seances/formulaire");
        model.addAttribute("pageTitle", "Modifier: " + seance.getFilm().getTitre());
        model.addAttribute("pageActive", "seances");
        return "layout";
    }

    @PostMapping("/{id}")
    public String modifierSeance(
            @PathVariable Long id,
            Seance seance,
            @RequestParam(required = false) Long filmId,
            @RequestParam(required = false) Long salleId,
            @RequestParam(required = false) Long versionLangueId) {
        
        if (filmId != null) {
            seance.setFilm(seanceService.obtenirFilmById(filmId));
        }
        if (salleId != null) {
            seance.setSalle(seanceService.obtenirSalleById(salleId));
        }
        if (versionLangueId != null) {
            seance.setVersionLangue(seanceService.obtenirVersionLangueById(versionLangueId));
        }
        
        seanceService.modifierSeance(id, seance);
        return "redirect:/seances/" + id;
    }

    @GetMapping("/{id}/supprimer")
    public String confirmationSuppression(@PathVariable Long id, Model model) {
        Seance seance = seanceService.obtenirSeanceById(id);
        model.addAttribute("seance", seance);
        model.addAttribute("page", "seances/suppression");
        model.addAttribute("pageTitle", "Supprimer: " + seance.getFilm().getTitre());
        model.addAttribute("pageActive", "seances");
        return "layout";
    }

    @PostMapping("/{id}/supprimer")
    public String supprimerSeance(@PathVariable Long id) {
        seanceService.supprimerSeance(id);
        return "redirect:/seances";
    }
}
