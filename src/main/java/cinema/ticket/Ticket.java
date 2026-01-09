package cinema.ticket;

import jakarta.persistence.*;
import cinema.shared.BaseEntity;
import cinema.reservation.Reservation;
import cinema.seance.Seance;
import cinema.place.Place;
import cinema.referentiel.status.Status;
import cinema.referentiel.categoriepersonne.CategoriePersonne;

@Entity
@Table(name = "ticket", uniqueConstraints = {
    @UniqueConstraint(columnNames = {"id_seance", "id_place"})
})
public class Ticket extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_reservation")
    private Reservation reservation;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_seance")
    private Seance seance;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_place")
    private Place place;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_status")
    private Status status;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_categorie_personne")
    private CategoriePersonne categoriePersonne;

    @Column(nullable = false)
    private Double prix;

    // Constructeurs
    public Ticket() {
    }

    public Ticket(Seance seance, Place place, Double prix) {
        setSeance(seance);
        setPlace(place);
        setPrix(prix);
    }

    // Getters
    public Reservation getReservation() {
        return reservation;
    }

    public Seance getSeance() {
        return seance;
    }

    public Place getPlace() {
        return place;
    }

    public Status getStatus() {
        return status;
    }

    public CategoriePersonne getCategoriePersonne() {
        return categoriePersonne;
    }

    public Double getPrix() {
        return prix;
    }

    // Setters avec règles de gestion
    public void setReservation(Reservation reservation) {
        this.reservation = reservation;
    }

    public void setSeance(Seance seance) {
        if (seance == null) {
            throw new IllegalArgumentException("La séance ne peut pas être null");
        }
        this.seance = seance;
    }

    public void setPlace(Place place) {
        if (place == null) {
            throw new IllegalArgumentException("La place ne peut pas être null");
        }
        this.place = place;
    }

    public void setStatus(Status status) {
        this.status = status;
    }

    public void setCategoriePersonne(CategoriePersonne categoriePersonne) {
        this.categoriePersonne = categoriePersonne;
    }

    public void setPrix(Double prix) {
        if (prix == null || prix <= 0) {
            throw new IllegalArgumentException("Le prix doit être supérieur à 0");
        }
        this.prix = prix;
    }

    // Méthodes métier
    public boolean estValide() {
        return seance != null && place != null && prix != null && prix > 0;
    }
}
