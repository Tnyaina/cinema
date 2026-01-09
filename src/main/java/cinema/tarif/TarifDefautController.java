package cinema.tarif;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import java.util.List;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@Controller
@RequestMapping("/tarifs-defaut")
@RequiredArgsConstructor
public class TarifDefautController {

    private final TarifDefautService tarifDefautService;

    @GetMapping
    public String listerTarifDefauts(Model model) {
        List<TarifDefaut> tarifDefauts = tarifDefautService.obtenirTousTarifDefauts();
        model.addAttribute("tarifDefauts", tarifDefauts);
        model.addAttribute("page", "tarifs-defaut/index");
        model.addAttribute("pageTitle", "Tarifs par défaut");
        model.addAttribute("pageActive", "tarifs-defaut");
        return "layout";
    }

    @GetMapping("/{id}")
    public String afficherDetail(@PathVariable Long id, Model model) {
        TarifDefaut tarifDefaut = tarifDefautService.obtenirTarifDefautById(id);
        model.addAttribute("tarifDefaut", tarifDefaut);
        model.addAttribute("page", "tarifs-defaut/detail");
        model.addAttribute("pageTitle", "Tarif défaut");
        model.addAttribute("pageActive", "tarifs-defaut");
        return "layout";
    }

    @GetMapping("/nouveau")
    public String formulaireCreation(Model model) {
        model.addAttribute("tarifDefaut", new TarifDefaut());
        model.addAttribute("typesPlace", tarifDefautService.obtenirTousLesTypesPlace());
        model.addAttribute("categoriesPersonne", tarifDefautService.obtenirToutesLesCategoriesPersonne());
        model.addAttribute("page", "tarifs-defaut/formulaire");
        model.addAttribute("pageTitle", "Ajouter un tarif par défaut");
        model.addAttribute("pageActive", "tarifs-defaut");
        return "layout";
    }

    @PostMapping
    public String creerTarifDefaut(
            @RequestParam(required = false) Long typePlaceId,
            @RequestParam(required = false) Long categoriePersonneId,
            @RequestParam Double prix) {
        
        TarifDefaut tarifDefaut = new TarifDefaut();
        
        if (typePlaceId != null) {
            tarifDefaut.setTypePlace(tarifDefautService.obtenirTypePlaceById(typePlaceId));
        }
        if (categoriePersonneId != null) {
            tarifDefaut.setCategoriePersonne(tarifDefautService.obtenirCategoriePersonneById(categoriePersonneId));
        }
        tarifDefaut.setPrix(prix);
        
        try {
            TarifDefaut tarifCreee = tarifDefautService.creerTarifDefaut(tarifDefaut);
            return "redirect:/tarifs-defaut/" + tarifCreee.getId();
        } catch (IllegalArgumentException e) {
            return "redirect:/tarifs-defaut/nouveau?error=" + encodeError(e.getMessage());
        }
    }

    @GetMapping("/{id}/modifier")
    public String formulaireModification(@PathVariable Long id, Model model) {
        TarifDefaut tarifDefaut = tarifDefautService.obtenirTarifDefautById(id);
        model.addAttribute("tarifDefaut", tarifDefaut);
        model.addAttribute("typesPlace", tarifDefautService.obtenirTousLesTypesPlace());
        model.addAttribute("categoriesPersonne", tarifDefautService.obtenirToutesLesCategoriesPersonne());
        model.addAttribute("page", "tarifs-defaut/formulaire");
        model.addAttribute("pageTitle", "Modifier le tarif par défaut");
        model.addAttribute("pageActive", "tarifs-defaut");
        return "layout";
    }

    @PostMapping("/{id}")
    public String modifierTarifDefaut(
            @PathVariable Long id,
            @RequestParam(required = false) Long typePlaceId,
            @RequestParam(required = false) Long categoriePersonneId,
            @RequestParam Double prix) {
        
        TarifDefaut tarifDefautMaj = new TarifDefaut();
        
        if (typePlaceId != null) {
            tarifDefautMaj.setTypePlace(tarifDefautService.obtenirTypePlaceById(typePlaceId));
        }
        if (categoriePersonneId != null) {
            tarifDefautMaj.setCategoriePersonne(tarifDefautService.obtenirCategoriePersonneById(categoriePersonneId));
        }
        tarifDefautMaj.setPrix(prix);
        
        try {
            tarifDefautService.modifierTarifDefaut(id, tarifDefautMaj);
            return "redirect:/tarifs-defaut/" + id;
        } catch (IllegalArgumentException e) {
            return "redirect:/tarifs-defaut/" + id + "/modifier?error=" + encodeError(e.getMessage());
        }
    }

    @GetMapping("/{id}/supprimer")
    public String confirmationSuppression(@PathVariable Long id, Model model) {
        TarifDefaut tarifDefaut = tarifDefautService.obtenirTarifDefautById(id);
        model.addAttribute("tarifDefaut", tarifDefaut);
        model.addAttribute("page", "tarifs-defaut/confirmation-suppression");
        model.addAttribute("pageTitle", "Confirmer la suppression");
        model.addAttribute("pageActive", "tarifs-defaut");
        return "layout";
    }

    @PostMapping("/{id}/supprimer")
    public String supprimerTarifDefaut(@PathVariable Long id) {
        tarifDefautService.supprimerTarifDefaut(id);
        return "redirect:/tarifs-defaut?success=tarif_supprime";
    }

    private String encodeError(String message) {
        try {
            return URLEncoder.encode(message, StandardCharsets.UTF_8);
        } catch (Exception e) {
            return "erreur";
        }
    }
}
