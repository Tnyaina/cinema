package cinema.seance;

import jakarta.persistence.*;
import cinema.shared.BaseEntity;
import cinema.film.Film;
import cinema.salle.Salle;
import cinema.referentiel.versionlangue.VersionLangue;
import org.springframework.format.annotation.DateTimeFormat;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.Locale;

@Entity
@Table(name = "seance")
public class Seance extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_film")
    private Film film;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_salle")
    private Salle salle;

    @Column(nullable = false)
    @DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm")
    private LocalDateTime debut;

    @Column
    @DateTimeFormat(pattern = "HH:mm")
    private LocalTime fin;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_version_langue")
    private VersionLangue versionLangue;

    @Column
    private String statut = "Disponible";

    // Constructeurs
    public Seance() {
    }

    public Seance(Film film, Salle salle, LocalDateTime debut) {
        setFilm(film);
        setSalle(salle);
        setDebut(debut);
    }

    // Getters
    public Film getFilm() {
        return film;
    }

    public Salle getSalle() {
        return salle;
    }

    public LocalDateTime getDebut() {
        return debut;
    }

    public LocalTime getFin() {
        return fin;
    }

    public VersionLangue getVersionLangue() {
        return versionLangue;
    }

    public String getStatut() {
        return statut;
    }

    public String getDateSeanceFormatted() {
        if (debut == null) {
            return "Non disponible";
        }
        return debut.format(DateTimeFormatter.ofPattern("EEEE dd MMMM yyyy", new Locale("fr", "FR")));
    }

    public String getHeureDebutFormatted() {
        if (debut == null) {
            return "Non disponible";
        }
        return debut.format(DateTimeFormatter.ofPattern("HH:mm"));
    }

    public String getHeureFin() {
        if (fin == null) {
            return "Non disponible";
        }
        return fin.format(DateTimeFormatter.ofPattern("HH:mm"));
    }

    public Integer getPlacesDisponibles() {
        // À implémenter selon la logique métier (capacité - réservations)
        if (salle != null) {
            return salle.getCapacite();
        }
        return 0;
    }

    // Setters avec règles de gestion
    public void setFilm(Film film) {
        if (film == null) {
            throw new IllegalArgumentException("Le film ne peut pas être null");
        }
        this.film = film;
    }

    public void setSalle(Salle salle) {
        if (salle == null) {
            throw new IllegalArgumentException("La salle ne peut pas être null");
        }
        this.salle = salle;
    }

    public void setDebut(LocalDateTime debut) {
        if (debut == null) {
            throw new IllegalArgumentException("La date et heure de début ne peut pas être null");
        }
        this.debut = debut;
    }

    public void setFin(LocalTime fin) {
        this.fin = fin;
    }

    public void setVersionLangue(VersionLangue versionLangue) {
        this.versionLangue = versionLangue;
    }

    public void setStatut(String statut) {
        this.statut = statut;
    }

    // Méthodes métier
    public boolean estValide() {
        return film != null && salle != null && debut != null;
    }

    public boolean estDisponible() {
        if (debut == null) {
            return false;
        }
        return debut.isAfter(LocalDateTime.now());
    }
}
