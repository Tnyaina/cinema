package cinema.publicite.type;

import jakarta.persistence.*;
import cinema.shared.BaseEntity;

@Entity
@Table(name = "type_diffusion_pub")
public class TypeDiffusionPub extends BaseEntity {

    @Column(nullable = false, unique = true)
    private String libelle;

    @Column(columnDefinition = "TEXT")
    private String description;

    // Constructeurs
    public TypeDiffusionPub() {
    }

    public TypeDiffusionPub(String libelle) {
        this.libelle = libelle;
    }

    public TypeDiffusionPub(String libelle, String description) {
        this.libelle = libelle;
        this.description = description;
    }

    // Getters et Setters
    public String getLibelle() {
        return libelle;
    }

    public void setLibelle(String libelle) {
        this.libelle = libelle;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    @Override
    public String toString() {
        return "TypeDiffusionPub{" +
                "id=" + getId() +
                ", libelle='" + libelle + '\'' +
                '}';
    }
}
