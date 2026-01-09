package cinema.place;

import jakarta.persistence.*;
import cinema.shared.BaseEntity;
import cinema.salle.Salle;
import cinema.referentiel.typeplace.TypePlace;

@Entity
@Table(name = "place", uniqueConstraints = {
    @UniqueConstraint(columnNames = {"id_salle", "rangee", "numero"})
})
public class Place extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_salle")
    private Salle salle;

    @Column
    private String rangee;

    @Column
    private Integer numero;

    @Column
    private String codePlace;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_type_place")
    private TypePlace typePlace;

    // Constructeurs
    public Place() {
    }

    public Place(Salle salle, String rangee, Integer numero, TypePlace typePlace) {
        setSalle(salle);
        setRangee(rangee);
        setNumero(numero);
        setTypePlace(typePlace);
    }

    // Getters
    public Salle getSalle() {
        return salle;
    }

    public String getRangee() {
        return rangee;
    }

    public Integer getNumero() {
        return numero;
    }

    public String getCodePlace() {
        return codePlace;
    }

    public TypePlace getTypePlace() {
        return typePlace;
    }

    // Setters avec règles de gestion
    public void setSalle(Salle salle) {
        if (salle == null) {
            throw new IllegalArgumentException("La salle ne peut pas être null");
        }
        this.salle = salle;
    }

    public void setRangee(String rangee) {
        if (rangee != null && rangee.trim().isEmpty()) {
            this.rangee = null;
        } else {
            this.rangee = rangee;
        }
    }

    public void setNumero(Integer numero) {
        if (numero != null && numero <= 0) {
            throw new IllegalArgumentException("Le numéro de place doit être supérieur à 0");
        }
        this.numero = numero;
    }

    public void setCodePlace(String codePlace) {
        this.codePlace = codePlace;
    }

    public void setTypePlace(TypePlace typePlace) {
        this.typePlace = typePlace;
    }

    // Méthodes métier
    public boolean estValide() {
        return salle != null && numero != null && numero > 0;
    }

    public String genererCodePlace() {
        if (rangee != null && numero != null) {
            this.codePlace = rangee + "-" + numero;
        }
        return this.codePlace;
    }
}
