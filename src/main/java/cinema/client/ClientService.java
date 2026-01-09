package cinema.client;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class ClientService {

    private final ClientRepository clientRepository;

    public Client creerClient(Client client) {
        if (!client.estValide()) {
            throw new IllegalArgumentException("Le client n'est pas valide");
        }
        // Vérifier que l'email n'existe pas déjà
        if (clientRepository.findByEmail(client.getEmail()).isPresent()) {
            throw new IllegalArgumentException("Un client avec cet email existe déjà");
        }
        return clientRepository.save(client);
    }

    public Client modifierClient(Long id, Client clientMaj) {
        Client client = obtenirClientById(id);
        if (!clientMaj.estValide()) {
            throw new IllegalArgumentException("Le client n'est pas valide");
        }
        client.setNomComplet(clientMaj.getNomComplet());
        client.setTelephone(clientMaj.getTelephone());
        return clientRepository.save(client);
    }

    public void supprimerClient(Long id) {
        clientRepository.deleteById(id);
    }

    @Transactional(readOnly = true)
    public Client obtenirClientById(Long id) {
        return clientRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Client non trouvé avec l'ID: " + id));
    }

    @Transactional(readOnly = true)
    public Client obtenirClientParEmail(String email) {
        return clientRepository.findByEmail(email)
            .orElseThrow(() -> new RuntimeException("Client non trouvé avec l'email: " + email));
    }

    @Transactional(readOnly = true)
    public List<Client> obtenirTousLesClients() {
        return clientRepository.findAll();
    }

    @Transactional(readOnly = true)
    public List<Client> rechercherParEmail(String email) {
        return clientRepository.findByEmailContainingIgnoreCase(email);
    }
}

