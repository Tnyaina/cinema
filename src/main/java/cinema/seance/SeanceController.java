package cinema.seance;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import cinema.place.Place;
import cinema.place.PlaceService;
import cinema.tarif.TarifSeance;
import cinema.tarif.TarifSeanceRepository;
import cinema.tarif.TarifDefaut;
import cinema.tarif.TarifDefautRepository;
import cinema.ticket.TicketService;
import cinema.referentiel.typeplace.TypePlace;
import cinema.referentiel.typeplace.TypePlaceRepository;
import cinema.referentiel.categoriepersonne.CategoriePersonne;
import cinema.referentiel.categoriepersonne.CategoriePersonneRepository;
import cinema.film.Film;
import java.time.LocalTime;
import java.time.LocalDateTime;
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
    private final TarifDefautRepository tarifDefautRepository;
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
        
        Long salleId = seance.getSalle().getId();
        List<Place> toutesLesPlaces = placeService.obtenirPlacesParSalle(salleId);
        List<Place> placesDisponibles = placeService.obtenirPlacesDisponiblesBySeance(id, salleId);
        List<Place> placesReservees = placeService.obtenirPlacesReserveesBySeance(id, salleId);
        Map<String, List<Place>> placesParRangee = placeService.obtenirPlacesGroupeesParRangee(salleId);
        
        Map<Long, Double> prixParTypePlace = new HashMap<>();
        
        // Récupérer les types de places PRÉSENTS dans la salle
        java.util.Set<Long> typePlaceIds = new java.util.HashSet<>();
        for (Place place : toutesLesPlaces) {
            if (place.getTypePlace() != null) {
                typePlaceIds.add(place.getTypePlace().getId());
            }
        }
        
        // Créer une liste de tarifs à afficher (mélange tarifs seance + tarifs défaut)
        List<Map<String, Object>> tarifsPourAffichage = new ArrayList<>();
        
        for (Long typePlaceId : typePlaceIds) {
            TypePlace typePlace = typePlaceRepository.findById(typePlaceId).orElse(null);
            if (typePlace == null) continue;
            
            // D'abord chercher un tarif de séance
            var tarifSeanceOptional = tarifSeanceRepository.findBySeanceIdAndTypePlaceId(id, typePlace.getId());
            
            if (tarifSeanceOptional.isPresent()) {
                // Si un tarif de séance existe, l'utiliser
                TarifSeance tarif = tarifSeanceOptional.get();
                prixParTypePlace.put(typePlace.getId(), tarif.getPrix());
                
                // Ajouter à la liste d'affichage
                Map<String, Object> tarifMap = new HashMap<>();
                tarifMap.put("typePlace", tarif.getTypePlace());
                tarifMap.put("prix", tarif.getPrix());
                tarifsPourAffichage.add(tarifMap);
            } else {
                // Sinon, chercher un tarif défaut par type de place
                // D'abord, essayer avec la catégorie personne id=1 (catégorie par défaut)
                var tarifDefautOptional = tarifDefautRepository.findByTypePlaceIdAndCategoriePersonneId(
                    typePlace.getId(),
                    1L // Catégorie personne par défaut (id=1)
                );
                
                if (tarifDefautOptional.isPresent()) {
                    TarifDefaut tarifDéfaut = tarifDefautOptional.get();
                    prixParTypePlace.put(typePlace.getId(), tarifDéfaut.getPrix());
                    
                    // Ajouter à la liste d'affichage
                    Map<String, Object> tarifMap = new HashMap<>();
                    tarifMap.put("typePlace", tarifDéfaut.getTypePlace());
                    tarifMap.put("prix", tarifDéfaut.getPrix());
                    tarifsPourAffichage.add(tarifMap);
                } else {
                    // Si pas de tarif défaut avec catégorie 1, chercher le premier disponible
                    List<TarifDefaut> tarifsDéfaut = tarifDefautRepository.findByTypePlaceId(typePlace.getId());
                    if (!tarifsDéfaut.isEmpty()) {
                        TarifDefaut tarifDéfaut = tarifsDéfaut.get(0);
                        prixParTypePlace.put(typePlace.getId(), tarifDéfaut.getPrix());
                        
                        // Ajouter à la liste d'affichage
                        Map<String, Object> tarifMap = new HashMap<>();
                        tarifMap.put("typePlace", tarifDéfaut.getTypePlace());
                        tarifMap.put("prix", tarifDéfaut.getPrix());
                        tarifsPourAffichage.add(tarifMap);
                    }
                }
            }
        }
        
        // Trier les tarifs par nom du type de place pour un affichage cohérent
        tarifsPourAffichage.sort((t1, t2) -> {
            String lib1 = ((TypePlace) t1.get("typePlace")).getLibelle();
            String lib2 = ((TypePlace) t2.get("typePlace")).getLibelle();
            return lib1.compareTo(lib2);
        });
        
        Map<String, List<Place>> placesParType = new HashMap<>();
        for (Place place : toutesLesPlaces) {
            String typeLabel = place.getTypePlace() != null ? place.getTypePlace().getLibelle() : "Standard";
            placesParType.computeIfAbsent(typeLabel, k -> new ArrayList<>()).add(place);
        }
        
        Integer placesDispoCount = placeService.obtenirNombrePlacesDisponibles(id, salleId);
        Integer placesReserveeCount = toutesLesPlaces.size() - placesDispoCount;
        Double tauxOccupation = placeService.obtenirTauxOccupation(id, salleId);
        Double chiffresAffaires = ticketService.calculerChiffresAffairesSeance(id);
        
        model.addAttribute("seance", seance);
        model.addAttribute("placesParRangee", placesParRangee);
        model.addAttribute("placesParType", placesParType);
        model.addAttribute("prixParTypePlace", prixParTypePlace);
        model.addAttribute("placesReservees", placesReservees);
        model.addAttribute("placesDisponibles", placesDisponibles);
        model.addAttribute("placesDispoCount", placesDispoCount);
        model.addAttribute("placesReserveeCount", placesReserveeCount);
        model.addAttribute("tarifs", tarifsPourAffichage);
        model.addAttribute("tauxOccupation", String.format("%.0f", tauxOccupation));
        model.addAttribute("totalPlaces", toutesLesPlaces.size());
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
            @RequestParam(required = false) Long filmId,
            @RequestParam(required = false) Long salleId,
            @RequestParam(required = false) Long versionLangueId,
            @RequestParam String debut,
            @RequestParam String fin,
            @RequestParam Map<String, String> params,
            RedirectAttributes redirectAttributes) {
        
        try {
            // Créer la séance
            Seance seance = new Seance();
            
            if (filmId != null) {
                Film film = seanceService.obtenirFilmById(filmId);
                seance.setFilm(film);
            }
            if (salleId != null) {
                seance.setSalle(seanceService.obtenirSalleById(salleId));
            }
            if (versionLangueId != null) {
                seance.setVersionLangue(seanceService.obtenirVersionLangueById(versionLangueId));
            }
            
            // Parser debut et fin
            seance.setDebut(LocalDateTime.parse(debut));
            seance.setFin(LocalTime.parse(fin));
            
            // Valider les chevauchements
            if (verifierChevauchement(seance, null)) {
                redirectAttributes.addFlashAttribute("error", 
                    "⚠️ Conflit détecté : La salle est déjà occupée pendant ce créneau horaire");
                redirectAttributes.addFlashAttribute("seanceData", seance);
                return "redirect:/seances/nouveau";
            }
            
            Seance seanceCree = seanceService.creerSeance(seance);
            sauvegarderTarifs(seanceCree.getId(), params);
            
            redirectAttributes.addFlashAttribute("success", 
                "✅ Séance créée avec succès");
            return "redirect:/seances/" + seanceCree.getId();
            
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", 
                "❌ Erreur lors de la création : " + e.getMessage());
            return "redirect:/seances/nouveau";
        }
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
            @RequestParam(required = false) Long filmId,
            @RequestParam(required = false) Long salleId,
            @RequestParam(required = false) Long versionLangueId,
            @RequestParam String debut,
            @RequestParam String fin,
            @RequestParam Map<String, String> params,
            RedirectAttributes redirectAttributes) {
        
        try {
            Seance seance = new Seance();
            
            if (filmId != null) {
                seance.setFilm(seanceService.obtenirFilmById(filmId));
            }
            if (salleId != null) {
                seance.setSalle(seanceService.obtenirSalleById(salleId));
            }
            if (versionLangueId != null) {
                seance.setVersionLangue(seanceService.obtenirVersionLangueById(versionLangueId));
            }
            
            seance.setDebut(LocalDateTime.parse(debut));
            seance.setFin(LocalTime.parse(fin));
            
            // Valider les chevauchements (exclure la séance actuelle)
            if (verifierChevauchement(seance, id)) {
                redirectAttributes.addFlashAttribute("error", 
                    "⚠️ Conflit détecté : La salle est déjà occupée pendant ce créneau horaire");
                return "redirect:/seances/" + id + "/modifier";
            }
            
            seanceService.modifierSeance(id, seance);
            tarifSeanceRepository.deleteBySeanceId(id);
            sauvegarderTarifs(id, params);
            
            redirectAttributes.addFlashAttribute("success", 
                "✅ Séance modifiée avec succès");
            return "redirect:/seances/" + id;
            
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", 
                "❌ Erreur lors de la modification : " + e.getMessage());
            return "redirect:/seances/" + id + "/modifier";
        }
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

    // Validation des chevauchements côté serveur
    private boolean verifierChevauchement(Seance nouvelleSeance, Long seanceIdExclue) {
        List<Seance> seancesExistantes = seanceService.obtenirSeancesParSalle(
            nouvelleSeance.getSalle().getId()
        );
        
        LocalDateTime debut = nouvelleSeance.getDebut();
        LocalDateTime fin = debut.toLocalDate().atTime(nouvelleSeance.getFin());
        
        for (Seance existante : seancesExistantes) {
            // Exclure la séance en cours de modification
            if (seanceIdExclue != null && existante.getId().equals(seanceIdExclue)) {
                continue;
            }
            
            LocalDateTime existanteDebut = existante.getDebut();
            LocalDateTime existanteFin = existanteDebut.toLocalDate().atTime(existante.getFin());
            
            // Vérifier chevauchement : fin > existanteDebut ET debut < existanteFin
            if (fin.isAfter(existanteDebut) && debut.isBefore(existanteFin)) {
                return true;
            }
        }
        
        return false;
    }

    @Transactional
    private void sauvegarderTarifs(Long seanceId, Map<String, String> params) {
        Seance seance = seanceService.obtenirSeanceById(seanceId);
        
        int index = 0;
        int emptyCount = 0;
        int maxEmptyConsecutive = 3;
        
        while (index <= 100 && emptyCount < maxEmptyConsecutive) {
            String typePlaceIdStr = params.get("tarif_typePlace_" + index);
            String categorieIdStr = params.get("tarif_categorie_" + index);
            String prixStr = params.get("tarif_prix_" + index);
            
            if (typePlaceIdStr == null || typePlaceIdStr.isEmpty() || 
                categorieIdStr == null || categorieIdStr.isEmpty() || 
                prixStr == null || prixStr.isEmpty()) {
                emptyCount++;
                index++;
                continue;
            }
            
            emptyCount = 0;
            
            try {
                Long typePlaceId = Long.parseLong(typePlaceIdStr);
                Long categorieId = Long.parseLong(categorieIdStr);
                Double prix = Double.parseDouble(prixStr);
                
                TypePlace typePlace = typePlaceRepository.findById(typePlaceId)
                    .orElseThrow(() -> new RuntimeException("Type de place non trouvé"));
                CategoriePersonne categorie = categoriePersonneRepository.findById(categorieId)
                    .orElseThrow(() -> new RuntimeException("Catégorie personne non trouvée"));
                
                TarifSeance tarif = new TarifSeance(seance, typePlace, categorie, prix);
                tarifSeanceRepository.save(tarif);
                
            } catch (NumberFormatException e) {
                System.out.println("Erreur parsing tarif " + index + ": " + e.getMessage());
            }
            
            index++;
        }
    }
}