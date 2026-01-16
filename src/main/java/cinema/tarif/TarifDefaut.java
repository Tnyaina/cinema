package cinema.tarif;

import jakarta.persistence.*;
import cinema.shared.BaseEntity;
import cinema.referentiel.typeplace.TypePlace;
import cinema.referentiel.categoriepersonne.CategoriePersonne;

@Entity
@Table(name = "tarif_defaut")
public class TarifDefaut extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_type_place")
    private TypePlace typePlace;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_categorie_personne")
    private CategoriePersonne categoriePersonne;

    @Column(nullable = false, columnDefinition = "NUMERIC(15,2)")
    private Double prix;

    // Constructeurs
    public TarifDefaut() {
    }

    public TarifDefaut(TypePlace typePlace, CategoriePersonne categoriePersonne, Double prix) {
        setTypePlace(typePlace);
        setCategoriePersonne(categoriePersonne);
        setPrix(prix);
    }

    // Getters
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
        return prix != null && prix > 0;
    }
}
