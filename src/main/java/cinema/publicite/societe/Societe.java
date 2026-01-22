package cinema.publicite.societe;

import jakarta.persistence.*;
import cinema.shared.BaseEntity;

@Entity
@Table(name = "societe")
public class Societe extends BaseEntity {

    @Column(nullable = false, unique = true)
    private String libelle;

    // Constructeurs
    public Societe() {
    }

    public Societe(String libelle) {
        this.libelle = libelle;
    }

    // Getters et Setters
    public String getLibelle() {
        return libelle;
    }

    public void setLibelle(String libelle) {
        this.libelle = libelle;
    }

    @Override
    public String toString() {
        return "Societe{" +
                "id=" + getId() +
                ", libelle='" + libelle + '\'' +
                '}';
    }
}
