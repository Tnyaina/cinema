package cinema.publicite.video;

import jakarta.persistence.*;
import cinema.shared.BaseEntity;
import cinema.publicite.societe.Societe;

@Entity
@Table(name = "video_publicitaire")
public class VideoPublicitaire extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "societe_id", nullable = false)
    private Societe societe;

    @Column(nullable = false)
    private String libelle;

    @Column(nullable = false)
    private Integer duree; // Durée en secondes

    // Constructeurs
    public VideoPublicitaire() {
    }

    public VideoPublicitaire(Societe societe, String libelle, Integer duree) {
        this.societe = societe;
        this.libelle = libelle;
        this.duree = duree;
    }

    // Getters et Setters
    public Societe getSociete() {
        return societe;
    }

    public void setSociete(Societe societe) {
        this.societe = societe;
    }

    public String getLibelle() {
        return libelle;
    }

    public void setLibelle(String libelle) {
        this.libelle = libelle;
    }

    public Integer getDuree() {
        return duree;
    }

    public void setDuree(Integer duree) {
        this.duree = duree;
    }

    @Override
    public String toString() {
        return "VideoPublicitaire{" +
                "id=" + getId() +
                ", libelle='" + libelle + '\'' +
                ", duree=" + duree +
                '}';
    }
}
