package cinema.place;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import cinema.salle.Salle;
import java.util.List;
import java.util.ArrayList;
import java.net.URLEncoder;

@Controller
@RequestMapping("/places")
@RequiredArgsConstructor
public class PlaceController {

    private final PlaceService placeService;

    @GetMapping
    public String listerPlaces(
            @RequestParam(required = false) Long salle,
            @RequestParam(required = false) String recherche,
            Model model) {
        
        List<Place> places;
        
        if (salle != null) {
            // Filtrer par salle
            if (recherche != null && !recherche.trim().isEmpty()) {
                places = placeService.rechercherParCodePlace(salle, recherche);
            } else {
                places = placeService.obtenirPlacesParSalle(salle);
            }
            model.addAttribute("salleSelectionnee", placeService.obtenirSalleById(salle));
        } else {
            // Afficher toutes les places
            places = placeService.obtenirToutesLesPlaces();
        }
        
        model.addAttribute("places", places);
        model.addAttribute("salles", placeService.obtenirToutesLesSalles());
        model.addAttribute("page", "places/index");
        model.addAttribute("pageTitle", "Places");
        model.addAttribute("pageActive", "places");
        return "layout";
    }

    @GetMapping("/{id}")
    public String afficherDetail(@PathVariable Long id, Model model) {
        Place place = placeService.obtenirPlaceById(id);
        model.addAttribute("place", place);
        model.addAttribute("page", "places/detail");
        model.addAttribute("pageTitle", "Place " + place.getCodePlace());
        model.addAttribute("pageActive", "places");
        return "layout";
    }

    @GetMapping("/nouveau")
    public String formulaireCreation(
            @RequestParam(required = false) Long salle,
            Model model) {
        
        model.addAttribute("place", new Place());
        model.addAttribute("salles", placeService.obtenirToutesLesSalles());
        model.addAttribute("typesPlace", placeService.obtenirTousLesTypesPlace());
        
        if (salle != null) {
            model.addAttribute("salleSelectionnee", placeService.obtenirSalleById(salle));
        }
        
        model.addAttribute("page", "places/formulaire");
        model.addAttribute("pageTitle", "Ajouter une place");
        model.addAttribute("pageActive", "places");
        return "layout";
    }

    @PostMapping("/creerEnMasse")
    public String creerPlacesEnMasse(
            @RequestParam Long salleId,
            @RequestParam(value = "rangees[]", required = false) String[] rangees,
            @RequestParam(value = "numeroDebuts[]", required = false) Integer[] numeroDebuts,
            @RequestParam(value = "numeroFins[]", required = false) Integer[] numeroFins,
            @RequestParam(value = "typePlaceIds[]", required = false) Long[] typePlaceIds) {
        
        if (rangees == null || rangees.length == 0) {
            return "redirect:/places/nouveau?salle=" + salleId + "&error=aucune_rangee";
        }
        
        List<PlaceLigneCreation> lignes = new ArrayList<>();
        for (int i = 0; i < rangees.length; i++) {
            String rangee = rangees[i];
            if (rangee == null || rangee.trim().isEmpty()) {
                continue;
            }
            
            Integer numDebut = numeroDebuts != null && i < numeroDebuts.length ? numeroDebuts[i] : null;
            Integer numFin = numeroFins != null && i < numeroFins.length ? numeroFins[i] : null;
            Long typePlaceId = typePlaceIds != null && i < typePlaceIds.length && typePlaceIds[i] != null 
                ? typePlaceIds[i] : null;
            
            lignes.add(new PlaceLigneCreation(rangee, numDebut, numFin, typePlaceId));
        }
        
        try {
            placeService.creerPlacesEnMasse(salleId, lignes);
            return "redirect:/places?salle=" + salleId + "&success=places_creees";
        } catch (IllegalArgumentException e) {
            return "redirect:/places/nouveau?salle=" + salleId + "&error=" + encodeError(e.getMessage());
        }
    }

    @PostMapping
    public String creerPlace(
            Place place,
            @RequestParam(required = false) Long salleId,
            @RequestParam(required = false) Long typePlaceId) {
        
        if (salleId != null) {
            place.setSalle(placeService.obtenirSalleById(salleId));
        }
        if (typePlaceId != null) {
            place.setTypePlace(placeService.obtenirTypePlaceById(typePlaceId));
        }
        
        Place placeCree = placeService.creerPlace(place);
        return "redirect:/places/" + placeCree.getId();
    }

    @GetMapping("/{id}/modifier")
    public String formulaireModification(@PathVariable Long id, Model model) {
        Place place = placeService.obtenirPlaceById(id);
        model.addAttribute("place", place);
        model.addAttribute("salles", placeService.obtenirToutesLesSalles());
        model.addAttribute("typesPlace", placeService.obtenirTousLesTypesPlace());
        model.addAttribute("page", "places/formulaire");
        model.addAttribute("pageTitle", "Modifier: " + place.getCodePlace());
        model.addAttribute("pageActive", "places");
        return "layout";
    }

    @PostMapping("/{id}")
    public String modifierPlace(
            @PathVariable Long id,
            Place place,
            @RequestParam(required = false) Long salleId,
            @RequestParam(required = false) Long typePlaceId) {
        
        if (salleId != null) {
            place.setSalle(placeService.obtenirSalleById(salleId));
        }
        if (typePlaceId != null) {
            place.setTypePlace(placeService.obtenirTypePlaceById(typePlaceId));
        }
        
        placeService.modifierPlace(id, place);
        return "redirect:/places/" + id;
    }

    @GetMapping("/{id}/supprimer")
    public String confirmationSuppression(@PathVariable Long id, Model model) {
        Place place = placeService.obtenirPlaceById(id);
        model.addAttribute("place", place);
        model.addAttribute("page", "places/suppression");
        model.addAttribute("pageTitle", "Supprimer: " + place.getCodePlace());
        model.addAttribute("pageActive", "places");
        return "layout";
    }

    @PostMapping("/{id}/supprimer")
    public String supprimerPlace(@PathVariable Long id) {
        Place place = placeService.obtenirPlaceById(id);
        Long salleId = place.getSalle().getId();
        placeService.supprimerPlace(id);
        return "redirect:/places?salle=" + salleId;
    }

    private String encodeError(String message) {
        try {
            return URLEncoder.encode(message, "UTF-8");
        } catch (Exception e) {
            return "erreur";
        }
    }
}
