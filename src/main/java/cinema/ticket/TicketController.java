package cinema.ticket;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import cinema.seance.SeanceService;
import cinema.place.PlaceService;
import cinema.tarif.TarifSeanceRepository;
import cinema.tarif.TarifDefautRepository;
import cinema.referentiel.categoriepersonne.CategoriePersonneRepository;
import cinema.shared.StatusRepository;
import cinema.client.ClientService;
import cinema.reservation.ReservationService;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import java.util.List;

@Controller
@RequestMapping("/tickets")
@RequiredArgsConstructor
@SuppressWarnings("unused")
public class TicketController {

    private final TicketService ticketService;
    private final SeanceService seanceService;
    private final PlaceService placeService;
    private final TarifSeanceRepository tarifSeanceRepository;
    private final TarifDefautRepository tarifDefautRepository;
    private final CategoriePersonneRepository categoriePersonneRepository;
    private final StatusRepository statusRepository;
    private final ClientService clientService;
    private final ReservationService reservationService;

    @GetMapping
    public String listerTickets(Model model) {
        var tickets = ticketService.obtenirTousLesTickets();
        model.addAttribute("tickets", tickets);
        model.addAttribute("page", "tickets/liste");
        model.addAttribute("pageTitle", "Gestion des Tickets Vendus");
        model.addAttribute("pageActive", "tickets");
        return "layout";
    }

    @GetMapping("/reservation/{reservationId}")
    public String listerTicketsByReservation(@PathVariable Long reservationId, Model model) {
        // À implémenter
        return "tickets/liste";
    }

    @GetMapping("/{id}")
    public String afficherDetail(@PathVariable Long id, Model model) {
        // À implémenter
        return "tickets/detail";
    }

    @GetMapping("/nouveau")
    public String formulaireCreation(Model model) {
        // À implémenter
        return "tickets/formulaire";
    }

    @PostMapping
    public String creerTicket(Ticket ticket) {
        // À implémenter
        return "redirect:/tickets";
    }

    @PostMapping("/acheter")
    public String acheterTickets(
            @RequestParam Long seanceId,
            @RequestParam(required = false) List<Long> placeIds,
            @RequestParam(required = false) String nomComplet,
            @RequestParam(required = false) String email,
            @RequestParam(required = false) String telephone,
            RedirectAttributes redirectAttributes) {
        
        try {
            // Valider que des places sont sélectionnées
            if (placeIds == null || placeIds.isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Veuillez sélectionner au moins une place");
                return "redirect:/seances/" + seanceId;
            }

            // Valider les infos du client
            if (nomComplet == null || nomComplet.trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Le nom est requis");
                return "redirect:/seances/" + seanceId;
            }
            
            // Obtenir la séance
            var seance = seanceService.obtenirSeanceById(seanceId);
            
            // Obtenir ou créer le Client
            var client = clientService.obtenirOuCreerClient(nomComplet, email, telephone);
            
            // Obtenir le status CREE pour la réservation
            var statusCree = statusRepository.findByCode("CREE")
                .orElseThrow(() -> new RuntimeException("Status CREE non trouvé"));
            
            // Créer la Réservation
            var reservation = new cinema.reservation.Reservation();
            reservation.setPersonne(client);
            reservation.setSeance(seance);
            reservation.setStatus(statusCree);
            reservation.setMontantTotal(0.0);
            
            // SAUVEGARDER la réservation AVANT de créer les tickets
            reservationService.creerReservation(reservation);
            
            // Obtenir la catégorie personne par défaut (ADULTE)
            var categoriePersonne = categoriePersonneRepository.findByLibelle("ADULTE")
                .orElseThrow(() -> new RuntimeException("Catégorie ADULTE non trouvée"));
            
            // Obtenir le status RESERVEE pour les tickets
            var statusReservee = statusRepository.findByCode("RESERVEE")
                .orElseThrow(() -> new RuntimeException("Status RESERVEE non trouvé"));
            
            Double prixTotal = 0.0;
            int compteur = 0;
            
            // Créer un ticket pour chaque place sélectionnée
            for (Long placeId : placeIds) {
                var place = placeService.obtenirPlaceById(placeId);
                
                // Vérifier que la place n'est pas déjà réservée
                if (!placeService.isPlaceDisponibleForSeance(seanceId, placeId)) {
                    redirectAttributes.addFlashAttribute("error", 
                        "La place " + place.getRangee() + place.getNumero() + " est déjà réservée");
                    return "redirect:/seances/" + seanceId;
                }
                
                // Obtenir le prix pour ce type de place
                // D'abord chercher dans les tarifs de séance
                var tarifSeanceOptional = tarifSeanceRepository.findBySeanceIdAndTypePlaceId(seanceId, place.getTypePlace().getId());
                
                Double prix;
                if (tarifSeanceOptional.isPresent()) {
                    // Si un tarif de séance existe, l'utiliser
                    prix = tarifSeanceOptional.get().getPrix();
                } else {
                    // Sinon, chercher dans les tarifs défaut
                    var tarifDefautOptional = tarifDefautRepository.findByTypePlaceIdAndCategoriePersonneId(
                        place.getTypePlace().getId(),
                        categoriePersonne.getId()
                    );
                    prix = tarifDefautOptional.map(t -> t.getPrix()).orElse(12.0); // Prix par défaut
                }
                
                // Créer le ticket avec la réservation déjà persistée
                Ticket ticket = new Ticket();
                ticket.setReservation(reservation);
                ticket.setSeance(seance);
                ticket.setPlace(place);
                ticket.setStatus(statusReservee);
                ticket.setCategoriePersonne(categoriePersonne);
                ticket.setPrix(prix);
                
                ticketService.creerTicket(ticket);
                prixTotal += prix;
                compteur++;
            }

            // Mettre à jour le montant total de la réservation
            reservation.setMontantTotal(prixTotal);
            reservationService.creerReservation(reservation);
            
            redirectAttributes.addFlashAttribute("success", 
                compteur + " ticket(s) réservé(s) avec succès! Réservation #" + reservation.getId() + " - Total: " + String.format("%.2f", prixTotal) + " €");
            return "redirect:/seances/" + seanceId;
            
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors de la création des tickets: " + e.getMessage());
            return "redirect:/seances/" + seanceId;
        }
    }

    @GetMapping("/{id}/modifier")
    public String formulaireModification(@PathVariable Long id, Model model) {
        // À implémenter
        return "tickets/formulaire";
    }

    @PostMapping("/{id}")
    public String modifierTicket(@PathVariable Long id, Ticket ticket) {
        // À implémenter
        return "redirect:/tickets/" + id;
    }

    @PostMapping("/{id}/supprimer")
    public String supprimerTicket(@PathVariable Long id) {
        // À implémenter
        return "redirect:/tickets";
    }
}
