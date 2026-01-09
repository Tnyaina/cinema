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
@RequestMapping("/tarifs-seance")
@RequiredArgsConstructor
public class TarifSeanceController {

    private final TarifSeanceService tarifSeanceService;

    @GetMapping
    public String listerTarifSeances(
            @RequestParam(required = false) Long seance,
            @RequestParam(required = false) Long typePlace,
            @RequestParam(required = false) Long categoriePersonne,
            Model model) {
        
        List<TarifSeance> tarifSeances;
        
        // Appliquer les filtres
        if (seance != null) {
            tarifSeances = tarifSeanceService.obtenirTarifSeanceParSeance(seance);
            model.addAttribute("seanceSelectionnee", tarifSeanceService.obtenirSeanceById(seance));
        } else if (typePlace != null) {
            tarifSeances = tarifSeanceService.obtenirTarifSeanceParTypePlace(typePlace);
            model.addAttribute("typePlaceSelectionnee", tarifSeanceService.obtenirTypePlaceById(typePlace));
        } else if (categoriePersonne != null) {
            tarifSeances = tarifSeanceService.obtenirTarifSeanceParCategoriePersonne(categoriePersonne);
            model.addAttribute("categoriePersonneSelectionnee", tarifSeanceService.obtenirCategoriePersonneById(categoriePersonne));
        } else {
            tarifSeances = tarifSeanceService.obtenirTousTarifSeances();
        }
        
        model.addAttribute("tarifSeances", tarifSeances);
        model.addAttribute("seances", tarifSeanceService.obtenirToutesLesSeances());
        model.addAttribute("typesPlace", tarifSeanceService.obtenirTousLesTypesPlace());
        model.addAttribute("categoriesPersonne", tarifSeanceService.obtenirToutesLesCategoriesPersonne());
        model.addAttribute("page", "tarifs-seance/index");
        model.addAttribute("pageTitle", "Tarifs de séance");
        model.addAttribute("pageActive", "tarifs-seance");
        return "layout";
    }

    @GetMapping("/{id}")
    public String afficherDetail(@PathVariable Long id, Model model) {
        TarifSeance tarifSeance = tarifSeanceService.obtenirTarifSeanceById(id);
        model.addAttribute("tarifSeance", tarifSeance);
        model.addAttribute("page", "tarifs-seance/detail");
        model.addAttribute("pageTitle", "Tarif de séance");
        model.addAttribute("pageActive", "tarifs-seance");
        return "layout";
    }

    @GetMapping("/nouveau")
    public String formulaireCreation(
            @RequestParam(required = false) Long seance,
            Model model) {
        
        model.addAttribute("tarifSeance", new TarifSeance());
        model.addAttribute("seances", tarifSeanceService.obtenirToutesLesSeances());
        model.addAttribute("typesPlace", tarifSeanceService.obtenirTousLesTypesPlace());
        model.addAttribute("categoriesPersonne", tarifSeanceService.obtenirToutesLesCategoriesPersonne());
        
        if (seance != null) {
            model.addAttribute("seanceSelectionnee", tarifSeanceService.obtenirSeanceById(seance));
        }
        
        model.addAttribute("page", "tarifs-seance/formulaire");
        model.addAttribute("pageTitle", "Ajouter un tarif de séance");
        model.addAttribute("pageActive", "tarifs-seance");
        return "layout";
    }

    @PostMapping
    public String creerTarifSeance(
            @RequestParam Long seanceId,
            @RequestParam(required = false) Long typePlaceId,
            @RequestParam(required = false) Long categoriePersonneId,
            @RequestParam Double prix) {
        
        TarifSeance tarifSeance = new TarifSeance();
        tarifSeance.setSeance(tarifSeanceService.obtenirSeanceById(seanceId));
        
        if (typePlaceId != null) {
            tarifSeance.setTypePlace(tarifSeanceService.obtenirTypePlaceById(typePlaceId));
        }
        if (categoriePersonneId != null) {
            tarifSeance.setCategoriePersonne(tarifSeanceService.obtenirCategoriePersonneById(categoriePersonneId));
        }
        tarifSeance.setPrix(prix);
        
        try {
            TarifSeance tarifCreee = tarifSeanceService.creerTarifSeance(tarifSeance);
            return "redirect:/tarifs-seance/" + tarifCreee.getId();
        } catch (IllegalArgumentException e) {
            return "redirect:/tarifs-seance/nouveau?seance=" + seanceId + "&error=" + encodeError(e.getMessage());
        }
    }

    @GetMapping("/{id}/modifier")
    public String formulaireModification(@PathVariable Long id, Model model) {
        TarifSeance tarifSeance = tarifSeanceService.obtenirTarifSeanceById(id);
        model.addAttribute("tarifSeance", tarifSeance);
        model.addAttribute("seances", tarifSeanceService.obtenirToutesLesSeances());
        model.addAttribute("typesPlace", tarifSeanceService.obtenirTousLesTypesPlace());
        model.addAttribute("categoriesPersonne", tarifSeanceService.obtenirToutesLesCategoriesPersonne());
        model.addAttribute("page", "tarifs-seance/formulaire");
        model.addAttribute("pageTitle", "Modifier le tarif de séance");
        model.addAttribute("pageActive", "tarifs-seance");
        return "layout";
    }

    @PostMapping("/{id}")
    public String modifierTarifSeance(
            @PathVariable Long id,
            @RequestParam Long seanceId,
            @RequestParam(required = false) Long typePlaceId,
            @RequestParam(required = false) Long categoriePersonneId,
            @RequestParam Double prix) {
        
        TarifSeance tarifSeanceMaj = new TarifSeance();
        tarifSeanceMaj.setSeance(tarifSeanceService.obtenirSeanceById(seanceId));
        
        if (typePlaceId != null) {
            tarifSeanceMaj.setTypePlace(tarifSeanceService.obtenirTypePlaceById(typePlaceId));
        }
        if (categoriePersonneId != null) {
            tarifSeanceMaj.setCategoriePersonne(tarifSeanceService.obtenirCategoriePersonneById(categoriePersonneId));
        }
        tarifSeanceMaj.setPrix(prix);
        
        try {
            tarifSeanceService.modifierTarifSeance(id, tarifSeanceMaj);
            return "redirect:/tarifs-seance/" + id;
        } catch (IllegalArgumentException e) {
            return "redirect:/tarifs-seance/" + id + "/modifier?error=" + encodeError(e.getMessage());
        }
    }

    @GetMapping("/{id}/supprimer")
    public String confirmationSuppression(@PathVariable Long id, Model model) {
        TarifSeance tarifSeance = tarifSeanceService.obtenirTarifSeanceById(id);
        model.addAttribute("tarifSeance", tarifSeance);
        model.addAttribute("page", "tarifs-seance/confirmation-suppression");
        model.addAttribute("pageTitle", "Confirmer la suppression");
        model.addAttribute("pageActive", "tarifs-seance");
        return "layout";
    }

    @PostMapping("/creerEnMasse")
    public String creerEnMasseTarifSeance(
            @RequestParam Long seanceId,
            @RequestParam(name = "typePlaceIds[]", required = false) List<Long> typePlaceIds,
            @RequestParam(name = "categoriePersonneIds[]", required = false) List<Long> categoriePersonneIds,
            @RequestParam(name = "prix[]") List<Double> prix) {
        
        try {
            tarifSeanceService.creerTarifSeancesEnMasse(seanceId, typePlaceIds, categoriePersonneIds, prix);
            return "redirect:/tarifs-seance?success=tarifs_crees";
        } catch (IllegalArgumentException e) {
            return "redirect:/tarifs-seance/nouveau?seance=" + seanceId + "&error=" + encodeError(e.getMessage());
        }
    }

    private String encodeError(String message) {
        try {
            return URLEncoder.encode(message, StandardCharsets.UTF_8);
        } catch (Exception e) {
            return "erreur";
        }
    }
}
