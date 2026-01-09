package cinema.seance;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import cinema.place.Place;
import cinema.place.PlaceService;
import cinema.tarif.TarifSeance;
import cinema.tarif.TarifSeanceRepository;
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

    @GetMapping
    public String listerSeances(
            @RequestParam(required = false) Long film,
            @RequestParam(required = false) Long salle,
            Model model) {
        
        List<Seance> seances;
        
        if (film != null) {
            seances = seanceService.obtenirSeancesParFilm(film);
        } else if (salle != null) {
            seances = seanceService.obtenirSeancesParSalle(salle);
        } else {
            seances = seanceService.obtenirToutesLesSeances();
        }
        
        model.addAttribute("seances", seances);
        model.addAttribute("films", seanceService.obtenirTousLesFilms());
        model.addAttribute("salles", seanceService.obtenirToutesLesSalles());
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
            @RequestParam(required = false) Long versionLangueId) {
        
        if (filmId != null) {
            seance.setFilm(seanceService.obtenirFilmById(filmId));
        }
        if (salleId != null) {
            seance.setSalle(seanceService.obtenirSalleById(salleId));
        }
        if (versionLangueId != null) {
            seance.setVersionLangue(seanceService.obtenirVersionLangueById(versionLangueId));
        }
        
        Seance seanceCree = seanceService.creerSeance(seance);
        return "redirect:/seances/" + seanceCree.getId();
    }

    @GetMapping("/{id}/modifier")
    public String formulaireModification(@PathVariable Long id, Model model) {
        Seance seance = seanceService.obtenirSeanceById(id);
        model.addAttribute("seance", seance);
        model.addAttribute("films", seanceService.obtenirTousLesFilms());
        model.addAttribute("salles", seanceService.obtenirToutesLesSalles());
        model.addAttribute("versionLangues", seanceService.obtenirToutesLesVersionsLangue());
        model.addAttribute("seancesExistantes", seanceService.obtenirToutesLesSeances());
        model.addAttribute("page", "seances/formulaire");
        model.addAttribute("pageTitle", "Modifier: " + seance.getFilm().getTitre());
        model.addAttribute("pageActive", "seances");
        return "layout";
    }

    @PostMapping("/{id}")
    public String modifierSeance(
            @PathVariable Long id,
            Seance seance,
            @RequestParam(required = false) Long filmId,
            @RequestParam(required = false) Long salleId,
            @RequestParam(required = false) Long versionLangueId) {
        
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
}
