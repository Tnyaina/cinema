package cinema.historique;

import jakarta.persistence.*;
import cinema.shared.BaseEntity;
import cinema.ticket.Ticket;
import cinema.referentiel.status.Status;
import cinema.client.Client;
import java.time.LocalDateTime;

@Entity
@Table(name = "historique_statut_ticket")
public class HistoriqueStatutTicket extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_ticket")
    private Ticket ticket;

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
    public HistoriqueStatutTicket() {
    }

    public HistoriqueStatutTicket(Ticket ticket, Status status) {
        setTicket(ticket);
        setStatus(status);
        setDateChangement(LocalDateTime.now());
    }

    // Getters
    public Ticket getTicket() {
        return ticket;
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
    public void setTicket(Ticket ticket) {
        if (ticket == null) {
            throw new IllegalArgumentException("Le ticket ne peut pas être null");
        }
        this.ticket = ticket;
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
        return ticket != null && status != null && dateChangement != null;
    }
}
