package cinema.produit;

import jakarta.persistence.*;
import cinema.shared.BaseEntity;

@Entity
@Table(name = "produits")
public class Produit extends BaseEntity {

    @Column(nullable = false)
    private String nom;

    @Column(columnDefinition = "TEXT")
    private String description;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_categorie", nullable = false)
    private CategorieProduit categorie;

    // Constructeurs
    public Produit() {
    }

    public Produit(String nom, String description, CategorieProduit categorie) {
        this.nom = nom;
        this.description = description;
        this.categorie = categorie;
    }

    // Getters et Setters
    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public CategorieProduit getCategorie() {
        return categorie;
    }

    public void setCategorie(CategorieProduit categorie) {
        this.categorie = categorie;
    }
}