package cinema.ticket;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import cinema.seance.SeanceService;
import cinema.reservation.ReservationCreationService;
import cinema.reservation.ReservationCreationService.PlaceSelection;
import cinema.reservation.ReservationCreationService.ReservationCreationResult;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("/tickets")
@RequiredArgsConstructor
@SuppressWarnings("unused")
public class TicketController {

    private final TicketService ticketService;
    private final SeanceService seanceService;
    private final ReservationCreationService reservationCreationService;

    @GetMapping
    public String listerTickets(Model model) {
        var tickets = ticketService.obtenirTousLesTickets();
        model.addAttribute("tickets", tickets);
        model.addAttribute("page", "tickets/liste");
        model.addAttribute("pageTitle", "Gestion des Tickets Vendus");
        model.addAttribute("pageActive", "tickets");
        return "layout";
    }

    @GetMapping("/reservation/{reservationId}")
    public String listerTicketsByReservation(@PathVariable Long reservationId, Model model) {
        // À implémenter
        return "tickets/liste";
    }

    @GetMapping("/{id}")
    public String afficherDetail(@PathVariable Long id, Model model) {
        // À implémenter
        return "tickets/detail";
    }

    @GetMapping("/nouveau")
    public String formulaireCreation(Model model) {
        // À implémenter
        return "tickets/formulaire";
    }

    @PostMapping
    public String creerTicket(Ticket ticket) {
        // À implémenter
        return "redirect:/tickets";
    }

    @PostMapping("/acheter")
    public String acheterTickets(
            @RequestParam Long seanceId,
            @RequestParam(required = false) List<Long> placeIds,
            @RequestParam(required = false) List<Long> categorieIds,
            @RequestParam(required = false) String nomComplet,
            @RequestParam(required = false) String email,
            @RequestParam(required = false) String telephone,
            RedirectAttributes redirectAttributes) {
        
        try {
            // Valider les entrées
            if (nomComplet == null || nomComplet.trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Le nom est requis");
                return "redirect:/seances/" + seanceId;
            }
            
            if (placeIds == null || placeIds.isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Veuillez sélectionner au moins une place");
                return "redirect:/seances/" + seanceId;
            }
            
            if (categorieIds == null || categorieIds.size() != placeIds.size()) {
                redirectAttributes.addFlashAttribute("error", "Données invalides: nombre de places et catégories incohérent");
                return "redirect:/seances/" + seanceId;
            }
            
            // Obtenir la séance
            var seance = seanceService.obtenirSeanceById(seanceId);
            
            // Construire la liste des sélections de places
            List<PlaceSelection> placesSelection = new ArrayList<>();
            for (int i = 0; i < placeIds.size(); i++) {
                placesSelection.add(new PlaceSelection(placeIds.get(i), categorieIds.get(i)));
            }
            
            // Créer la réservation avec les tickets en une transaction atomique
            ReservationCreationResult result = reservationCreationService.creerReservationAvecTickets(
                seance,
                nomComplet.trim(),
                email,
                telephone,
                placesSelection
            );
            
            redirectAttributes.addFlashAttribute("success",
                result.getNombreTickets() + " ticket(s) réservé(s) avec succès! " +
                "Réservation #" + result.getReservation().getId() + " - " +
                "Total: " + String.format("%.2f", result.getMontantTotal()) + " Ar");
            
            return "redirect:/seances/" + seanceId;
            
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/seances/" + seanceId;
        } catch (IllegalStateException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/seances/" + seanceId;
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", 
                "Erreur lors de la création de la réservation: " + e.getMessage());
            return "redirect:/seances/" + seanceId;
        }
    }

    @GetMapping("/{id}/modifier")
    public String formulaireModification(@PathVariable Long id, Model model) {
        // À implémenter
        return "tickets/formulaire";
    }

    @PostMapping("/{id}")
    public String modifierTicket(@PathVariable Long id, Ticket ticket) {
        // À implémenter
        return "redirect:/tickets/" + id;
    }

    @PostMapping("/{id}/supprimer")
    public String supprimerTicket(@PathVariable Long id) {
        // A implementer
        return "redirect:/tickets";
    }

    @PostMapping("/{id}/annuler")
    public String annulerTicket(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            var ticket = ticketService.obtenirTicketById(id);
            var reservationId = ticket.getReservation().getId();
            ticketService.annulerTicket(id);
            redirectAttributes.addFlashAttribute("success", "Le ticket a ete annule");
            return "redirect:/reservations/" + reservationId;
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors de l'annulation du ticket: " + e.getMessage());
            return "redirect:/tickets";
        }
    }
}
