package cinema.salle;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import java.util.List;
import cinema.place.PlaceService;

@Controller
@RequestMapping("/salles")
@RequiredArgsConstructor
public class SalleController {

    private final SalleService salleService;
    private final PlaceService placeService;

    @GetMapping
    public String listerSalles(
            @RequestParam(required = false) String recherche,
            Model model) {
        
        List<Salle> salles;
        
        if (recherche != null && !recherche.trim().isEmpty()) {
            salles = salleService.rechercherParNom(recherche);
        } else {
            salles = salleService.obtenirToutesLesSalles();
        }
        
        model.addAttribute("salles", salles);
        model.addAttribute("page", "salles/index");
        model.addAttribute("pageTitle", "Salles");
        model.addAttribute("pageActive", "salles");
        return "layout";
    }

    @GetMapping("/{id}")
    public String afficherDetail(@PathVariable Long id, Model model) {
        Salle salle = salleService.obtenirSalleById(id);
        model.addAttribute("salle", salle);
        model.addAttribute("placesParRangee", placeService.obtenirPlacesGroupeesParRangee(id));
        model.addAttribute("nombrePlaces", placeService.compterPlacesDeSalle(id));
        model.addAttribute("page", "salles/detail");
        model.addAttribute("pageTitle", salle.getNom());
        model.addAttribute("pageActive", "salles");
        return "layout";
    }

    @GetMapping("/nouveau")
    public String formulaireCreation(Model model) {
        model.addAttribute("salle", new Salle());
        model.addAttribute("page", "salles/formulaire");
        model.addAttribute("pageTitle", "Ajouter une salle");
        model.addAttribute("pageActive", "salles");
        return "layout";
    }

    @PostMapping
    public String creerSalle(Salle salle) {
        Salle salleCree = salleService.creerSalle(salle);
        return "redirect:/salles/" + salleCree.getId();
    }

    @GetMapping("/{id}/modifier")
    public String formulaireModification(@PathVariable Long id, Model model) {
        Salle salle = salleService.obtenirSalleById(id);
        model.addAttribute("salle", salle);
        model.addAttribute("page", "salles/formulaire");
        model.addAttribute("pageTitle", "Modifier: " + salle.getNom());
        model.addAttribute("pageActive", "salles");
        return "layout";
    }

    @PostMapping("/{id}")
    public String modifierSalle(@PathVariable Long id, Salle salle) {
        salleService.modifierSalle(id, salle);
        return "redirect:/salles/" + id;
    }

    @GetMapping("/{id}/supprimer")
    public String confirmationSuppression(@PathVariable Long id, Model model) {
        Salle salle = salleService.obtenirSalleById(id);
        model.addAttribute("salle", salle);
        model.addAttribute("page", "salles/suppression");
        model.addAttribute("pageTitle", "Supprimer: " + salle.getNom());
        model.addAttribute("pageActive", "salles");
        return "layout";
    }

    @PostMapping("/{id}/supprimer")
    public String supprimerSalle(@PathVariable Long id) {
        salleService.supprimerSalle(id);
        return "redirect:/salles";
    }
}
