package cinema.client;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/clients")
@RequiredArgsConstructor
@SuppressWarnings("unused")
public class ClientController {

    private final ClientService clientService;

    @GetMapping
    public String listerClients(Model model) {
        // À implémenter
        return "clients/liste";
    }

    @GetMapping("/{id}")
    public String afficherDetail(@PathVariable Long id, Model model) {
        // À implémenter
        return "clients/detail";
    }

    @GetMapping("/nouveau")
    public String formulaireCreation(Model model) {
        // À implémenter
        return "clients/formulaire";
    }

    @PostMapping
    public String creerClient(Client client) {
        // À implémenter
        return "redirect:/clients";
    }
}
