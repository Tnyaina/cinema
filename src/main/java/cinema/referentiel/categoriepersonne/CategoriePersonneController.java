package cinema.referentiel.categoriepersonne;

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
@RequestMapping("/categories-personne")
@RequiredArgsConstructor
public class CategoriePersonneController {

    private final CategoriePersonneService categoriePersonneService;

    @GetMapping
    public String listerCategoriesPersonne(Model model) {
        model.addAttribute("categoriesPersonne", categoriePersonneService.obtenirToutesLesCategoriesPersonne());
        model.addAttribute("page", "categories-personne/index");
        model.addAttribute("pageTitle", "Catégories de personne");
        model.addAttribute("pageActive", "categories-personne");
        return "layout";
    }

    @GetMapping("/{id}")
    public String afficherDetail(@PathVariable Long id, Model model) {
        CategoriePersonne categoriePersonne = categoriePersonneService.obtenirCategoriePersonneById(id);
        model.addAttribute("categoriePersonne", categoriePersonne);
        model.addAttribute("page", "categories-personne/detail");
        model.addAttribute("pageTitle", "Catégorie de personne");
        model.addAttribute("pageActive", "categories-personne");
        return "layout";
    }

    @GetMapping("/nouveau")
    public String formulaireCreation(Model model) {
        model.addAttribute("categoriePersonne", new CategoriePersonne());
        model.addAttribute("page", "categories-personne/formulaire");
        model.addAttribute("pageTitle", "Ajouter une catégorie de personne");
        model.addAttribute("pageActive", "categories-personne");
        return "layout";
    }

    @PostMapping
    public String creerCategoriePersonne(
            @RequestParam String libelle) {
        
        CategoriePersonne categoriePersonne = new CategoriePersonne();
        categoriePersonne.setLibelle(libelle);
        
        try {
            CategoriePersonne categorieCreee = categoriePersonneService.creerCategoriePersonne(categoriePersonne);
            return "redirect:/categories-personne/" + categorieCreee.getId();
        } catch (IllegalArgumentException e) {
            return "redirect:/categories-personne/nouveau?error=" + encodeError(e.getMessage());
        }
    }

    @GetMapping("/{id}/modifier")
    public String formulaireModification(@PathVariable Long id, Model model) {
        CategoriePersonne categoriePersonne = categoriePersonneService.obtenirCategoriePersonneById(id);
        model.addAttribute("categoriePersonne", categoriePersonne);
        model.addAttribute("page", "categories-personne/formulaire");
        model.addAttribute("pageTitle", "Modifier la catégorie de personne");
        model.addAttribute("pageActive", "categories-personne");
        return "layout";
    }

    @PostMapping("/{id}")
    public String modifierCategoriePersonne(
            @PathVariable Long id,
            @RequestParam String libelle) {
        
        CategoriePersonne categorieMaj = new CategoriePersonne();
        categorieMaj.setLibelle(libelle);
        
        try {
            categoriePersonneService.modifierCategoriePersonne(id, categorieMaj);
            return "redirect:/categories-personne/" + id;
        } catch (IllegalArgumentException e) {
            return "redirect:/categories-personne/" + id + "/modifier?error=" + encodeError(e.getMessage());
        }
    }

    @GetMapping("/{id}/supprimer")
    public String confirmationSuppression(@PathVariable Long id, Model model) {
        CategoriePersonne categoriePersonne = categoriePersonneService.obtenirCategoriePersonneById(id);
        model.addAttribute("categoriePersonne", categoriePersonne);
        model.addAttribute("page", "categories-personne/confirmation-suppression");
        model.addAttribute("pageTitle", "Confirmer la suppression");
        model.addAttribute("pageActive", "categories-personne");
        return "layout";
    }

    @PostMapping("/{id}/supprimer")
    public String supprimerCategoriePersonne(@PathVariable Long id) {
        categoriePersonneService.supprimerCategoriePersonne(id);
        return "redirect:/categories-personne?success=categorie_supprimee";
    }

    private String encodeError(String message) {
        try {
            return URLEncoder.encode(message, StandardCharsets.UTF_8);
        } catch (Exception e) {
            return "erreur";
        }
    }
}
