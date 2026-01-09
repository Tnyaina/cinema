package cinema.reservation;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/reservations")
@RequiredArgsConstructor
@SuppressWarnings("unused")
public class ReservationController {

    private final ReservationService reservationService;

    @GetMapping
    public String listerReservations(Model model) {
        // À implémenter
        return "reservations/liste";
    }

    @GetMapping("/{id}")
    public String afficherDetail(@PathVariable Long id, Model model) {
        // À implémenter
        return "reservations/detail";
    }

    @GetMapping("/nouveau")
    public String formulaireCreation(Model model) {
        // À implémenter
        return "reservations/formulaire";
    }

    @PostMapping
    public String creerReservation(Reservation reservation) {
        // À implémenter
        return "redirect:/reservations";
    }
}
