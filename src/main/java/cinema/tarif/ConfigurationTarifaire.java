package cinema.tarif;

import jakarta.persistence.*;
import cinema.shared.BaseEntity;
import cinema.referentiel.categoriepersonne.CategoriePersonne;

/**
 * Configuration tarifaire qui définit les relations de référence entre catégories de personne
 * Exemple : Enfant référence Adulte avec coefficient 0.5 (enfant = 50% du tarif adulte)
 *          Senior référence Enfant avec coefficient 1.5 (senior = 150% du tarif enfant)
 */
@Entity
@Table(name = "configuration_tarifaire", uniqueConstraints = {
    @UniqueConstraint(columnNames = {"id_categorie_personne"})
})
public class ConfigurationTarifaire extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_categorie_personne", nullable = false)
    private CategoriePersonne categoriePersonne;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_categorie_reference", nullable = true)
    private CategoriePersonne categorieReference;

    @Column(name = "coefficient_multiplicateur", nullable = false, columnDefinition = "NUMERIC(5,2)")
    private Double coefficientMultiplicateur;

    @Column(name = "description", length = 500)
    private String description;

    // Constructeurs
    public ConfigurationTarifaire() {
    }

    public ConfigurationTarifaire(CategoriePersonne categoriePersonne, CategoriePersonne categorieReference, Double coefficientMultiplicateur) {
        setCategoriePersonne(categoriePersonne);
        setCategorieReference(categorieReference);
        setCoefficientMultiplicateur(coefficientMultiplicateur);
    }

    // Getters
    public CategoriePersonne getCategoriePersonne() {
        return categoriePersonne;
    }

    public CategoriePersonne getCategorieReference() {
        return categorieReference;
    }

    public Double getCoefficientMultiplicateur() {
        return coefficientMultiplicateur;
    }

    public String getDescription() {
        return description;
    }

    // Setters avec règles de gestion
    public void setCategoriePersonne(CategoriePersonne categoriePersonne) {
        if (categoriePersonne == null) {
            throw new IllegalArgumentException("La catégorie de personne est obligatoire");
        }
        this.categoriePersonne = categoriePersonne;
    }

    public void setCategorieReference(CategoriePersonne categorieReference) {
        // categorieReference peut être null pour les catégories autonomes (prix fixe)
        this.categorieReference = categorieReference;
    }

    public void setCoefficientMultiplicateur(Double coefficientMultiplicateur) {
        if (coefficientMultiplicateur == null || coefficientMultiplicateur <= 0) {
            throw new IllegalArgumentException("Le coefficient multiplicateur doit être supérieur à 0");
        }
        this.coefficientMultiplicateur = coefficientMultiplicateur;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    // Méthodes métier
    public boolean estValide() {
        return categoriePersonne != null && 
               coefficientMultiplicateur != null && 
               coefficientMultiplicateur > 0;
    }

    /**
     * Vérifie si cette catégorie a une référence (donc un tarif calculé)
     * ou si c'est une catégorie autonome (prix fixe défini manuellement)
     */
    public boolean aUneReference() {
        return categorieReference != null;
    }

    /**
     * Calcule le tarif pour cette catégorie basé sur le tarif de sa référence
     * @param tarifReference Le tarif de la catégorie de référence
     * @return Le tarif calculé pour cette catégorie
     */
    public Double calculerTarif(Double tarifReference) {
        if (!aUneReference()) {
            throw new IllegalArgumentException("Cette catégorie n'a pas de référence, le tarif doit être défini manuellement");
        }
        if (tarifReference == null || tarifReference <= 0) {
            throw new IllegalArgumentException("Le tarif de référence doit être supérieur à 0");
        }
        return Math.round(tarifReference * coefficientMultiplicateur * 100.0) / 100.0;
    }

    /**
     * Retourne le pourcentage par rapport à la référence
     * @return Le pourcentage (ex: 50 pour 50%, 150 pour 150%)
     */
    public Double getPourcentageParRapportReference() {
        return coefficientMultiplicateur * 100;
    }

    /**
     * Retourne la différence en pourcentage par rapport à la référence
     * @return La différence en pourcentage (ex: -50 pour 50% moins cher, +50 pour 50% plus cher)
     */
    public Double getDifferenceEnPourcentage() {
        return (coefficientMultiplicateur - 1.0) * 100;
    }

    /**
     * Retourne une description lisible de la relation
     * @return Description de la relation (ex: "Enfant = 50% du tarif Adulte")
     */
    public String getDescriptionRelation() {
        if (!aUneReference()) {
            return categoriePersonne.getLibelle() + " (tarif autonome)";
        }
        
        double pourcentage = getPourcentageParRapportReference();
        return categoriePersonne.getLibelle() + " = " + (int) pourcentage + "% du tarif " 
               + categorieReference.getLibelle();
    }
}