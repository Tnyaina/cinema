package cinema.referentiel.typeplace;

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
@RequestMapping("/types-place")
@RequiredArgsConstructor
public class TypePlaceController {

    private final TypePlaceService typePlaceService;

    @GetMapping
    public String listerTypesPlace(Model model) {
        model.addAttribute("typesPlace", typePlaceService.obtenirTousLesTypesPlace());
        model.addAttribute("page", "types-place/index");
        model.addAttribute("pageTitle", "Types de place");
        model.addAttribute("pageActive", "types-place");
        return "layout";
    }

    @GetMapping("/{id}")
    public String afficherDetail(@PathVariable Long id, Model model) {
        TypePlace typePlace = typePlaceService.obtenirTypePlaceById(id);
        model.addAttribute("typePlace", typePlace);
        model.addAttribute("page", "types-place/detail");
        model.addAttribute("pageTitle", "Type de place");
        model.addAttribute("pageActive", "types-place");
        return "layout";
    }

    @GetMapping("/nouveau")
    public String formulaireCreation(Model model) {
        model.addAttribute("typePlace", new TypePlace());
        model.addAttribute("page", "types-place/formulaire");
        model.addAttribute("pageTitle", "Ajouter un type de place");
        model.addAttribute("pageActive", "types-place");
        return "layout";
    }

    @PostMapping
    public String creerTypePlace(
            @RequestParam String libelle) {
        
        TypePlace typePlace = new TypePlace();
        typePlace.setLibelle(libelle);
        
        try {
            TypePlace typePlaceCreee = typePlaceService.creerTypePlace(typePlace);
            return "redirect:/types-place/" + typePlaceCreee.getId();
        } catch (IllegalArgumentException e) {
            return "redirect:/types-place/nouveau?error=" + encodeError(e.getMessage());
        }
    }

    @GetMapping("/{id}/modifier")
    public String formulaireModification(@PathVariable Long id, Model model) {
        TypePlace typePlace = typePlaceService.obtenirTypePlaceById(id);
        model.addAttribute("typePlace", typePlace);
        model.addAttribute("page", "types-place/formulaire");
        model.addAttribute("pageTitle", "Modifier le type de place");
        model.addAttribute("pageActive", "types-place");
        return "layout";
    }

    @PostMapping("/{id}")
    public String modifierTypePlace(
            @PathVariable Long id,
            @RequestParam String libelle) {
        
        TypePlace typePlaceMaj = new TypePlace();
        typePlaceMaj.setLibelle(libelle);
        
        try {
            typePlaceService.modifierTypePlace(id, typePlaceMaj);
            return "redirect:/types-place/" + id;
        } catch (IllegalArgumentException e) {
            return "redirect:/types-place/" + id + "/modifier?error=" + encodeError(e.getMessage());
        }
    }

    @GetMapping("/{id}/supprimer")
    public String confirmationSuppression(@PathVariable Long id, Model model) {
        TypePlace typePlace = typePlaceService.obtenirTypePlaceById(id);
        model.addAttribute("typePlace", typePlace);
        model.addAttribute("page", "types-place/confirmation-suppression");
        model.addAttribute("pageTitle", "Confirmer la suppression");
        model.addAttribute("pageActive", "types-place");
        return "layout";
    }

    @PostMapping("/{id}/supprimer")
    public String supprimerTypePlace(@PathVariable Long id) {
        typePlaceService.supprimerTypePlace(id);
        return "redirect:/types-place?success=typeplace_supprime";
    }

    private String encodeError(String message) {
        try {
            return URLEncoder.encode(message, StandardCharsets.UTF_8);
        } catch (Exception e) {
            return "erreur";
        }
    }
}
