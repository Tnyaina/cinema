package cinema.publicite.paiement;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import cinema.publicite.societe.SocieteRepository;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

@Controller
@RequestMapping("/paiements-publicite")
@RequiredArgsConstructor
public class PaiementPubliciteController {

    private final PaiementPubliciteRepository paiementRepository;
    private final SocieteRepository societeRepository;

    @GetMapping
    public String list(@RequestParam(required = false) Long societeId, Model model) {
        model.addAttribute("page", "paiements-publicite");
        model.addAttribute("pageTitle", "Paiements Publicité");
        model.addAttribute("pageActive", "paiements-publicite");
        
        if (societeId != null) {
            model.addAttribute("paiements", paiementRepository.findBySocieteId(societeId));
            model.addAttribute("societe", societeRepository.findById(societeId).orElse(null));
        } else {
            model.addAttribute("paiements", paiementRepository.findAll());
        }
        
        model.addAttribute("societes", societeRepository.findAll());
        return "layout";
    }

    @PostMapping
    public String create(@RequestParam Long societeId,
                        @RequestParam Double montant,
                        @RequestParam String datePaiement) {
        try {
            LocalDate date = LocalDate.parse(datePaiement, DateTimeFormatter.ISO_DATE);
            return societeRepository.findById(societeId).map(societe -> {
                paiementRepository.save(new PaiementPublicite(societe, montant, date));
                return "redirect:/paiements-publicite?societeId=" + societeId;
            }).orElse("redirect:/paiements-publicite");
        } catch (Exception e) {
            return "redirect:/paiements-publicite";
        }
    }

    @PostMapping("/{id}/delete")
    public String delete(@PathVariable Long id) {
        paiementRepository.deleteById(id);
        return "redirect:/paiements-publicite";
    }
}
