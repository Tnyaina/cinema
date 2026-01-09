package cinema.reservation;

import jakarta.persistence.*;
import cinema.shared.BaseEntity;
import cinema.client.Client;
import cinema.seance.Seance;
import cinema.referentiel.status.Status;

@Entity
@Table(name = "reservation")
public class Reservation extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_personne")
    private Client personne;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_seance")
    private Seance seance;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_status")
    private Status status;

    @Column(columnDefinition = "DECIMAL(6,2)")
    private Double montantTotal = 0.0;

    // Constructeurs
    public Reservation() {
    }

    public Reservation(Client personne, Seance seance, Status status) {
        setPersonne(personne);
        setSeance(seance);
        setStatus(status);
    }

    // Getters
    public Client getPersonne() {
        return personne;
    }

    public Seance getSeance() {
        return seance;
    }

    public Status getStatus() {
        return status;
    }

    public Double getMontantTotal() {
        return montantTotal;
    }

    // Setters avec règles de gestion
    public void setPersonne(Client personne) {
        if (personne == null) {
            throw new IllegalArgumentException("La personne (client) ne peut pas être null");
        }
        this.personne = personne;
    }

    public void setSeance(Seance seance) {
        if (seance == null) {
            throw new IllegalArgumentException("La séance ne peut pas être null");
        }
        this.seance = seance;
    }

    public void setStatus(Status status) {
        if (status == null) {
            throw new IllegalArgumentException("Le statut ne peut pas être null");
        }
        this.status = status;
    }

    public void setMontantTotal(Double montantTotal) {
        if (montantTotal != null && montantTotal < 0) {
            throw new IllegalArgumentException("Le montant total ne peut pas être négatif");
        }
        this.montantTotal = montantTotal != null ? montantTotal : 0.0;
    }

    // Méthodes métier
    public boolean estValide() {
        return personne != null && seance != null && status != null
            && montantTotal != null && montantTotal >= 0;
    }
}
