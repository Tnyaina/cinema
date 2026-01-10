package cinema.reservation;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import cinema.ticket.TicketService;

@Controller
@RequestMapping("/reservations")
@RequiredArgsConstructor
@SuppressWarnings("unused")
public class ReservationController {

    private final ReservationService reservationService;
    private final TicketService ticketService;

    @GetMapping
    public String listerReservations(Model model) {
        var reservations = reservationService.obtenirToutesLesReservations();
        model.addAttribute("reservations", reservations);
        model.addAttribute("page", "reservations/liste");
        model.addAttribute("pageTitle", "Mes Réservations");
        model.addAttribute("pageActive", "reservations");
        return "layout";
    }

    @GetMapping("/{id}")
    public String afficherDetail(@PathVariable Long id, Model model) {
        var reservation = reservationService.obtenirReservationById(id);
        var tickets = ticketService.obtenirTicketsParReservation(id);
        model.addAttribute("reservation", reservation);
        model.addAttribute("tickets", tickets);
        model.addAttribute("page", "reservations/detail");
        model.addAttribute("pageTitle", "Réservation #" + id);
        model.addAttribute("pageActive", "reservations");
        return "layout";
    }

    @GetMapping("/nouveau")
    public String formulaireCreation(Model model) {
        // À implémenter
        return "reservations/formulaire";
    }

    @PostMapping
    public String creerReservation(Reservation reservation) {
        // A implementer
        return "redirect:/reservations";
    }

    @PostMapping("/{id}/annuler")
    public String annulerReservation(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            reservationService.annulerReservation(id);
            redirectAttributes.addFlashAttribute("success", "La reservation a ete annulee avec tous ses tickets");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors de l'annulation: " + e.getMessage());
        }
        return "redirect:/reservations/" + id;
    }
}
