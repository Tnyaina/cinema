package cinema.publicite.societe;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/societes")
@RequiredArgsConstructor
public class SocieteController {

    private final SocieteRepository societeRepository;

    @GetMapping
    public String list(Model model) {
        model.addAttribute("page", "societes");
        model.addAttribute("pageTitle", "societes");
        model.addAttribute("societes", societeRepository.findAll());
        model.addAttribute("pageActive", "societes");
        return "layout";
    }

    @GetMapping("/{id}")
    public String detail(@PathVariable Long id, Model model) {
        return societeRepository.findById(id).map(societe -> {
            model.addAttribute("page", "societe-detail");
            model.addAttribute("pageTitle", "Détail Société");
            model.addAttribute("societe", societe);
            model.addAttribute("pageActive", "societes");

            return "layout";
        }).orElseThrow(() -> new RuntimeException("Société non trouvée"));
    }

    @PostMapping
    public String create(@RequestParam String libelle) {
        societeRepository.save(new Societe(libelle));
        return "redirect:/societes";
    }

    @PostMapping("/{id}/update")
    public String update(@PathVariable Long id, @RequestParam String libelle) {
        return societeRepository.findById(id).map(societe -> {
            societe.setLibelle(libelle);
            societeRepository.save(societe);
            return "redirect:/societes";
        }).orElseThrow(() -> new RuntimeException("Société non trouvée"));
    }

    @PostMapping("/{id}/delete")
    public String delete(@PathVariable Long id) {
        societeRepository.deleteById(id);
        return "redirect:/societes";
    }
}
