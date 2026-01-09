package cinema.client;

import jakarta.persistence.*;
import cinema.shared.BaseEntity;

@Entity
@Table(name = "personne")
public class Client extends BaseEntity {

    @Column
    private String nomComplet;

    @Column(unique = true)
    private String email;

    @Column
    private String telephone;

    // Constructeurs
    public Client() {
    }

    public Client(String nomComplet, String email, String telephone) {
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

    // Setters avec règles de gestion
    public void setNomComplet(String nomComplet) {
        this.nomComplet = nomComplet;
    }

    public void setEmail(String email) {
        if (email != null && !email.trim().isEmpty()) {
            String trimmedEmail = email.trim();
            if (!trimmedEmail.contains("@") || !trimmedEmail.contains(".")) {
                throw new IllegalArgumentException("L'email doit être valide");
            }
            this.email = trimmedEmail;
        } else {
            this.email = email;
        }
    }

    public void setTelephone(String telephone) {
        this.telephone = telephone;
    }

    // Méthodes métier
    public boolean estValide() {
        return nomComplet != null && !nomComplet.isEmpty()
            && email != null && !email.isEmpty();
    }
}
