package cinema.personne;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional
public class PersonneService {

    private final PersonneRepository personneRepository;

    /**
     * Crée une nouvelle personne
     */
    public Personne creerPersonne(Personne personne) {
        if (!personne.estValide()) {
            throw new IllegalArgumentException("La personne n'est pas valide (nom requis)");
        }
        return personneRepository.save(personne);
    }

    /**
     * Cherche une personne existante par email ou téléphone
     * Si elle existe, la retourne. Sinon, la crée
     */
    public Personne obtenirOuCreerPersonne(String nomComplet, String email, String telephone) {
        // Chercher par email en priorité
        if (email != null && !email.isEmpty()) {
            Optional<Personne> personneExistante = personneRepository.findByEmail(email.trim().toLowerCase());
            if (personneExistante.isPresent()) {
                return personneExistante.get();
            }
        }

        // Chercher par téléphone si pas d'email
        if (telephone != null && !telephone.isEmpty()) {
            Optional<Personne> personneExistante = personneRepository.findByTelephone(telephone.trim());
            if (personneExistante.isPresent()) {
                return personneExistante.get();
            }
        }

        // Créer une nouvelle personne
        Personne nouvellePersonne = new Personne(nomComplet, email, telephone);
        return creerPersonne(nouvellePersonne);
    }

    /**
     * Obtient une personne par ID
     */
    @Transactional(readOnly = true)
    public Personne obtenirPersonneById(Long id) {
        return personneRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Personne non trouvée avec l'ID: " + id));
    }

    /**
     * Obtient une personne par email
     */
    @Transactional(readOnly = true)
    public Optional<Personne> obtenirPersonneParEmail(String email) {
        return personneRepository.findByEmail(email.trim().toLowerCase());
    }

    /**
     * Obtient une personne par téléphone
     */
    @Transactional(readOnly = true)
    public Optional<Personne> obtenirPersonneParTelephone(String telephone) {
        return personneRepository.findByTelephone(telephone.trim());
    }

    /**
     * Obtient toutes les personnes
     */
    @Transactional(readOnly = true)
    public List<Personne> obtenirToutesLesPersonnes() {
        return personneRepository.findAll();
    }

    /**
     * Modifie une personne
     */
    public Personne modifierPersonne(Long id, Personne personneMaj) {
        Personne personne = obtenirPersonneById(id);
        if (personneMaj.getNomComplet() != null) {
            personne.setNomComplet(personneMaj.getNomComplet());
        }
        if (personneMaj.getEmail() != null) {
            personne.setEmail(personneMaj.getEmail());
        }
        if (personneMaj.getTelephone() != null) {
            personne.setTelephone(personneMaj.getTelephone());
        }
        return personneRepository.save(personne);
    }

    /**
     * Supprime une personne
     */
    public void supprimerPersonne(Long id) {
        personneRepository.deleteById(id);
    }
}
