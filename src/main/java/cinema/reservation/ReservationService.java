package cinema.reservation;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import cinema.ticket.TicketService;
import cinema.shared.StatusRepository;
import cinema.historique.HistoriqueStatutReservation;
import cinema.historique.HistoriqueStatutReservationRepository;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class ReservationService {

    private final ReservationRepository reservationRepository;
    private final TicketService ticketService;
    private final StatusRepository statusRepository;
    private final HistoriqueStatutReservationRepository historiqueReservationRepository;

    public Reservation creerReservation(Reservation reservation) {
        if (!reservation.estValide()) {
            throw new IllegalArgumentException("La réservation n'est pas valide");
        }
        return reservationRepository.save(reservation);
    }

    public Reservation modifierReservation(Long id, Reservation reservationMaj) {
        Reservation reservation = obtenirReservationById(id);
        if (!reservationMaj.estValide()) {
            throw new IllegalArgumentException("La réservation n'est pas valide");
        }
        reservation.setMontantTotal(reservationMaj.getMontantTotal());
        return reservationRepository.save(reservation);
    }

    public void supprimerReservation(Long id) {
        reservationRepository.deleteById(id);
    }

    /**
     * Annuler une reservation : marquer comme ANNULEE et annuler tous ses tickets
     */
    public Reservation annulerReservation(Long id) {
        Reservation reservation = obtenirReservationById(id);
        
        // Marquer la reservation comme ANNULEE
        var statusAnnulee = statusRepository.findByCode("ANNULEE")
            .orElseThrow(() -> new RuntimeException("Status ANNULEE non trouve"));
        reservation.setStatus(statusAnnulee);
        reservation.setMontantTotal(0.0);
        
        Reservation reservationAnnulee = reservationRepository.save(reservation);
        
        // Enregistrer dans l'historique
        enregistrerHistoriqueReservation(reservationAnnulee, "ANNULEE");
        
        // Annuler tous les tickets de la reservation
        var tickets = ticketService.obtenirTicketsParReservation(id);
        for (var ticket : tickets) {
            ticketService.annulerTicket(ticket.getId());
        }
        
        return reservationAnnulee;
    }

    /**
     * Enregistrer dans l'historique statut de la reservation
     */
    private void enregistrerHistoriqueReservation(Reservation reservation, String codeStatus) {
        var status = statusRepository.findByCode(codeStatus)
            .orElseThrow(() -> new RuntimeException("Status " + codeStatus + " non trouve"));

        HistoriqueStatutReservation historique = new HistoriqueStatutReservation();
        historique.setReservation(reservation);
        historique.setStatus(status);
        historique.setCommentaire("Reservation annulee");

        historiqueReservationRepository.save(historique);
    }

    @Transactional(readOnly = true)
    public Reservation obtenirReservationById(Long id) {
        return reservationRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Réservation non trouvée avec l'ID: " + id));
    }

    @Transactional(readOnly = true)
    public List<Reservation> obtenirReservationsParPersonne(Long personneId) {
        return reservationRepository.findByPersonneId(personneId);
    }

    @Transactional(readOnly = true)
    public List<Reservation> obtenirReservationsParSeance(Long seanceId) {
        return reservationRepository.findBySeanceId(seanceId);
    }

    @Transactional(readOnly = true)
    public List<Reservation> obtenirToutesLesReservations() {
        return reservationRepository.findAll();
    }
}

