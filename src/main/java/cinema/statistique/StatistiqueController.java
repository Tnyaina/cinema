package cinema.statistique;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import java.time.LocalDate;
import java.time.YearMonth;

@Controller
@RequiredArgsConstructor
public class StatistiqueController {

    private final StatistiqueService statistiqueService;

    @GetMapping("/statistiques")
    public String statistiques(
            @RequestParam(name = "periode", defaultValue = "mois") String periode,
            @RequestParam(name = "mois", required = false) String mois,
            @RequestParam(name = "annee", required = false) Integer annee,
            Model model) {

        // Déterminer la période par défaut (mois/année courants)
        if (mois == null || annee == null) {
            YearMonth now = YearMonth.now();
            mois = String.format("%02d", now.getMonthValue());
            annee = now.getYear();
        }

        // Récupérer les statistiques selon le filtre
        StatistiqueDTO stats;
        if ("annee".equals(periode)) {
            stats = statistiqueService.getStatistiquesByAnnee(annee);
        } else {
            stats = statistiqueService.getStatistiquesByMoisAnnee(Integer.parseInt(mois), annee);
        }

        model.addAttribute("page", "statistiques");
        model.addAttribute("pageTitle", "Statistiques de Trésorerie");
        model.addAttribute("pageActive", "statistiques");
        model.addAttribute("stats", stats);
        model.addAttribute("periode", periode);
        model.addAttribute("mois", mois);
        model.addAttribute("annee", annee);
        model.addAttribute("anneeActuelle", LocalDate.now().getYear());

        return "layout";
    }
}
