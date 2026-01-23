package cinema.publicite.paiement;

import jakarta.persistence.*;
import cinema.shared.BaseEntity;
import cinema.publicite.societe.Societe;
import org.springframework.format.annotation.DateTimeFormat;
import java.time.LocalDate;

@Entity
@Table(name = "paiement_publicite")
public class PaiementPublicite extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "societe_id", nullable = false)
    private Societe societe;

    @Column(nullable = false, columnDefinition = "NUMERIC(15,2)")
    private Double montant;

    @Column(nullable = false)
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private LocalDate datePaiement;

    @Column(columnDefinition = "NUMERIC(15,2) DEFAULT 0")
    private Double montantPaye = 0.0;

    // Constructeurs
    public PaiementPublicite() {
    }

    public PaiementPublicite(Societe societe, Double montant, LocalDate datePaiement) {
        this.societe = societe;
        this.montant = montant;
        this.datePaiement = datePaiement;
    }

    // Getters et Setters
    public Societe getSociete() {
        return societe;
    }

    public void setSociete(Societe societe) {
        this.societe = societe;
    }

    public Double getMontant() {
        return montant;
    }

    public void setMontant(Double montant) {
        this.montant = montant;
    }

    public LocalDate getDatePaiement() {
        return datePaiement;
    }

    public void setDatePaiement(LocalDate datePaiement) {
        this.datePaiement = datePaiement;
    }

    public Double getMontantPaye() {
        return montantPaye;
    }

    public void setMontantPaye(Double montantPaye) {
        this.montantPaye = montantPaye;
    }

    @Override
    public String toString() {
        return "PaiementPublicite{" +
                "id=" + getId() +
                ", societe=" + societe.getLibelle() +
                ", montant=" + montant +
                ", montantPaye=" + montantPaye +
                ", datePaiement=" + datePaiement +
                '}';
    }
}
