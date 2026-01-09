package cinema.referentiel.versionlangue;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@Controller
@RequestMapping("/versions-langue")
@RequiredArgsConstructor
public class VersionLangueController {

    private final VersionLangueService versionLangueService;

    @GetMapping
    public String listerVersionsLangue(
            @RequestParam(required = false) String search,
            Model model) {
        
        List<VersionLangue> versionsLangue;
        
        if (search != null && !search.trim().isEmpty()) {
            versionsLangue = versionLangueService.obtenirVersionLangueParCode(search.trim());
        } else {
            versionsLangue = versionLangueService.obtenirToutesLesVersionsLangue();
        }
        
        model.addAttribute("versionsLangue", versionsLangue);
        model.addAttribute("nombreVersionsLangue", versionsLangue.size());
        model.addAttribute("page", "referentiel/versionlangue/index");
        model.addAttribute("pageTitle", "Versions de langue");
        model.addAttribute("pageActive", "versionslangue");
        return "layout";
    }

    @GetMapping("/{id}")
    public String afficherDetail(@PathVariable Long id, Model model) {
        VersionLangue versionLangue = versionLangueService.obtenirVersionLangueById(id);
        model.addAttribute("versionLangue", versionLangue);
        model.addAttribute("page", "referentiel/versionlangue/detail");
        model.addAttribute("pageTitle", "Version de langue - " + versionLangue.getLibelle());
        model.addAttribute("pageActive", "versionslangue");
        return "layout";
    }

    @GetMapping("/nuevo")
    public String formulaireCreation(Model model) {
        model.addAttribute("versionLangue", new VersionLangue());
        model.addAttribute("langues", versionLangueService.obtenirToutesLesLangues());
        model.addAttribute("page", "referentiel/versionlangue/formulaire");
        model.addAttribute("pageTitle", "Ajouter une version de langue");
        model.addAttribute("pageActive", "versionslangue");
        return "layout";
    }

    @PostMapping
    public String creerVersionLangue(
            VersionLangue versionLangue,
            @RequestParam(required = false) Long langueAudioId,
            @RequestParam(required = false) Long langueSousTitreId) {
        
        if (langueAudioId != null) {
            versionLangue.setLangueAudio(versionLangueService.obtenirLangueById(langueAudioId));
        }
        if (langueSousTitreId != null) {
            versionLangue.setLangueSousTitre(versionLangueService.obtenirLangueById(langueSousTitreId));
        }
        
        VersionLangue creee = versionLangueService.creerVersionLangue(versionLangue);
        return "redirect:/versions-langue/" + creee.getId();
    }

    @GetMapping("/{id}/modifier")
    public String formulaireModification(@PathVariable Long id, Model model) {
        VersionLangue versionLangue = versionLangueService.obtenirVersionLangueById(id);
        model.addAttribute("versionLangue", versionLangue);
        model.addAttribute("langues", versionLangueService.obtenirToutesLesLangues());
        model.addAttribute("page", "referentiel/versionlangue/formulaire");
        model.addAttribute("pageTitle", "Modifier: " + versionLangue.getLibelle());
        model.addAttribute("pageActive", "versionslangue");
        return "layout";
    }

    @PostMapping("/{id}")
    public String modifierVersionLangue(
            @PathVariable Long id,
            VersionLangue versionLangue,
            @RequestParam(required = false) Long langueAudioId,
            @RequestParam(required = false) Long langueSousTitreId) {
        
        versionLangue.setId(id);
        if (langueAudioId != null) {
            versionLangue.setLangueAudio(versionLangueService.obtenirLangueById(langueAudioId));
        }
        if (langueSousTitreId != null) {
            versionLangue.setLangueSousTitre(versionLangueService.obtenirLangueById(langueSousTitreId));
        }
        
        versionLangueService.modifierVersionLangue(versionLangue);
        return "redirect:/versions-langue/" + id;
    }

    @GetMapping("/{id}/supprimer")
    public String formulaireSuppression(@PathVariable Long id, Model model) {
        VersionLangue versionLangue = versionLangueService.obtenirVersionLangueById(id);
        model.addAttribute("versionLangue", versionLangue);
        model.addAttribute("page", "referentiel/versionlangue/suppression");
        model.addAttribute("pageTitle", "Supprimer une version de langue");
        model.addAttribute("pageActive", "versionslangue");
        return "layout";
    }

    @PostMapping("/{id}/supprimer")
    public String supprimerVersionLangue(@PathVariable Long id) {
        versionLangueService.supprimerVersionLangue(id);
        return "redirect:/versions-langue";
    }
}
