package cinema.personne;

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
@RequestMapping("/personnes")
@RequiredArgsConstructor
public class PersonneController {

    private final PersonneService personneService;

    @GetMapping
    public String listerPersonnes(Model model) {
        model.addAttribute("personnes", personneService.obtenirToutesLesPersonnes());
        model.addAttribute("page", "personnes/index");
        model.addAttribute("pageTitle", "Personnes");
        model.addAttribute("pageActive", "personnes");
        return "layout";
    }

    @GetMapping("/{id}")
    public String afficherDetail(@PathVariable Long id, Model model) {
        Personne personne = personneService.obtenirPersonneById(id);
        model.addAttribute("personne", personne);
        model.addAttribute("page", "personnes/detail");
        model.addAttribute("pageTitle", "Personne");
        model.addAttribute("pageActive", "personnes");
        return "layout";
    }

    @GetMapping("/nouveau")
    public String formulaireCreation(Model model) {
        model.addAttribute("personne", new Personne());
        model.addAttribute("page", "personnes/formulaire");
        model.addAttribute("pageTitle", "Ajouter une personne");
        model.addAttribute("pageActive", "personnes");
        return "layout";
    }

    @PostMapping
    public String creerPersonne(
            @RequestParam String nomComplet,
            @RequestParam(required = false) String email,
            @RequestParam(required = false) String telephone) {
        
        Personne personne = new Personne();
        personne.setNomComplet(nomComplet);
        if (email != null && !email.trim().isEmpty()) {
            personne.setEmail(email);
        }
        if (telephone != null && !telephone.trim().isEmpty()) {
            personne.setTelephone(telephone);
        }
        
        try {
            Personne personneCreee = personneService.creerPersonne(personne);
            return "redirect:/personnes/" + personneCreee.getId();
        } catch (IllegalArgumentException e) {
            return "redirect:/personnes/nouveau?error=" + encodeError(e.getMessage());
        }
    }

    @GetMapping("/{id}/modifier")
    public String formulaireModification(@PathVariable Long id, Model model) {
        Personne personne = personneService.obtenirPersonneById(id);
        model.addAttribute("personne", personne);
        model.addAttribute("page", "personnes/formulaire");
        model.addAttribute("pageTitle", "Modifier la personne");
        model.addAttribute("pageActive", "personnes");
        return "layout";
    }

    @PostMapping("/{id}")
    public String modifierPersonne(
            @PathVariable Long id,
            @RequestParam String nomComplet,
            @RequestParam(required = false) String email,
            @RequestParam(required = false) String telephone) {
        
        Personne personneMaj = new Personne();
        personneMaj.setNomComplet(nomComplet);
        if (email != null && !email.trim().isEmpty()) {
            personneMaj.setEmail(email);
        }
        if (telephone != null && !telephone.trim().isEmpty()) {
            personneMaj.setTelephone(telephone);
        }
        
        try {
            personneService.modifierPersonne(id, personneMaj);
            return "redirect:/personnes/" + id;
        } catch (IllegalArgumentException e) {
            return "redirect:/personnes/" + id + "/modifier?error=" + encodeError(e.getMessage());
        }
    }

    @GetMapping("/{id}/supprimer")
    public String confirmationSuppression(@PathVariable Long id, Model model) {
        Personne personne = personneService.obtenirPersonneById(id);
        model.addAttribute("personne", personne);
        model.addAttribute("page", "personnes/confirmation-suppression");
        model.addAttribute("pageTitle", "Confirmer la suppression");
        model.addAttribute("pageActive", "personnes");
        return "layout";
    }

    @PostMapping("/{id}/supprimer")
    public String supprimerPersonne(@PathVariable Long id) {
        personneService.supprimerPersonne(id);
        return "redirect:/personnes?success=personne_supprimee";
    }

    private String encodeError(String message) {
        try {
            return URLEncoder.encode(message, StandardCharsets.UTF_8);
        } catch (Exception e) {
            return "erreur";
        }
    }
}
