package cinema.seance;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.transaction.annotation.Transactional;
import cinema.place.Place;
import cinema.place.PlaceService;
import cinema.tarif.TarifSeance;
import cinema.tarif.TarifSeanceRepository;
import cinema.ticket.TicketService;
import cinema.referentiel.typeplace.TypePlace;
import cinema.referentiel.typeplace.TypePlaceRepository;
import cinema.referentiel.categoriepersonne.CategoriePersonne;
import cinema.referentiel.categoriepersonne.CategoriePersonneRepository;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.ArrayList;

@Controller
@RequestMapping("/seances")
@RequiredArgsConstructor
public class SeanceController {

    private final SeanceService seanceService;
    private final PlaceService placeService;
    private final TarifSeanceRepository tarifSeanceRepository;
    private final TicketService ticketService;
    private final TypePlaceRepository typePlaceRepository;
    private final CategoriePersonneRepository categoriePersonneRepository;

    @GetMapping
    public String listerSeances(
            @RequestParam(required = false) Long film,
            @RequestParam(required = false) Long salle,
            @RequestParam(required = false) String date,
            Model model) {
        
        List<Seance> seances;
        
        if (film != null) {
            seances = seanceService.obtenirSeancesParFilm(film);
        } else if (salle != null) {
            seances = seanceService.obtenirSeancesParSalle(salle);
        } else {
            seances = seanceService.obtenirToutesLesSeances();
        }
        
        // Appliquer le filtre de date si fourni
        if (date != null && !date.isEmpty()) {
            seances = seanceService.filtrerSeancesParDate(seances, date);
        }
        
        model.addAttribute("seances", seances);
        model.addAttribute("films", seanceService.obtenirTousLesFilms());
        model.addAttribute("salles", seanceService.obtenirToutesLesSalles());
        model.addAttribute("selectedDate", date);
        model.addAttribute("page", "seances/index");
        model.addAttribute("pageTitle", "Séances");
        model.addAttribute("pageActive", "seances");
        return "layout";
    }

    @GetMapping("/{id}")
    public String afficherDetail(@PathVariable Long id, Model model) {
        Seance seance = seanceService.obtenirSeanceById(id);
        
        // Obtenir les places de la salle
        Long salleId = seance.getSalle().getId();
        List<Place> toutesLesPlaces = placeService.obtenirPlacesParSalle(salleId);
        
        // Obtenir les places disponibles pour cette séance
        List<Place> placesDisponibles = placeService.obtenirPlacesDisponiblesBySeance(id, salleId);
        List<Place> placesReservees = placeService.obtenirPlacesReserveesBySeance(id, salleId);
        
        // Grouper les places par rangée pour affichage
        Map<String, List<Place>> placesParRangee = placeService.obtenirPlacesGroupeesParRangee(salleId);
        
        // Obtenir les tarifs pour cette séance
        List<TarifSeance> tarifs = tarifSeanceRepository.findBySeanceId(id);
        Map<Long, Double> prixParTypePlace = new HashMap<>();
        for (TarifSeance tarif : tarifs) {
            prixParTypePlace.put(tarif.getTypePlace().getId(), tarif.getPrix());
        }
        
        // Grouper les places par type de place
        Map<String, List<Place>> placesParType = new HashMap<>();
        for (Place place : toutesLesPlaces) {
            String typeLabel = place.getTypePlace() != null ? place.getTypePlace().getLibelle() : "Standard";
            placesParType.computeIfAbsent(typeLabel, k -> new ArrayList<>()).add(place);
        }
        
        // Calculer les informations
        Integer placesDispoCount = placeService.obtenirNombrePlacesDisponibles(id, salleId);
        Integer placesReserveeCount = toutesLesPlaces.size() - placesDispoCount;
        Double tauxOccupation = placeService.obtenirTauxOccupation(id, salleId);
        // Calculer le chiffre d'affaires pour cette séance
        Double chiffresAffaires = ticketService.calculerChiffresAffairesSeance(id);
        
        model.addAttribute("seance", seance);
        model.addAttribute("placesParRangee", placesParRangee);
        model.addAttribute("placesParType", placesParType);
        model.addAttribute("prixParTypePlace", prixParTypePlace);
        model.addAttribute("placesReservees", placesReservees);
        model.addAttribute("placesDisponibles", placesDisponibles);
        model.addAttribute("placesDispoCount", placesDispoCount);
        model.addAttribute("placesReserveeCount", placesReserveeCount);
        model.addAttribute("tauxOccupation", String.format("%.0f", tauxOccupation));
        model.addAttribute("totalPlaces", toutesLesPlaces.size());
        model.addAttribute("tarifs", tarifs);
        model.addAttribute("chiffresAffaires", chiffresAffaires);
        model.addAttribute("page", "seances/detail");
        model.addAttribute("pageTitle", "Réserver - " + seance.getFilm().getTitre());
        model.addAttribute("pageActive", "seances");
        return "layout";
    }

    @GetMapping("/nouveau")
    public String formulaireCreation(Model model) {
        model.addAttribute("seance", new Seance());
        model.addAttribute("films", seanceService.obtenirTousLesFilms());
        model.addAttribute("salles", seanceService.obtenirToutesLesSalles());
        model.addAttribute("versionLangues", seanceService.obtenirToutesLesVersionsLangue());
        model.addAttribute("typePlaces", typePlaceRepository.findAll());
        model.addAttribute("categoriesPersonne", categoriePersonneRepository.findAll());
        model.addAttribute("seancesExistantes", seanceService.obtenirToutesLesSeances());
        model.addAttribute("page", "seances/formulaire");
        model.addAttribute("pageTitle", "Ajouter une séance");
        model.addAttribute("pageActive", "seances");
        return "layout";
    }

    @PostMapping
    public String creerSeance(
            Seance seance,
            @RequestParam(required = false) Long filmId,
            @RequestParam(required = false) Long salleId,
            @RequestParam(required = false) Long versionLangueId,
            @RequestParam Map<String, String> params) {
        
        System.out.println("========== DEBUG CREATION SEANCE ==========");
        System.out.println("Tous les paramètres reçus:");
        params.forEach((key, value) -> System.out.println("  " + key + " = " + value));
        System.out.println("==========================================");
        
        if (filmId != null) {
            seance.setFilm(seanceService.obtenirFilmById(filmId));
        }
        if (salleId != null) {
            seance.setSalle(seanceService.obtenirSalleById(salleId));
        }
        if (versionLangueId != null) {
            seance.setVersionLangue(seanceService.obtenirVersionLangueById(versionLangueId));
        }
        
        // Vérifier que fin est correctement défini (debug)
        if (seance.getFin() != null) {
            System.out.println("Fin reçue: " + seance.getFin());
        } else {
            System.out.println("Fin est NULL - problème de binding!");
        }
        
        Seance seanceCree = seanceService.creerSeance(seance);
        
        // Traiter les tarifs optionnels
        sauvegarderTarifs(seanceCree.getId(), params);
        
        return "redirect:/seances/" + seanceCree.getId();
    }

    @GetMapping("/{id}/modifier")
    public String formulaireModification(@PathVariable Long id, Model model) {
        Seance seance = seanceService.obtenirSeanceById(id);
        model.addAttribute("seance", seance);
        model.addAttribute("films", seanceService.obtenirTousLesFilms());
        model.addAttribute("salles", seanceService.obtenirToutesLesSalles());
        model.addAttribute("versionLangues", seanceService.obtenirToutesLesVersionsLangue());
        model.addAttribute("typePlaces", typePlaceRepository.findAll());
        model.addAttribute("categoriesPersonne", categoriePersonneRepository.findAll());
        model.addAttribute("tarifs", tarifSeanceRepository.findBySeanceId(id));
        model.addAttribute("seancesExistantes", seanceService.obtenirToutesLesSeances());
        model.addAttribute("page", "seances/formulaire");
        model.addAttribute("pageTitle", "Modifier: " + seance.getFilm().getTitre());
        model.addAttribute("pageActive", "seances");
        return "layout";
    }

    @PostMapping("/{id}")
    @Transactional
    public String modifierSeance(
            @PathVariable Long id,
            Seance seance,
            @RequestParam(required = false) Long filmId,
            @RequestParam(required = false) Long salleId,
            @RequestParam(required = false) Long versionLangueId,
            @RequestParam Map<String, String> params) {
        
        if (filmId != null) {
            seance.setFilm(seanceService.obtenirFilmById(filmId));
        }
        if (salleId != null) {
            seance.setSalle(seanceService.obtenirSalleById(salleId));
        }
        if (versionLangueId != null) {
            seance.setVersionLangue(seanceService.obtenirVersionLangueById(versionLangueId));
        }
        
        seanceService.modifierSeance(id, seance);
        
        // Supprimer les anciens tarifs et en créer de nouveaux
        tarifSeanceRepository.deleteBySeanceId(id);
        sauvegarderTarifs(id, params);
        
        return "redirect:/seances/" + id;
    }

    @GetMapping("/{id}/supprimer")
    public String confirmationSuppression(@PathVariable Long id, Model model) {
        Seance seance = seanceService.obtenirSeanceById(id);
        model.addAttribute("seance", seance);
        model.addAttribute("page", "seances/suppression");
        model.addAttribute("pageTitle", "Supprimer: " + seance.getFilm().getTitre());
        model.addAttribute("pageActive", "seances");
        return "layout";
    }

    @PostMapping("/{id}/supprimer")
    public String supprimerSeance(@PathVariable Long id) {
        seanceService.supprimerSeance(id);
        return "redirect:/seances";
    }

    // Méthode utilitaire pour sauvegarder les tarifs d'une séance
    @Transactional
    private void sauvegarderTarifs(Long seanceId, Map<String, String> params) {
        Seance seance = seanceService.obtenirSeanceById(seanceId);
        
        System.out.println("========== DEBUG TARIFS ==========");
        System.out.println("Sauvegarde des tarifs pour séance " + seanceId);
        
        int index = 0;
        int emptyCount = 0;
        int maxEmptyConsecutive = 3; // Arrêter après 3 indices vides consécutifs
        
        while (index <= 100 && emptyCount < maxEmptyConsecutive) {
            String typePlaceIdStr = params.get("tarif_typePlace_" + index);
            String categorieIdStr = params.get("tarif_categorie_" + index);
            String prixStr = params.get("tarif_prix_" + index);
            
            // Si l'un des paramètres manque ou est vide, compter comme vide
            if (typePlaceIdStr == null || typePlaceIdStr.isEmpty() || 
                categorieIdStr == null || categorieIdStr.isEmpty() || 
                prixStr == null || prixStr.isEmpty()) {
                emptyCount++;
                index++;
                continue;
            }
            
            // Réinitialiser le compteur d'indices vides si on trouve des données
            emptyCount = 0;
            
            try {
                Long typePlaceId = Long.parseLong(typePlaceIdStr);
                Long categorieId = Long.parseLong(categorieIdStr);
                Double prix = Double.parseDouble(prixStr);
                
                // Créer et sauvegarder le tarif
                TypePlace typePlace = typePlaceRepository.findById(typePlaceId)
                    .orElseThrow(() -> new RuntimeException("Type de place non trouvé"));
                CategoriePersonne categorie = categoriePersonneRepository.findById(categorieId)
                    .orElseThrow(() -> new RuntimeException("Catégorie personne non trouvée"));
                
                TarifSeance tarif = new TarifSeance(seance, typePlace, categorie, prix);
                tarifSeanceRepository.save(tarif);
                
                System.out.println("✓ Tarif créé: TypePlace=" + typePlaceId + ", Categorie=" + categorieId + ", Prix=" + prix);
            } catch (NumberFormatException e) {
                System.out.println("✗ Erreur parsing tarif " + index + ": " + e.getMessage());
            }
            
            index++;
        }
        System.out.println("Traitement terminé après index " + (index - 1));
        System.out.println("================================");
    }
}
