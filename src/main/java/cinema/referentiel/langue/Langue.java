package cinema.referentiel.langue;

import jakarta.persistence.*;
import cinema.shared.BaseEntity;

@Entity
@Table(name = "langue")
public class Langue extends BaseEntity {

    @Column(unique = true, nullable = false)
    private String code;

    @Column(nullable = false)
    private String libelle;

    // Constructeurs
    public Langue() {
    }

    public Langue(String code, String libelle) {
        setCode(code);
        setLibelle(libelle);
    }

    // Getters
    public String getCode() {
        return code;
    }

    public String getLibelle() {
        return libelle;
    }

    // Setters avec règles de gestion
    public void setCode(String code) {
        if (code == null || code.trim().isEmpty()) {
            throw new IllegalArgumentException("Le code de la langue ne peut pas être vide");
        }
        this.code = code.trim().toUpperCase();
    }

    public void setLibelle(String libelle) {
        if (libelle == null || libelle.trim().isEmpty()) {
            throw new IllegalArgumentException("Le libellé de la langue ne peut pas être vide");
        }
        this.libelle = libelle.trim();
    }

    // Méthodes métier
    public boolean estValide() {
        return code != null && !code.isEmpty()
            && libelle != null && !libelle.isEmpty();
    }
}
