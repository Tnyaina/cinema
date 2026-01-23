package cinema.publicite.paiement;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import cinema.publicite.societe.SocieteRepository;
import cinema.publicite.diffusion.DiffusionPublicitaireRepository;
import cinema.publicite.diffusion.DiffusionPublicitaire;
import java.time.LocalDate;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@Controller
@RequestMapping("/paiements-publicite")
@RequiredArgsConstructor
public class PaiementPubliciteController {

    private final PaiementPubliciteRepository paiementRepository;
    private final PaiementPubliciteDetailsRepository paiementDetailsRepository;
    private final SocieteRepository societeRepository;
    private final DiffusionPublicitaireRepository diffusionRepository;

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
                // Déterminer la période (mois) basée sur la date de paiement
                YearMonth periode = YearMonth.from(date);
                
                // Récupérer toutes les diffusions du mois pour cette société
                List<DiffusionPublicitaire> diffusionsDuMois = diffusionRepository.findAll().stream()
                    .filter(d -> {
                        YearMonth diffusionMois = YearMonth.from(d.getDateDiffusion().toLocalDate());
                        return diffusionMois.equals(periode) && 
                               d.getVideoPublicitaire().getSociete().getId().equals(societeId);
                    })
                    .toList();
                
                // Calculer le montant total dû pour cette période
                Double montantTotalDu = diffusionsDuMois.stream()
                    .mapToDouble(DiffusionPublicitaire::getTarifApplique)
                    .sum();
                
                if (montantTotalDu <= 0) {
                    return "redirect:/paiements-publicite?error=Aucune diffusion trouvée pour cette période";
                }
                
                // Calculer le pourcentage du paiement par rapport au montant total
                Double pourcentage = (montant / montantTotalDu) * 100;
                System.out.println("💰 Paiement de " + montant + "Ar pour " + societe.getLibelle() + 
                                 " (" + String.format("%.2f", pourcentage) + "% du montant dû)");
                
                // Enregistrer le paiement principal
                PaiementPublicite paiement = new PaiementPublicite(societe, montant, date);
                paiement.setMontantPaye(montant);
                PaiementPublicite paiementSauve = paiementRepository.save(paiement);
                
                // Créer les détails de paiement pour chaque diffusion avec proratasation
                for (DiffusionPublicitaire diffusion : diffusionsDuMois) {
                    Double montantProratasé = (diffusion.getTarifApplique() / montantTotalDu) * montant;
                    PaiementPubliciteDetails detail = new PaiementPubliciteDetails(
                        paiementSauve,
                        diffusion,
                        montantProratasé
                    );
                    paiementDetailsRepository.save(detail);
                }
                
                // Encoder le message de succès pour éviter les problèmes d'encodage UTF-8
                String successMessage = URLEncoder.encode("Paiement enregistre avec proratasation", StandardCharsets.UTF_8);
                return "redirect:/paiements-publicite?societeId=" + societeId + "&success=" + successMessage;
            }).orElse("redirect:/paiements-publicite?error=Société non trouvée");
        } catch (Exception e) {
            return "redirect:/paiements-publicite?error=" + e.getMessage();
        }
    }

    @PostMapping("/{id}/delete")
    public String delete(@PathVariable Long id) {
        paiementRepository.deleteById(id);
        return "redirect:/paiements-publicite";
    }
}
