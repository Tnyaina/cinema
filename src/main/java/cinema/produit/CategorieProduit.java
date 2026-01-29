package cinema.produit;

import jakarta.persistence.*;
import cinema.shared.BaseEntity;

@Entity
@Table(name = "categorie_produits")
public class CategorieProduit extends BaseEntity {

    @Column(nullable = false, unique = true)
    private String nom;

    // Constructeurs
    public CategorieProduit() {
    }

    public CategorieProduit(String nom) {
        this.nom = nom;
    }

    // Getters et Setters
    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }
}