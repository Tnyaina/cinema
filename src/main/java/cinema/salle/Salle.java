package cinema.salle;

import jakarta.persistence.*;
import cinema.shared.BaseEntity;

@Entity
@Table(name = "salle")
public class Salle extends BaseEntity {

    @Column(nullable = false)
    private String nom;

    @Column(nullable = false)
    private Integer capacite;

    // Constructeurs
    public Salle() {
    }

    public Salle(String nom, Integer capacite) {
        setNom(nom);
        setCapacite(capacite);
    }

    // Getters
    public String getNom() {
        return nom;
    }

    public Integer getCapacite() {
        return capacite;
    }

    // Setters avec règles de gestion
    public void setNom(String nom) {
        if (nom == null || nom.trim().isEmpty()) {
            throw new IllegalArgumentException("Le nom de la salle ne peut pas être vide");
        }
        this.nom = nom.trim();
    }

    public void setCapacite(Integer capacite) {
        if (capacite == null || capacite <= 0) {
            throw new IllegalArgumentException("La capacité doit être supérieure à 0");
        }
        this.capacite = capacite;
    }

    // Méthodes métier
    public boolean estValide() {
        return nom != null && !nom.isEmpty()
            && capacite != null && capacite > 0;
    }

    public Integer getCapaciteRestante(Integer nombrePlacesUtilisees) {
        if (nombrePlacesUtilisees == null) {
            nombrePlacesUtilisees = 0;
        }
        return Math.max(0, capacite - nombrePlacesUtilisees);
    }
}
