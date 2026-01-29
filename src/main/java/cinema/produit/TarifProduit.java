package cinema.produit;

import jakarta.persistence.*;
import cinema.shared.BaseEntity;
import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "tarif_produits")
public class TarifProduit extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_produit", nullable = false)
    private Produit produit;

    @Column(nullable = false, precision = 10, scale = 2)
    private BigDecimal prix;

    @Column(name = "date_debut", nullable = false)
    private LocalDate dateDebut;

    @Column(name = "date_fin")
    private LocalDate dateFin;

    // Constructeurs
    public TarifProduit() {
    }

    public TarifProduit(Produit produit, BigDecimal prix, LocalDate dateDebut, LocalDate dateFin) {
        this.produit = produit;
        this.prix = prix;
        this.dateDebut = dateDebut;
        this.dateFin = dateFin;
    }

    // Getters et Setters
    public Produit getProduit() {
        return produit;
    }

    public void setProduit(Produit produit) {
        this.produit = produit;
    }

    public BigDecimal getPrix() {
        return prix;
    }

    public void setPrix(BigDecimal prix) {
        this.prix = prix;
    }

    public LocalDate getDateDebut() {
        return dateDebut;
    }

    public void setDateDebut(LocalDate dateDebut) {
        this.dateDebut = dateDebut;
    }

    public LocalDate getDateFin() {
        return dateFin;
    }

    public void setDateFin(LocalDate dateFin) {
        this.dateFin = dateFin;
    }
}