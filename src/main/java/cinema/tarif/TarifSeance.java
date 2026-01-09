package cinema.tarif;

import jakarta.persistence.*;
import cinema.shared.BaseEntity;
import cinema.seance.Seance;
import cinema.referentiel.typeplace.TypePlace;
import cinema.referentiel.categoriepersonne.CategoriePersonne;

@Entity
@Table(name = "tarif_seance")
public class TarifSeance extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_seance")
    private Seance seance;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_type_place")
    private TypePlace typePlace;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_categorie_personne")
    private CategoriePersonne categoriePersonne;

    @Column(nullable = false)
    private Double prix;

    // Constructeurs
    public TarifSeance() {
    }

    public TarifSeance(Seance seance, TypePlace typePlace, CategoriePersonne categoriePersonne, Double prix) {
        setSeance(seance);
        setTypePlace(typePlace);
        setCategoriePersonne(categoriePersonne);
        setPrix(prix);
    }

    // Getters
    public Seance getSeance() {
        return seance;
    }

    public TypePlace getTypePlace() {
        return typePlace;
    }

    public CategoriePersonne getCategoriePersonne() {
        return categoriePersonne;
    }

    public Double getPrix() {
        return prix;
    }

    // Setters avec règles de gestion
    public void setSeance(Seance seance) {
        this.seance = seance;
    }

    public void setTypePlace(TypePlace typePlace) {
        this.typePlace = typePlace;
    }

    public void setCategoriePersonne(CategoriePersonne categoriePersonne) {
        this.categoriePersonne = categoriePersonne;
    }

    public void setPrix(Double prix) {
        if (prix == null || prix <= 0) {
            throw new IllegalArgumentException("Le prix doit être supérieur à 0");
        }
        this.prix = prix;
    }

    // Méthodes métier
    public boolean estValide() {
        return seance != null && prix != null && prix > 0;
    }
}
