package cinema.referentiel.categoriepersonne;

import jakarta.persistence.*;
import cinema.shared.BaseEntity;

@Entity
@Table(name = "categorie_personne")
public class CategoriePersonne extends BaseEntity {

    @Column(nullable = false)
    private String libelle;

    // Constructeurs
    public CategoriePersonne() {
    }

    public CategoriePersonne(String libelle) {
        setLibelle(libelle);
    }

    // Getters
    public String getLibelle() {
        return libelle;
    }

    // Setters avec règles de gestion
    public void setLibelle(String libelle) {
        if (libelle == null || libelle.trim().isEmpty()) {
            throw new IllegalArgumentException("Le libellé de la catégorie de personne ne peut pas être vide");
        }
        this.libelle = libelle.trim();
    }

    // Méthodes métier
    public boolean estValide() {
        return libelle != null && !libelle.isEmpty();
    }
}
