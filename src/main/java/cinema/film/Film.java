package cinema.film;

import jakarta.persistence.*;
import cinema.shared.BaseEntity;
import cinema.referentiel.langue.Langue;
import cinema.referentiel.genre.Genre;
import org.springframework.format.annotation.DateTimeFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.HashSet;
import java.util.Set;
import java.util.Locale;

@Entity
@Table(name = "film")
public class Film extends BaseEntity {

    @Column(nullable = false)
    private String titre;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column
    private Integer dureeMinutes;

    @Column
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private LocalDate dateSortie;

    @Column
    private Integer ageMin;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_langue_originale")
    private Langue langueOriginale;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
        name = "film_genre",
        joinColumns = @JoinColumn(name = "id_film"),
        inverseJoinColumns = @JoinColumn(name = "id_genre")
    )
    private Set<Genre> genres = new HashSet<>();

    // Constructeurs
    public Film() {
    }

    public Film(String titre, Integer dureeMinutes) {
        setTitre(titre);
        setDureeMinutes(dureeMinutes);
    }

    // Getters
    public String getTitre() {
        return titre;
    }

    public String getDescription() {
        return description;
    }

    public Integer getDureeMinutes() {
        return dureeMinutes;
    }

    public LocalDate getDateSortie() {
        return dateSortie;
    }

    public Integer getAgeMin() {
        return ageMin;
    }

    public Langue getLangueOriginale() {
        return langueOriginale;
    }

    public Set<Genre> getGenres() {
        return genres;
    }

    public String getDateSortieFormatted() {
        if (dateSortie == null) {
            return "Non disponible";
        }
        return dateSortie.format(DateTimeFormatter.ofPattern("dd MMMM yyyy", new Locale("fr", "FR")));
    }

    // Setters avec règles de gestion
    public void setTitre(String titre) {
        if (titre == null || titre.trim().isEmpty()) {
            throw new IllegalArgumentException("Le titre du film ne peut pas être vide");
        }
        this.titre = titre.trim();
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public void setDureeMinutes(Integer dureeMinutes) {
        if (dureeMinutes != null && dureeMinutes <= 0) {
            throw new IllegalArgumentException("La durée doit être supérieure à 0 minutes");
        }
        this.dureeMinutes = dureeMinutes;
    }

    public void setDateSortie(LocalDate dateSortie) {
        this.dateSortie = dateSortie;
    }

    public void setAgeMin(Integer ageMin) {
        if (ageMin != null && ageMin < 0) {
            throw new IllegalArgumentException("L'âge minimum ne peut pas être négatif");
        }
        this.ageMin = ageMin;
    }

    public void setLangueOriginale(Langue langueOriginale) {
        this.langueOriginale = langueOriginale;
    }

    public void setGenres(Set<Genre> genres) {
        this.genres = genres;
    }

    // Méthodes helper pour gérer les genres
    public void addGenre(Genre genre) {
        this.genres.add(genre);
    }

    public void removeGenre(Genre genre) {
        this.genres.remove(genre);
    }

    public boolean contientGenre(Genre genre) {
        return this.genres != null && this.genres.contains(genre);
    }

    // Méthodes métier
    public boolean estValide() {
        return titre != null && !titre.isEmpty() 
            && dureeMinutes != null && dureeMinutes > 0;
    }
}