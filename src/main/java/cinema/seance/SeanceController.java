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
import cinema.tarif.TarifDefautRepository;
import cinema.ticket.TicketService;
import cinema.referentiel.typeplace.TypePlace;
import cinema.referentiel.typeplace.TypePlaceRepository;
import cinema.referentiel.categoriepersonne.CategoriePersonne;
import cinema.referentiel.categoriepersonne.CategoriePersonneRepository;
import cinema.film.Film;
import cinema.publicite.video.VideoPublicitaire;
import cinema.publicite.video.VideoPublicitaireRepository;
import cinema.publicite.type.TypeDiffusionPub;
import cinema.publicite.type.TypeDiffusionPubRepository;
import cinema.publicite.diffusion.DiffusionPublicitaire;
import cinema.publicite.diffusion.DiffusionPublicitaireRepository;
import cinema.publicite.tarif.TarifPubliciteDefautRepository;
import cinema.publicite.tarif.TarifPublicitePersonnaliseRepository;
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
    private final VideoPublicitaireRepository videoPublicitaireRepository;
    private final TypeDiffusionPubRepository typeDiffusionPubRepository;
    private final DiffusionPublicitaireRepository diffusionPublicitaireRepository;
    private final TarifPubliciteDefautRepository tarifPubliciteDefautRepository;
    private final TarifPublicitePersonnaliseRepository tarifPublicitePersonnaliseRepository;

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
        
        // Récupérer catégories de personne
        List<CategoriePersonne> categoriesPersonne = categoriePersonneRepository.findAll();
        
        // Récupérer les types de places PRÉSENTS dans la salle
        java.util.Set<Long> typePlaceIds = new java.util.HashSet<>();
        for (Place place : toutesLesPlaces) {
            if (place.getTypePlace() != null) {
                typePlaceIds.add(place.getTypePlace().getId());
            }
        }
        
        // Créer une structure pour les tarifs: typePlace -> categorie -> prix
        // Utilisée pour afficher la grille de tarifs
        Map<String, Map<String, Double>> tarifsCombines = new HashMap<>();
        
        for (Long typePlaceId : typePlaceIds) {
            TypePlace typePlace = typePlaceRepository.findById(typePlaceId).orElse(null);
            if (typePlace == null) continue;
            
            Map<String, Double> tarifsPourType = new HashMap<>();
            
            // Pour chaque catégorie de personne
            for (CategoriePersonne cat : categoriesPersonne) {
                Double prixFinal = null;
                
                // D'abord chercher en tarif_seance
                var tarifSeanceOptional = tarifSeanceRepository
                    .findBySeanceIdAndTypePlaceIdAndCategoriePersonneId(id, typePlace.getId(), cat.getId());
                
                if (tarifSeanceOptional.isPresent()) {
                    prixFinal = tarifSeanceOptional.get().getPrix();
                } else {
                    // Sinon chercher en tarif_defaut
                    var tarifDefautOptional = tarifDefautRepository
                        .findByTypePlaceIdAndCategoriePersonneId(typePlace.getId(), cat.getId());
                    
                    if (tarifDefautOptional.isPresent()) {
                        prixFinal = tarifDefautOptional.get().getPrix();
                    } else {
                        // Fallback: 12.0Ar
                        prixFinal = 12.0;
                    }
                }
                
                tarifsPourType.put(cat.getLibelle(), prixFinal);
            }
            
            tarifsCombines.put(typePlace.getLibelle(), tarifsPourType);
        }
        
        Map<String, List<Place>> placesParType = new HashMap<>();
        for (Place place : toutesLesPlaces) {
            String typeLabel = place.getTypePlace() != null ? place.getTypePlace().getLibelle() : "Standard";
            placesParType.computeIfAbsent(typeLabel, k -> new ArrayList<>()).add(place);
        }
        
        Integer placesDispoCount = placeService.obtenirNombrePlacesDisponibles(id, salleId);
        Integer placesReserveeCount = toutesLesPlaces.size() - placesDispoCount;
        Double tauxOccupation = placeService.obtenirTauxOccupation(id, salleId);
        Double chiffresAffaires = ticketService.calculerChiffresAffairesSeance(id);
        Double revenuMaximum = seanceService.calculerRevenuMaximumSeance(id);
        
        // Récupérer les publicités diffusées pour cette séance
        List<DiffusionPublicitaire> diffusions = diffusionPublicitaireRepository.findBySeanceId(id);
        
        // Regrouper les diffusions par (société, vidéo)
        Map<String, Map<String, Object>> diffusionsGroupees = new HashMap<>();
        for (DiffusionPublicitaire diffusion : diffusions) {
            String societeNom = diffusion.getVideoPublicitaire().getSociete().getLibelle();
            String videoNom = diffusion.getVideoPublicitaire().getLibelle();
            String cle = societeNom + "|||" + videoNom;
            
            if (!diffusionsGroupees.containsKey(cle)) {
                Map<String, Object> group = new HashMap<>();
                group.put("societe", societeNom);
                group.put("video", videoNom);
                group.put("nombre", 0);
                group.put("tarifUnitaire", diffusion.getTarifApplique());
                group.put("tarifTotal", 0.0);
                diffusionsGroupees.put(cle, group);
            }
            
            Map<String, Object> group = diffusionsGroupees.get(cle);
            int nombre = (int) group.get("nombre") + 1;
            double tarifTotal = (double) group.get("tarifTotal") + diffusion.getTarifApplique();
            group.put("nombre", nombre);
            group.put("tarifTotal", tarifTotal);
        }
        
        Double pubCATotal = diffusionsGroupees.values().stream()
            .mapToDouble(g -> (double) g.get("tarifTotal"))
            .sum();
        Double caTotal = chiffresAffaires + pubCATotal;
        
        model.addAttribute("seance", seance);
        model.addAttribute("placesParRangee", placesParRangee);
        model.addAttribute("placesParType", placesParType);
        model.addAttribute("placesReservees", placesReservees);
        model.addAttribute("placesDisponibles", placesDisponibles);
        model.addAttribute("placesDispoCount", placesDispoCount);
        model.addAttribute("placesReserveeCount", placesReserveeCount);
        model.addAttribute("categoriesPersonne", categoriesPersonne);
        model.addAttribute("tarifsCombines", tarifsCombines);
        model.addAttribute("tauxOccupation", String.format("%.0f", tauxOccupation));
        model.addAttribute("totalPlaces", toutesLesPlaces.size());
        model.addAttribute("chiffresAffaires", chiffresAffaires);
        model.addAttribute("revenuMaximum", revenuMaximum);
        model.addAttribute("diffusions", diffusions);
        model.addAttribute("diffusionsGroupees", diffusionsGroupees.values());
        model.addAttribute("pubCATotal", pubCATotal);
        model.addAttribute("caTotal", caTotal);
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
        model.addAttribute("videos", videoPublicitaireRepository.findAll());
        model.addAttribute("typesDiffusion", typeDiffusionPubRepository.findAll());
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
            sauvegarderPublicites(seanceCree.getId(), params);
            
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
        model.addAttribute("videos", videoPublicitaireRepository.findAll());
        model.addAttribute("typesDiffusion", typeDiffusionPubRepository.findAll());
        model.addAttribute("diffusions", diffusionPublicitaireRepository.findBySeanceId(id));
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
            diffusionPublicitaireRepository.deleteBySeanceId(id);
            sauvegarderPublicites(id, params);
            
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

    @PostMapping("/{id}/terminer")
    public String terminerSeance(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            seanceService.terminerSeance(id);
            redirectAttributes.addFlashAttribute("success", "La seance a ete marquee comme terminee");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors de la fermeture de la seance: " + e.getMessage());
        }
        return "redirect:/seances/" + id;
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

    @Transactional
    private void sauvegarderPublicites(Long seanceId, Map<String, String> params) {
        Seance seance = seanceService.obtenirSeanceById(seanceId);
        
        int index = 0;
        int emptyCount = 0;
        int maxEmptyConsecutive = 3;
        
        while (index <= 100 && emptyCount < maxEmptyConsecutive) {
            String videoIdStr = params.get("pub_video_" + index);
            String typeIdStr = params.get("pub_type_" + index);
            String nombreStr = params.get("pub_nombre_" + index);
            
            if (videoIdStr == null || videoIdStr.isEmpty() || 
                typeIdStr == null || typeIdStr.isEmpty() || 
                nombreStr == null || nombreStr.isEmpty()) {
                emptyCount++;
                index++;
                continue;
            }
            
            emptyCount = 0;
            
            try {
                Long videoId = Long.parseLong(videoIdStr);
                Long typeId = Long.parseLong(typeIdStr);
                Integer nombre = Integer.parseInt(nombreStr);
                
                VideoPublicitaire video = videoPublicitaireRepository.findById(videoId)
                    .orElseThrow(() -> new RuntimeException("Vidéo publicitaire non trouvée"));
                TypeDiffusionPub type = typeDiffusionPubRepository.findById(typeId)
                    .orElseThrow(() -> new RuntimeException("Type diffusion non trouvé"));
                
                // Créer 'nombre' diffusions
                for (int i = 0; i < nombre; i++) {
                    Double tarifApplique = calculerTarifPublicite(video, type);
                    DiffusionPublicitaire diffusion = new DiffusionPublicitaire(
                        video,
                        seanceId,
                        type,
                        tarifApplique,
                        seance.getDebut()
                    );
                    diffusionPublicitaireRepository.save(diffusion);
                }
                
            } catch (NumberFormatException e) {
                System.out.println("Erreur parsing publicité " + index + ": " + e.getMessage());
            }
            
            index++;
        }
    }

    private Double calculerTarifPublicite(VideoPublicitaire video, TypeDiffusionPub type) {
        // Chercher un tarif personnalisé pour cette société et ce type
        var tarifPersonnalise = tarifPublicitePersonnaliseRepository
            .findLatestTarifBySocieteAndType(video.getSociete().getId(), type.getId(), java.time.LocalDate.now());
        
        if (tarifPersonnalise.isPresent()) {
            return tarifPersonnalise.get().getPrixUnitaire();
        }
        
        // Sinon, chercher un tarif défaut pour ce type
        var tarifDefaut = tarifPubliciteDefautRepository
            .findLatestTarifByTypeDiffusion(type.getId(), java.time.LocalDate.now());
        
        if (tarifDefaut.isPresent()) {
            return tarifDefaut.get().getPrixUnitaire();
        }
        
        // Sinon, retourner 0
        return 0.0;
    }
}