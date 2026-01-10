package cinema.reservation;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import cinema.client.Client;
import cinema.client.ClientService;
import cinema.seance.Seance;
import cinema.place.Place;
import cinema.place.PlaceService;
import cinema.ticket.Ticket;
import cinema.ticket.TicketService;
import cinema.referentiel.categoriepersonne.CategoriePersonne;
import cinema.referentiel.categoriepersonne.CategoriePersonneRepository;
import cinema.tarif.TarifSeanceRepository;
import cinema.tarif.TarifDefautRepository;
import cinema.shared.StatusRepository;
import cinema.historique.HistoriqueStatutReservation;
import cinema.historique.HistoriqueStatutTicket;
import cinema.historique.HistoriqueStatutReservationRepository;
import cinema.historique.HistoriqueStatutTicketRepository;
import java.util.List;

/**
 * Service spécialisé pour la création de réservations avec tickets.
 * Centralise la logique métier pour éviter les méthodes surchargées.
 */
@Service
@RequiredArgsConstructor
@Transactional
public class ReservationCreationService {

    private final ReservationService reservationService;
    private final TicketService ticketService;
    private final ClientService clientService;
    private final PlaceService placeService;
    private final CategoriePersonneRepository categoriePersonneRepository;
    private final StatusRepository statusRepository;
    private final TarifSeanceRepository tarifSeanceRepository;
    private final TarifDefautRepository tarifDefautRepository;
    private final HistoriqueStatutReservationRepository historiqueReservationRepository;
    private final HistoriqueStatutTicketRepository historiqueTicketRepository;

    /**
     * Crée une réservation avec ses tickets dans une transaction unique.
     * En cas d'erreur, tout est rollback.
     */
    public ReservationCreationResult creerReservationAvecTickets(
            Seance seance,
            String nomClient,
            String email,
            String telephone,
            List<PlaceSelection> placesSelection) {

        // Valider les paramètres
        validerParametres(seance, placesSelection);

        // Vérifier que la séance est disponible
        verifierSeanceDisponible(seance);

        // Vérifier la disponibilité des places
        verifierPlacesDisponibles(seance.getId(), placesSelection);

        // Obtenir ou créer le client
        Client client = obtenirOuCreerClient(nomClient, email, telephone);

        // Créer la réservation
        Reservation reservation = creerReservation(client, seance);

        // Enregistrer dans l'historique
        enregistrerHistoriqueReservation(reservation, "CREE");

        // Créer les tickets
        Double montantTotal = 0.0;
        for (PlaceSelection placeSelection : placesSelection) {
            Ticket ticket = creerTicket(reservation, seance, placeSelection);
            ticketService.creerTicket(ticket);
            enregistrerHistoriqueTicket(ticket, "RESERVEE");
            montantTotal += ticket.getPrix();
        }

        // Mettre à jour le montant total
        reservation.setMontantTotal(montantTotal);
        reservationService.creerReservation(reservation);

        return new ReservationCreationResult(reservation, placesSelection.size(), montantTotal);
    }

    // ==================== Validations ====================

    private void validerParametres(Seance seance, List<PlaceSelection> placesSelection) {
        if (seance == null) {
            throw new IllegalArgumentException("La séance ne peut pas être null");
        }
        if (placesSelection == null || placesSelection.isEmpty()) {
            throw new IllegalArgumentException("Veuillez sélectionner au moins une place");
        }
    }

    private void verifierSeanceDisponible(Seance seance) {
        // Vérifier que la séance est en statut DISPONIBLE
        if (seance.getStatut() == null || !seance.getStatut().equals("Disponible")) {
            throw new IllegalStateException("La séance n'est pas disponible pour les réservations");
        }
    }

    private void verifierPlacesDisponibles(Long seanceId, List<PlaceSelection> placesSelection) {
        for (PlaceSelection selection : placesSelection) {
            Place place = placeService.obtenirPlaceById(selection.getPlaceId());
            
            if (!placeService.isPlaceDisponibleForSeance(seanceId, selection.getPlaceId())) {
                String codePlace = place.getRangee() + place.getNumero();
                throw new IllegalStateException(
                    "La place " + codePlace + " n'est plus disponible"
                );
            }
        }
    }

    // ==================== Création Entités ====================

    private Client obtenirOuCreerClient(String nomClient, String email, String telephone) {
        return clientService.obtenirOuCreerClient(nomClient, email, telephone);
    }

    private Reservation creerReservation(Client client, Seance seance) {
        Reservation reservation = new Reservation();
        reservation.setPersonne(client);
        reservation.setSeance(seance);

        var statusCree = statusRepository.findByCode("CREE")
            .orElseThrow(() -> new RuntimeException("Status CREE non trouvé en base"));
        reservation.setStatus(statusCree);
        reservation.setMontantTotal(0.0);

        return reservationService.creerReservation(reservation);
    }

    private Ticket creerTicket(Reservation reservation, Seance seance, PlaceSelection placeSelection) {
        Place place = placeService.obtenirPlaceById(placeSelection.getPlaceId());
        CategoriePersonne categorie = obtenirCategorie(placeSelection.getCategorieId());
        Double prix = obtenirPrix(seance.getId(), place, categorie);

        Ticket ticket = new Ticket();
        ticket.setReservation(reservation);
        ticket.setSeance(seance);
        ticket.setPlace(place);
        ticket.setCategoriePersonne(categorie);
        ticket.setPrix(prix);

        var statusReservee = statusRepository.findByCode("RESERVEE")
            .orElseThrow(() -> new RuntimeException("Status RESERVEE non trouvé en base"));
        ticket.setStatus(statusReservee);

        return ticket;
    }

    // ==================== Récupération Données ====================

    private CategoriePersonne obtenirCategorie(Long categorieId) {
        return categoriePersonneRepository.findById(categorieId)
            .orElseThrow(() -> new RuntimeException(
                "Catégorie de personne non trouvée avec l'ID: " + categorieId
            ));
    }

    private Double obtenirPrix(Long seanceId, Place place, CategoriePersonne categorie) {
        Long typePlaceId = place.getTypePlace().getId();
        Long categorieId = categorie.getId();

        // D'abord chercher un tarif spécifique à la séance
        var tarifSeanceOpt = tarifSeanceRepository
            .findBySeanceIdAndTypePlaceIdAndCategoriePersonneId(seanceId, typePlaceId, categorieId);

        if (tarifSeanceOpt.isPresent()) {
            return tarifSeanceOpt.get().getPrix();
        }

        // Sinon chercher un tarif par défaut
        var tarifDefautOpt = tarifDefautRepository
            .findByTypePlaceIdAndCategoriePersonneId(typePlaceId, categorieId);

        if (tarifDefautOpt.isPresent()) {
            return tarifDefautOpt.get().getPrix();
        }

        // Fallback
        return 12.0;
    }

    // ==================== Historique ====================

    private void enregistrerHistoriqueReservation(Reservation reservation, String codeStatus) {
        var status = statusRepository.findByCode(codeStatus)
            .orElseThrow(() -> new RuntimeException("Status " + codeStatus + " non trouvé"));

        HistoriqueStatutReservation historique = new HistoriqueStatutReservation();
        historique.setReservation(reservation);
        historique.setStatus(status);
        historique.setCommentaire("Réservation créée");

        historiqueReservationRepository.save(historique);
    }

    private void enregistrerHistoriqueTicket(Ticket ticket, String codeStatus) {
        var status = statusRepository.findByCode(codeStatus)
            .orElseThrow(() -> new RuntimeException("Status " + codeStatus + " non trouvé"));

        HistoriqueStatutTicket historique = new HistoriqueStatutTicket();
        historique.setTicket(ticket);
        historique.setStatus(status);
        historique.setCommentaire("Ticket réservé");

        historiqueTicketRepository.save(historique);
    }

    // ==================== DTO ====================

    public static class PlaceSelection {
        private Long placeId;
        private Long categorieId;

        public PlaceSelection(Long placeId, Long categorieId) {
            this.placeId = placeId;
            this.categorieId = categorieId;
        }

        public Long getPlaceId() {
            return placeId;
        }

        public Long getCategorieId() {
            return categorieId;
        }
    }

    public static class ReservationCreationResult {
        private Reservation reservation;
        private Integer nombreTickets;
        private Double montantTotal;

        public ReservationCreationResult(Reservation reservation, Integer nombreTickets, Double montantTotal) {
            this.reservation = reservation;
            this.nombreTickets = nombreTickets;
            this.montantTotal = montantTotal;
        }

        public Reservation getReservation() {
            return reservation;
        }

        public Integer getNombreTickets() {
            return nombreTickets;
        }

        public Double getMontantTotal() {
            return montantTotal;
        }
    }
}
