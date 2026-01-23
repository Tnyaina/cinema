package cinema.statistique;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import cinema.publicite.diffusion.DiffusionPublicitaireRepository;
import cinema.publicite.diffusion.DiffusionPublicitaire;
import cinema.publicite.paiement.PaiementPublicite;
import cinema.publicite.paiement.PaiementPubliciteRepository;
import cinema.publicite.paiement.PaiementPubliciteDetailsRepository;
import cinema.publicite.societe.Societe;
import cinema.publicite.societe.SocieteRepository;
import cinema.seance.SeanceRepository;
import cinema.seance.Seance;
import cinema.ticket.TicketRepository;
import java.time.LocalDate;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Controller
@RequiredArgsConstructor
public class StatistiqueController {

    private final StatistiqueService statistiqueService;
    private final DiffusionPublicitaireRepository diffusionPublicitaireRepository;
    private final PaiementPubliciteRepository paiementPubliciteRepository;
    private final PaiementPubliciteDetailsRepository paiementPubliciteDetailsRepository;
    private final SocieteRepository societeRepository;
    private final SeanceRepository seanceRepository;
    private final TicketRepository ticketRepository;

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

    @GetMapping("/chiffres-affaires-diffusions")
    public String chiffresAffairesDiffusions(
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

        // Récupérer toutes les séances
        List<Seance> seances = seanceRepository.findAll();
        List<Map<String, Object>> diffusionsData = new ArrayList<>();
        Double caTotalTickets = 0.0;
        Double caTotalPublicites = 0.0;
        Double caTotalPublicitesPaye = 0.0;
        Double caTotalResteAPayer = 0.0;
        Long totalNbDiffusions = 0L;

        for (Seance seance : seances) {
            LocalDate dateSeance = seance.getDebut().toLocalDate();
            
            // Filtrer par période
            if ("annee".equals(periode)) {
                if (dateSeance.getYear() != annee) continue;
            } else {
                if (dateSeance.getYear() != annee || dateSeance.getMonthValue() != Integer.parseInt(mois)) {
                    continue;
                }
            }

            // Récupérer les tickets valides (status != 3, annulés)
            List<?> ticketsValides = ticketRepository.findBySeanceId(seance.getId()).stream()
                .filter(t -> t.getStatus() != null && t.getStatus().getId() != 3)
                .toList();

            Double caTickets = 0.0;
            for (Object ticketObj : ticketsValides) {
                cinema.ticket.Ticket ticket = (cinema.ticket.Ticket) ticketObj;
                if (ticket.getPrix() != null) {
                    caTickets += ticket.getPrix();
                }
            }

            // Récupérer les diffusions publicitaires pour cette séance
            List<DiffusionPublicitaire> diffusions = diffusionPublicitaireRepository.findBySeanceId(seance.getId());
            Long nbDiffusions = (long) diffusions.size();
            Double caPublicites = diffusions.stream()
                .mapToDouble(DiffusionPublicitaire::getTarifApplique)
                .sum();

            // Calculer le montant payé pour les publicités de cette séance
            Double caPublicitesPaye = 0.0;
            for (DiffusionPublicitaire diffusion : diffusions) {
                Double montantPaye = paiementPubliciteDetailsRepository
                    .findByDiffusionPublicitaireId(diffusion.getId())
                    .stream()
                    .mapToDouble(detail -> detail.getMontant() != null ? detail.getMontant() : 0.0)
                    .sum();
                caPublicitesPaye += montantPaye;
            }

            Double caTotal = caTickets + caPublicites;
            Double resteAPayer = caPublicites - caPublicitesPaye;

            Map<String, Object> data = new HashMap<>();
            data.put("film", seance.getFilm().getTitre());
            data.put("dateDiffusion", dateSeance.format(DateTimeFormatter.ofPattern("dd/MM/yyyy")));
            data.put("heureDiffusion", seance.getDebut().toLocalTime().format(DateTimeFormatter.ofPattern("HH:mm")));
            data.put("nbDiffusions", nbDiffusions);
            data.put("caTickets", caTickets);
            data.put("caPublicites", caPublicites);
            data.put("caPublicitesPaye", caPublicitesPaye);
            data.put("resteAPayer", resteAPayer);
            data.put("caTotal", caTotal);

            diffusionsData.add(data);
            caTotalTickets += caTickets;
            caTotalPublicites += caPublicites;
            caTotalPublicitesPaye += caPublicitesPaye;
            caTotalResteAPayer += resteAPayer;
            totalNbDiffusions += nbDiffusions;
        }

        Double caTotalGlobal = caTotalTickets + caTotalPublicites;

        model.addAttribute("page", "chiffre-affaires-diffusions");
        model.addAttribute("pageTitle", "Chiffres d'affaires par diffusion");
        model.addAttribute("pageActive", "chiffres-affaires");
        model.addAttribute("diffusionsData", diffusionsData);
        model.addAttribute("caTotalTickets", caTotalTickets);
        model.addAttribute("caTotalPublicites", caTotalPublicites);
        model.addAttribute("caTotalPublicitesPaye", caTotalPublicitesPaye);
        model.addAttribute("caTotalResteAPayer", caTotalResteAPayer);
        model.addAttribute("caTotalGlobal", caTotalGlobal);
        model.addAttribute("totalNbDiffusions", totalNbDiffusions);
        model.addAttribute("periode", periode);
        model.addAttribute("mois", mois);
        model.addAttribute("annee", annee);
        model.addAttribute("anneeActuelle", LocalDate.now().getYear());

        return "layout";
    }

    @GetMapping("/api/diffusions-periode")
    @ResponseBody
    public List<Map<String, Object>> getDiffusionsPeriode(
            @RequestParam(required = false) Long societeId,
            @RequestParam(required = false) Integer annee,
            @RequestParam(required = false) String mois) {
        
        List<Map<String, Object>> result = new ArrayList<>();
        
        // Valider les paramètres
        if (societeId == null || societeId <= 0) {
            Map<String, Object> error = new HashMap<>();
            error.put("montantTotal", 0);
            result.add(error);
            return result;
        }
        
        if (annee == null || annee <= 0) {
            annee = LocalDate.now().getYear();
        }
        
        // Déterminer le mois
        int moisInt;
        if (mois != null && !mois.isEmpty() && !mois.equals("undefined")) {
            try {
                moisInt = Integer.parseInt(mois);
                if (moisInt < 1 || moisInt > 12) {
                    moisInt = LocalDate.now().getMonthValue();
                }
            } catch (NumberFormatException e) {
                moisInt = LocalDate.now().getMonthValue();
            }
        } else {
            moisInt = LocalDate.now().getMonthValue();
        }
        
        final YearMonth periode = YearMonth.of(annee, moisInt);
        
        // Récupérer les diffusions de la période pour cette société
        List<DiffusionPublicitaire> diffusions = diffusionPublicitaireRepository.findAll().stream()
            .filter(d -> {
                YearMonth diffusionMois = YearMonth.from(d.getDateDiffusion().toLocalDate());
                return diffusionMois.equals(periode) && 
                       d.getVideoPublicitaire().getSociete().getId().equals(societeId);
            })
            .toList();
        
        Double montantTotal = diffusions.stream()
            .mapToDouble(DiffusionPublicitaire::getTarifApplique)
            .sum();
        
        for (DiffusionPublicitaire diff : diffusions) {
            Map<String, Object> item = new HashMap<>();
            item.put("id", diff.getId());
            item.put("montant", diff.getTarifApplique());
            result.add(item);
        }
        
        // Ajouter le total à la fin
        Map<String, Object> totals = new HashMap<>();
        totals.put("montantTotal", montantTotal);
        result.add(totals);
        
        return result;
    }
}
