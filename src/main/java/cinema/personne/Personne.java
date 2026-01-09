package cinema.personne;

import jakarta.persistence.*;
import cinema.shared.BaseEntity;

@Entity
@Table(name = "personne")
public class Personne extends BaseEntity {

    @Column(nullable = true)
    private String nomComplet;

    @Column(unique = true, nullable = true)
    private String email;

    @Column(nullable = true)
    private String telephone;

    // Constructeurs
    public Personne() {
    }

    public Personne(String nomComplet, String email, String telephone) {
        setNomComplet(nomComplet);
        setEmail(email);
        setTelephone(telephone);
    }

    // Getters
    public String getNomComplet() {
        return nomComplet;
    }

    public String getEmail() {
        return email;
    }

    public String getTelephone() {
        return telephone;
    }

    // Setters
    public void setNomComplet(String nomComplet) {
        this.nomComplet = nomComplet != null ? nomComplet.trim() : null;
    }

    public void setEmail(String email) {
        this.email = email != null ? email.trim().toLowerCase() : null;
    }

    public void setTelephone(String telephone) {
        this.telephone = telephone != null ? telephone.trim() : null;
    }

    // Méthodes métier
    public boolean estValide() {
        return nomComplet != null && !nomComplet.isEmpty();
    }
}
