package cinema.produit;

import jakarta.persistence.*;
import cinema.shared.BaseEntity;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "vente_produits")
public class VenteProduit extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_produit", nullable = false)
    private Produit produit;

    @Column(nullable = false)
    private Integer quantite;

    @Column(name = "prix_unitaire", nullable = false, precision = 10, scale = 2)
    private BigDecimal prixUnitaire;

    @Column(nullable = false, precision = 10, scale = 2)
    private BigDecimal total;

    @Column(name = "date_vente", nullable = false)
    private LocalDateTime dateVente;

    // Constructeurs
    public VenteProduit() {
    }

    public VenteProduit(Produit produit, Integer quantite, BigDecimal prixUnitaire, BigDecimal total, LocalDateTime dateVente) {
        this.produit = produit;
        this.quantite = quantite;
        this.prixUnitaire = prixUnitaire;
        this.total = total;
        this.dateVente = dateVente;
    }

    // Getters et Setters
    public Produit getProduit() {
        return produit;
    }

    public void setProduit(Produit produit) {
        this.produit = produit;
    }

    public Integer getQuantite() {
        return quantite;
    }

    public void setQuantite(Integer quantite) {
        this.quantite = quantite;
    }

    public BigDecimal getPrixUnitaire() {
        return prixUnitaire;
    }

    public void setPrixUnitaire(BigDecimal prixUnitaire) {
        this.prixUnitaire = prixUnitaire;
    }

    public BigDecimal getTotal() {
        return total;
    }

    public void setTotal(BigDecimal total) {
        this.total = total;
    }

    public LocalDateTime getDateVente() {
        return dateVente;
    }

    public void setDateVente(LocalDateTime dateVente) {
        this.dateVente = dateVente;
    }
}