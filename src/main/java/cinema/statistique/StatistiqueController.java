package cinema.statistique;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import cinema.publicite.diffusion.DiffusionPublicitaireRepository;
import cinema.publicite.diffusion.DiffusionPublicitaire;
import cinema.publicite.paiement.PaiementPublicite;
import cinema.publicite.paiement.PaiementPubliciteRepository;
import cinema.publicite.societe.Societe;
import cinema.publicite.societe.SocieteRepository;
import java.time.LocalDate;
import java.time.YearMonth;
import java.util.*;

@Controller
@RequiredArgsConstructor
public class StatistiqueController {

    private final StatistiqueService statistiqueService;
    private final DiffusionPublicitaireRepository diffusionPublicitaireRepository;
    private final PaiementPubliciteRepository paiementPubliciteRepository;
    private final SocieteRepository societeRepository;

    @GetMapping("/statistiques")
    public String statistiques(
            @RequestParam(name = "periode", defaultValue = "mois") String periode,
            @RequestParam(name = "mois", required = false) String moisParam,
            @RequestParam(name = "annee", required = false) Integer anneeParam,
            Model model) {

        // Déterminer la période par défaut (mois/année courants)
        final String mois;
        final Integer annee;
        if (moisParam == null || anneeParam == null) {
            YearMonth now = YearMonth.now();
            mois = String.format("%02d", now.getMonthValue());
            annee = now.getYear();
        } else {
            mois = moisParam;
            annee = anneeParam;
        }

        // Récupérer les statistiques selon le filtre
        StatistiqueDTO stats;
        if ("annee".equals(periode)) {
            stats = statistiqueService.getStatistiquesByAnnee(annee);
        } else {
            stats = statistiqueService.getStatistiquesByMoisAnnee(Integer.parseInt(mois), annee);
        }

        // Calculer le CA Publicité pour la période
        List<DiffusionPublicitaire> diffusions = diffusionPublicitaireRepository.findAll();
        Double pubCAPeriode = diffusions.stream()
            .filter(d -> {
                LocalDate dateDiff = d.getDateDiffusion().toLocalDate();
                if ("annee".equals(periode)) {
                    return dateDiff.getYear() == annee;
                } else {
                    return dateDiff.getYear() == annee && dateDiff.getMonthValue() == Integer.parseInt(mois);
                }
            })
            .mapToDouble(DiffusionPublicitaire::getTarifApplique)
            .sum();

        // Regrouper par société pour les paiements
        List<Societe> societes = societeRepository.findAll();
        List<Map<String, Object>> societesPaiements = new ArrayList<>();
        
        for (Societe societe : societes) {
            Map<String, Object> societeData = new HashMap<>();
            
            // CA Publicité pour cette société
            Double caPub = diffusions.stream()
                .filter(d -> {
                    LocalDate dateDiff = d.getDateDiffusion().toLocalDate();
                    boolean dateMatch = "annee".equals(periode) ? 
                        dateDiff.getYear() == annee : 
                        (dateDiff.getYear() == annee && dateDiff.getMonthValue() == Integer.parseInt(mois));
                    return d.getVideoPublicitaire().getSociete().getId().equals(societe.getId()) && dateMatch;
                })
                .mapToDouble(DiffusionPublicitaire::getTarifApplique)
                .sum();
            
            // Montant payé
            Double montantPaye = paiementPubliciteRepository.findBySocieteId(societe.getId())
                .stream()
                .filter(p -> {
                    if ("annee".equals(periode)) {
                        return p.getDatePaiement().getYear() == annee;
                    } else {
                        return p.getDatePaiement().getYear() == annee && p.getDatePaiement().getMonthValue() == Integer.parseInt(mois);
                    }
                })
                .mapToDouble(PaiementPublicite::getMontant)
                .sum();
            
            Double resteAPayer = caPub - montantPaye;
            
            societeData.put("id", societe.getId());
            societeData.put("nom", societe.getLibelle());
            societeData.put("caPub", caPub);
            societeData.put("montantPaye", montantPaye);
            societeData.put("resteAPayer", resteAPayer);
            
            if (caPub > 0) {
                societesPaiements.add(societeData);
            }
        }

        model.addAttribute("page", "statistiques");
        model.addAttribute("pageTitle", "Statistiques de Trésorerie");
        model.addAttribute("pageActive", "statistiques");
        model.addAttribute("stats", stats);
        model.addAttribute("periode", periode);
        model.addAttribute("mois", mois);
        model.addAttribute("annee", annee);
        model.addAttribute("anneeActuelle", LocalDate.now().getYear());
        model.addAttribute("pubCAPeriode", pubCAPeriode);
        model.addAttribute("societesPaiements", societesPaiements);
        model.addAttribute("today", LocalDate.now());

        return "layout";
    }
}
