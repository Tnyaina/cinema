package cinema.ticket;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/tickets")
@RequiredArgsConstructor
@SuppressWarnings("unused")
public class TicketController {

    private final TicketService ticketService;

    @GetMapping
    public String listerTickets(Model model) {
        // À implémenter
        return "tickets/liste";
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
        // À implémenter
        return "redirect:/tickets";
    }
}
