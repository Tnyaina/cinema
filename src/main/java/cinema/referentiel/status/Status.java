package cinema.referentiel.status;

import jakarta.persistence.*;
import cinema.shared.BaseEntity;

@Entity
@Table(name = "status")
public class Status extends BaseEntity {

    @Column(unique = true, nullable = false)
    private String code;

    @Column(nullable = false)
    private String libelle;

    @Column(nullable = false)
    private Integer valeur;

    @Column
    private Boolean estFinal = false;

    // Constructeurs
    public Status() {
    }

    public Status(String code, String libelle, Integer valeur) {
        setCode(code);
        setLibelle(libelle);
        setValeur(valeur);
    }

    // Getters
    public String getCode() {
        return code;
    }

    public String getLibelle() {
        return libelle;
    }

    public Integer getValeur() {
        return valeur;
    }

    public Boolean getEstFinal() {
        return estFinal;
    }

    // Setters avec règles de gestion
    public void setCode(String code) {
        if (code == null || code.trim().isEmpty()) {
            throw new IllegalArgumentException("Le code du statut ne peut pas être vide");
        }
        this.code = code.trim().toUpperCase();
    }

    public void setLibelle(String libelle) {
        if (libelle == null || libelle.trim().isEmpty()) {
            throw new IllegalArgumentException("Le libellé du statut ne peut pas être vide");
        }
        this.libelle = libelle.trim();
    }

    public void setValeur(Integer valeur) {
        if (valeur == null || valeur < 0) {
            throw new IllegalArgumentException("La valeur du statut doit être positive");
        }
        this.valeur = valeur;
    }

    public void setEstFinal(Boolean estFinal) {
        this.estFinal = estFinal != null ? estFinal : false;
    }

    // Méthodes métier
    public boolean estValide() {
        return code != null && !code.isEmpty()
            && libelle != null && !libelle.isEmpty()
            && valeur != null && valeur >= 0;
    }
}
