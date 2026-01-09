package cinema.referentiel.typeplace;

import jakarta.persistence.*;
import cinema.shared.BaseEntity;

@Entity
@Table(name = "type_place")
public class TypePlace extends BaseEntity {

    @Column(nullable = false)
    private String libelle;

    // Constructeurs
    public TypePlace() {
    }

    public TypePlace(String libelle) {
        setLibelle(libelle);
    }

    // Getters
    public String getLibelle() {
        return libelle;
    }

    // Setters avec règles de gestion
    public void setLibelle(String libelle) {
        if (libelle == null || libelle.trim().isEmpty()) {
            throw new IllegalArgumentException("Le libellé du type de place ne peut pas être vide");
        }
        this.libelle = libelle.trim();
    }

    // Méthodes métier
    public boolean estValide() {
        return libelle != null && !libelle.isEmpty();
    }
}
