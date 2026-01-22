package cinema.publicite.tarif;

import jakarta.persistence.*;
import cinema.shared.BaseEntity;
import cinema.publicite.societe.Societe;
import cinema.publicite.type.TypeDiffusionPub;
import org.springframework.format.annotation.DateTimeFormat;
import java.time.LocalDate;

@Entity
@Table(name = "tarif_publicite_personnalise", uniqueConstraints = @UniqueConstraint(columnNames = {"societe_id", "type_diffusion_id", "date_debut"}))
public class TarifPublicitePersonnalise extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "societe_id", nullable = false)
    private Societe societe;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "type_diffusion_id", nullable = false)
    private TypeDiffusionPub typeDiffusion;

    @Column(nullable = false, columnDefinition = "NUMERIC(15,2)")
    private Double prixUnitaire;

    @Column(nullable = false)
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private LocalDate dateDebut;

    // Constructeurs
    public TarifPublicitePersonnalise() {
    }

    public TarifPublicitePersonnalise(Societe societe, TypeDiffusionPub typeDiffusion, Double prixUnitaire, LocalDate dateDebut) {
        this.societe = societe;
        this.typeDiffusion = typeDiffusion;
        this.prixUnitaire = prixUnitaire;
        this.dateDebut = dateDebut;
    }

    // Getters et Setters
    public Societe getSociete() {
        return societe;
    }

    public void setSociete(Societe societe) {
        this.societe = societe;
    }

    public TypeDiffusionPub getTypeDiffusion() {
        return typeDiffusion;
    }

    public void setTypeDiffusion(TypeDiffusionPub typeDiffusion) {
        this.typeDiffusion = typeDiffusion;
    }

    public Double getPrixUnitaire() {
        return prixUnitaire;
    }

    public void setPrixUnitaire(Double prixUnitaire) {
        this.prixUnitaire = prixUnitaire;
    }

    public LocalDate getDateDebut() {
        return dateDebut;
    }

    public void setDateDebut(LocalDate dateDebut) {
        this.dateDebut = dateDebut;
    }

    @Override
    public String toString() {
        return "TarifPublicitePersonnalise{" +
                "id=" + getId() +
                ", societe=" + societe.getLibelle() +
                ", typeDiffusion=" + typeDiffusion.getLibelle() +
                ", prixUnitaire=" + prixUnitaire +
                ", dateDebut=" + dateDebut +
                '}';
    }
}
