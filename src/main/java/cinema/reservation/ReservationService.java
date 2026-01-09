package cinema.reservation;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class ReservationService {

    private final ReservationRepository reservationRepository;

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

