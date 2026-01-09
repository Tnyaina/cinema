package cinema.ticket;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class TicketService {

    private final TicketRepository ticketRepository;

    public Ticket creerTicket(Ticket ticket) {
        if (!ticket.estValide()) {
            throw new IllegalArgumentException("Le ticket n'est pas valide");
        }
        return ticketRepository.save(ticket);
    }

    public Ticket modifierTicket(Long id, Ticket ticketMaj) {
        Ticket ticket = obtenirTicketById(id);
        if (!ticketMaj.estValide()) {
            throw new IllegalArgumentException("Le ticket n'est pas valide");
        }
        ticket.setReservation(ticketMaj.getReservation());
        ticket.setSeance(ticketMaj.getSeance());
        ticket.setPlace(ticketMaj.getPlace());
        ticket.setStatus(ticketMaj.getStatus());
        ticket.setCategoriePersonne(ticketMaj.getCategoriePersonne());
        ticket.setPrix(ticketMaj.getPrix());
        return ticketRepository.save(ticket);
    }

    public void supprimerTicket(Long id) {
        ticketRepository.deleteById(id);
    }

    @Transactional(readOnly = true)
    public Ticket obtenirTicketById(Long id) {
        return ticketRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Ticket non trouvé avec l'ID: " + id));
    }

    @Transactional(readOnly = true)
    public List<Ticket> obtenirTicketsParReservation(Long reservationId) {
        return ticketRepository.findByReservationId(reservationId);
    }

    @Transactional(readOnly = true)
    public List<Ticket> obtenirTicketsParSeance(Long seanceId) {
        return ticketRepository.findBySeanceId(seanceId);
    }

    @Transactional(readOnly = true)
    public List<Ticket> obtenirTicketsParStatus(Long statusId) {
        return ticketRepository.findByStatusId(statusId);
    }

    @Transactional(readOnly = true)
    public List<Ticket> obtenirTousLesTickets() {
        return ticketRepository.findAll();
    }

    /**
     * Calculer le chiffre d'affaires pour une séance donnée
     * @param seanceId L'ID de la séance
     * @return Le chiffre d'affaires total (somme des prix des tickets vendus/confirmés)
     */
    @Transactional(readOnly = true)
    public Double calculerChiffresAffairesSeance(Long seanceId) {
        List<Ticket> tickets = ticketRepository.findBySeanceId(seanceId);
        return tickets.stream()
            .mapToDouble(Ticket::getPrix)
            .sum();
    }
}
