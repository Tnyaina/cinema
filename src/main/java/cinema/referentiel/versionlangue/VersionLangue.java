package cinema.referentiel.versionlangue;

import jakarta.persistence.*;
import cinema.shared.BaseEntity;
import cinema.referentiel.langue.Langue;

@Entity
@Table(name = "version_langue")
public class VersionLangue extends BaseEntity {

    @Column(unique = true, nullable = false)
    private String code;

    @Column(nullable = false)
    private String libelle;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_langue_audio")
    private Langue langueAudio;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_langue_sous_titre")
    private Langue langueSousTitre;

    // Constructeurs
    public VersionLangue() {
    }

    public VersionLangue(String code, String libelle) {
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

    public Langue getLangueAudio() {
        return langueAudio;
    }

    public Langue getLangueSousTitre() {
        return langueSousTitre;
    }

    // Setters avec règles de gestion
    public void setCode(String code) {
        if (code == null || code.trim().isEmpty()) {
            throw new IllegalArgumentException("Le code de la version de langue ne peut pas être vide");
        }
        this.code = code.trim().toUpperCase();
    }

    public void setLibelle(String libelle) {
        if (libelle == null || libelle.trim().isEmpty()) {
            throw new IllegalArgumentException("Le libellé de la version de langue ne peut pas être vide");
        }
        this.libelle = libelle.trim();
    }

    public void setLangueAudio(Langue langueAudio) {
        this.langueAudio = langueAudio;
    }

    public void setLangueSousTitre(Langue langueSousTitre) {
        this.langueSousTitre = langueSousTitre;
    }

    // Méthodes métier
    public boolean estValide() {
        return code != null && !code.isEmpty()
            && libelle != null && !libelle.isEmpty();
    }
}
