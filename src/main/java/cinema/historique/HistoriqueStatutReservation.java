package cinema.historique;

import jakarta.persistence.*;
import cinema.shared.BaseEntity;
import cinema.reservation.Reservation;
import cinema.referentiel.status.Status;
import cinema.client.Client;
import java.time.LocalDateTime;

@Entity
@Table(name = "historique_statut_reservation")
public class HistoriqueStatutReservation extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_reservation")
    private Reservation reservation;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_status")
    private Status status;

    @Column
    private LocalDateTime dateChangement;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "change_par")
    private Client changerPar;

    @Column
    private String commentaire;

    // Constructeurs
    public HistoriqueStatutReservation() {
    }

    public HistoriqueStatutReservation(Reservation reservation, Status status) {
        setReservation(reservation);
        setStatus(status);
        setDateChangement(LocalDateTime.now());
    }

    // Getters
    public Reservation getReservation() {
        return reservation;
    }

    public Status getStatus() {
        return status;
    }

    public LocalDateTime getDateChangement() {
        return dateChangement;
    }

    public Client getChangerPar() {
        return changerPar;
    }

    public String getCommentaire() {
        return commentaire;
    }

    // Setters avec règles de gestion
    public void setReservation(Reservation reservation) {
        if (reservation == null) {
            throw new IllegalArgumentException("La réservation ne peut pas être null");
        }
        this.reservation = reservation;
    }

    public void setStatus(Status status) {
        if (status == null) {
            throw new IllegalArgumentException("Le statut ne peut pas être null");
        }
        this.status = status;
    }

    public void setDateChangement(LocalDateTime dateChangement) {
        this.dateChangement = dateChangement != null ? dateChangement : LocalDateTime.now();
    }

    public void setChangerPar(Client changerPar) {
        this.changerPar = changerPar;
    }

    public void setCommentaire(String commentaire) {
        this.commentaire = commentaire;
    }

    // Méthodes métier
    public boolean estValide() {
        return reservation != null && status != null && dateChangement != null;
    }
}
