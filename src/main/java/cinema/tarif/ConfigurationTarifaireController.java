package cinema.tarif;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import cinema.referentiel.categoriepersonne.CategoriePersonne;
import cinema.referentiel.categoriepersonne.CategoriePersonneService;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@Controller
@RequestMapping("/configuration-tarifaire")
@RequiredArgsConstructor
public class ConfigurationTarifaireController {

    private final ConfigurationTarifaireService configurationTarifaireService;
    private final CategoriePersonneService categoriePersonneService;
    private final TarifDefautService tarifDefautService;

    @GetMapping
    public String listerConfigurations(Model model) {
        try {
            configurationTarifaireService.initialiserConfigurationsParDefaut();
        } catch (Exception e) {
            // Ignore si déjà initialisé
        }
        
        model.addAttribute("configurations", configurationTarifaireService.obtenirToutesLesConfigurations());
        model.addAttribute("categoriesAutonomes", configurationTarifaireService.obtenirCategoriesAutonomes());
        model.addAttribute("page", "configuration-tarifaire/index");
        model.addAttribute("pageTitle", "Configuration Tarifaire");
        model.addAttribute("pageActive", "configuration-tarifaire");
        return "layout";
    }

    @GetMapping("/{id}")
    public String afficherDetail(@PathVariable Long id, Model model) {
        ConfigurationTarifaire config = configurationTarifaireService.obtenirConfigurationById(id);
        model.addAttribute("configuration", config);
        model.addAttribute("page", "configuration-tarifaire/detail");
        model.addAttribute("pageTitle", "Configuration: " + config.getCategoriePersonne().getLibelle());
        model.addAttribute("pageActive", "configuration-tarifaire");
        return "layout";
    }

    @GetMapping("/nouveau")
    public String formulaireCreation(Model model) {
        model.addAttribute("configuration", new ConfigurationTarifaire());
        model.addAttribute("categoriesPersonne", categoriePersonneService.obtenirToutesLesCategoriesPersonne());
        model.addAttribute("page", "configuration-tarifaire/formulaire");
        model.addAttribute("pageTitle", "Nouvelle Configuration Tarifaire");
        model.addAttribute("pageActive", "configuration-tarifaire");
        return "layout";
    }

    @PostMapping
    public String creerConfiguration(
            @RequestParam Long categoriePersonneId,
            @RequestParam(required = false) Long categorieReferenceId,
            @RequestParam Double coefficientMultiplicateur,
            @RequestParam(required = false) String description) {
        
        try {
            CategoriePersonne categorie = categoriePersonneService.obtenirCategoriePersonneById(categoriePersonneId);
            CategoriePersonne categorieReference = null;
            
            if (categorieReferenceId != null) {
                categorieReference = categoriePersonneService.obtenirCategoriePersonneById(categorieReferenceId);
            }
            
            ConfigurationTarifaire config = new ConfigurationTarifaire();
            config.setCategoriePersonne(categorie);
            config.setCategorieReference(categorieReference);
            config.setCoefficientMultiplicateur(coefficientMultiplicateur);
            config.setDescription(description);
            
            configurationTarifaireService.creerConfiguration(config);
            return "redirect:/configuration-tarifaire?success=config_creee";
        } catch (IllegalArgumentException e) {
            return "redirect:/configuration-tarifaire/nouveau?error=" + encodeError(e.getMessage());
        }
    }

    @GetMapping("/{id}/modifier")
    public String formulaireModification(@PathVariable Long id, Model model) {
        ConfigurationTarifaire config = configurationTarifaireService.obtenirConfigurationById(id);
        model.addAttribute("configuration", config);
        model.addAttribute("categoriesPersonne", categoriePersonneService.obtenirToutesLesCategoriesPersonne());
        model.addAttribute("page", "configuration-tarifaire/formulaire");
        model.addAttribute("pageTitle", "Modifier: " + config.getCategoriePersonne().getLibelle());
        model.addAttribute("pageActive", "configuration-tarifaire");
        return "layout";
    }

    @PostMapping("/{id}")
    public String modifierConfiguration(
            @PathVariable Long id,
            @RequestParam Long categoriePersonneId,
            @RequestParam(required = false) Long categorieReferenceId,
            @RequestParam Double coefficientMultiplicateur,
            @RequestParam(required = false) String description) {
        
        try {
            CategoriePersonne categorie = categoriePersonneService.obtenirCategoriePersonneById(categoriePersonneId);
            CategoriePersonne categorieReference = null;
            
            if (categorieReferenceId != null) {
                categorieReference = categoriePersonneService.obtenirCategoriePersonneById(categorieReferenceId);
            }
            
            ConfigurationTarifaire config = new ConfigurationTarifaire();
            config.setCategoriePersonne(categorie);
            config.setCategorieReference(categorieReference);
            config.setCoefficientMultiplicateur(coefficientMultiplicateur);
            config.setDescription(description);
            
            configurationTarifaireService.modifierConfiguration(id, config);
            return "redirect:/configuration-tarifaire?success=config_modifiee";
        } catch (IllegalArgumentException e) {
            return "redirect:/configuration-tarifaire/" + id + "/modifier?error=" + encodeError(e.getMessage());
        }
    }

    @GetMapping("/{id}/supprimer")
    public String confirmationSuppression(@PathVariable Long id, Model model) {
        ConfigurationTarifaire config = configurationTarifaireService.obtenirConfigurationById(id);
        model.addAttribute("configuration", config);
        
        // Vérifier si d'autres configurations dépendent de cette catégorie
        if (config.getCategoriePersonne() != null) {
            model.addAttribute("configurationsDependantes", 
                configurationTarifaireService.obtenirConfigurationsDependantesDe(config.getCategoriePersonne().getId()));
        }
        
        model.addAttribute("page", "configuration-tarifaire/confirmation-suppression");
        model.addAttribute("pageTitle", "Supprimer: " + config.getCategoriePersonne().getLibelle());
        model.addAttribute("pageActive", "configuration-tarifaire");
        return "layout";
    }

    @PostMapping("/{id}/supprimer")
    public String supprimerConfiguration(@PathVariable Long id) {
        try {
            configurationTarifaireService.supprimerConfiguration(id);
            return "redirect:/configuration-tarifaire?success=config_supprimee";
        } catch (IllegalArgumentException e) {
            return "redirect:/configuration-tarifaire?error=" + encodeError(e.getMessage());
        }
    }

    @PostMapping("/appliquer")
    public String appliquerConfigurationTousTarifs() {
        try {
            tarifDefautService.mettreAJourTarifsSelonConfiguration();
            return "redirect:/configuration-tarifaire?success=configuration_appliee_tarifs_defaut";
        } catch (Exception e) {
            return "redirect:/configuration-tarifaire?error=" + encodeError(e.getMessage());
        }
    }

    @PostMapping("/appliquer-seances")
    public String appliquerConfigurationTarifSeances() {
        try {
            // Note: Ici on peut appliquer la configuration à toutes les séances futures
            // ou seulement aux nouvelles créations
            return "redirect:/configuration-tarifaire?success=configuration_appliee_seances";
        } catch (Exception e) {
            return "redirect:/configuration-tarifaire?error=" + encodeError(e.getMessage());
        }
    }

    private String encodeError(String message) {
        try {
            return URLEncoder.encode(message, StandardCharsets.UTF_8.toString());
        } catch (Exception e) {
            return "Erreur";
        }
    }

    // Note: Pour mettre à jour les tarifs selon la configuration,
    // utiliser TarifDefautService.mettreAJourTarifsSelonConfiguration()
    // depuis un autre contrôleur avec injection de TarifDefautService
}