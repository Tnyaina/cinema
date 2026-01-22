package cinema.publicite.tarif;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import cinema.publicite.type.TypeDiffusionPubRepository;
import cinema.publicite.societe.SocieteRepository;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

@Controller
@RequestMapping("/tarifs-publicite")
@RequiredArgsConstructor
public class TarifPubliciteController {

    private final TarifPubliciteDefautRepository tarifDefautRepository;
    private final TarifPublicitePersonnaliseRepository tarifPersonnaliseRepository;
    private final TypeDiffusionPubRepository typeRepository;
    private final SocieteRepository societeRepository;

    @GetMapping
    public String list(@RequestParam(required = false) String type, 
                      @RequestParam(required = false) Long societeId, 
                      Model model) {
        model.addAttribute("page", "tarifs-publicite");
        model.addAttribute("pageTitle", "Tarifs Publicité");
        model.addAttribute("pageActive", "tarifs-publicite");
        model.addAttribute("types", typeRepository.findAll());
        model.addAttribute("societes", societeRepository.findAll());
        
        if ("personnalise".equals(type)) {
            model.addAttribute("tarifPersonnalises", tarifPersonnaliseRepository.findAll());
            if (societeId != null) {
                model.addAttribute("societe", societeRepository.findById(societeId).orElse(null));
            }
            model.addAttribute("typeFiltre", "personnalise");
        } else {
            model.addAttribute("tarifDefauts", tarifDefautRepository.findAll());
            model.addAttribute("typeFiltre", "defaut");
        }
        
        return "layout";
    }

    @PostMapping("/defaut")
    public String createDefaut(@RequestParam Long typeId, 
                              @RequestParam Double prix,
                              @RequestParam String dateDebut) {
        try {
            LocalDate date = LocalDate.parse(dateDebut, DateTimeFormatter.ISO_DATE);
            return typeRepository.findById(typeId).map(type -> {
                tarifDefautRepository.save(new TarifPubliciteDefaut(type, prix, date));
                return "redirect:/tarifs-publicite";
            }).orElse("redirect:/tarifs-publicite");
        } catch (Exception e) {
            return "redirect:/tarifs-publicite";
        }
    }

    @PostMapping("/personnalise")
    public String createPersonnalise(@RequestParam Long societeId,
                                     @RequestParam Long typeId,
                                     @RequestParam Double prix,
                                     @RequestParam String dateDebut) {
        try {
            LocalDate date = LocalDate.parse(dateDebut, DateTimeFormatter.ISO_DATE);
            return societeRepository.findById(societeId).flatMap(societe ->
                typeRepository.findById(typeId).map(type -> {
                    tarifPersonnaliseRepository.save(new TarifPublicitePersonnalise(societe, type, prix, date));
                    return "redirect:/tarifs-publicite?type=personnalise&societeId=" + societeId;
                })
            ).orElse("redirect:/tarifs-publicite");
        } catch (Exception e) {
            return "redirect:/tarifs-publicite";
        }
    }

    @PostMapping("/{id}/delete")
    public String delete(@PathVariable Long id, @RequestParam String type) {
        if ("personnalise".equals(type)) {
            tarifPersonnaliseRepository.deleteById(id);
        } else {
            tarifDefautRepository.deleteById(id);
        }
        return "redirect:/tarifs-publicite?type=" + type;
    }
}
