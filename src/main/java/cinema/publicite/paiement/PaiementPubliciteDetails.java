package cinema.publicite.paiement;

import jakarta.persistence.*;
import cinema.shared.BaseEntity;
import cinema.publicite.diffusion.DiffusionPublicitaire;
import java.math.BigDecimal;

@Entity
@Table(name = "paiement_publicite_details")
public class PaiementPubliciteDetails extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "paiement_publicite_id", nullable = false)
    private PaiementPublicite paiementPublicite;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "diffusion_publicitaire_id", nullable = false)
    private DiffusionPublicitaire diffusionPublicitaire;

    @Column(nullable = false, columnDefinition = "NUMERIC(15,2)")
    private Double montant;

    // Constructeurs
    public PaiementPubliciteDetails() {
    }

    public PaiementPubliciteDetails(PaiementPublicite paiementPublicite, DiffusionPublicitaire diffusionPublicitaire, Double montant) {
        this.paiementPublicite = paiementPublicite;
        this.diffusionPublicitaire = diffusionPublicitaire;
        this.montant = montant;
    }

    // Getters et Setters
    public PaiementPublicite getPaiementPublicite() {
        return paiementPublicite;
    }

    public void setPaiementPublicite(PaiementPublicite paiementPublicite) {
        this.paiementPublicite = paiementPublicite;
    }

    public DiffusionPublicitaire getDiffusionPublicitaire() {
        return diffusionPublicitaire;
    }

    public void setDiffusionPublicitaire(DiffusionPublicitaire diffusionPublicitaire) {
        this.diffusionPublicitaire = diffusionPublicitaire;
    }

    public Double getMontant() {
        return montant;
    }

    public void setMontant(Double montant) {
        this.montant = montant;
    }

    @Override
    public String toString() {
        return "PaiementPubliciteDetails{" +
                "id=" + getId() +
                ", paiementPubliciteId=" + (paiementPublicite != null ? paiementPublicite.getId() : null) +
                ", diffusionPublicitaireId=" + (diffusionPublicitaire != null ? diffusionPublicitaire.getId() : null) +
                ", montant=" + montant +
                '}';
    }
}
