package cinema.referentiel.genre;

import jakarta.persistence.*;
import cinema.shared.BaseEntity;

@Entity
@Table(name = "genre")
public class Genre extends BaseEntity {

    @Column(unique = true, nullable = false)
    private String libelle;

    // Constructeurs
    public Genre() {
    }

    public Genre(String libelle) {
        setLibelle(libelle);
    }

    // Getters
    public String getLibelle() {
        return libelle;
    }

    // Setters avec règles de gestion
    public void setLibelle(String libelle) {
        if (libelle == null || libelle.trim().isEmpty()) {
            throw new IllegalArgumentException("Le libellé du genre ne peut pas être vide");
        }
        this.libelle = libelle.trim();
    }

    // Méthodes métier
    public boolean estValide() {
        return libelle != null && !libelle.isEmpty();
    }
}
