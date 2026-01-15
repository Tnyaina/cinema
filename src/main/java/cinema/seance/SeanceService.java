package cinema.seance;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import cinema.film.Film;
import cinema.film.FilmRepository;
import cinema.salle.Salle;
import cinema.salle.SalleRepository;
import cinema.referentiel.versionlangue.VersionLangue;
import cinema.referentiel.versionlangue.VersionLangueRepository;
import cinema.ticket.TicketRepository;
import cinema.place.PlaceRepository;
import cinema.tarif.TarifSeanceRepository;
import cinema.tarif.TarifDefautRepository;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional
public class SeanceService {

    private final SeanceRepository seanceRepository;
    private final FilmRepository filmRepository;
    private final SalleRepository salleRepository;
    private final VersionLangueRepository versionLangueRepository;
    private final TicketRepository ticketRepository;
    private final PlaceRepository placeRepository;
    private final TarifSeanceRepository tarifSeanceRepository;
    private final TarifDefautRepository tarifDefautRepository;

    public Seance creerSeance(Seance seance) {
        if (!seance.estValide()) {
            throw new IllegalArgumentException("La séance n'est pas valide");
        }
        return seanceRepository.save(seance);
    }

    public Seance modifierSeance(Long id, Seance seanceMaj) {
        Seance seance = obtenirSeanceById(id);
        if (!seanceMaj.estValide()) {
            throw new IllegalArgumentException("La séance n'est pas valide");
        }
        seance.setFilm(seanceMaj.getFilm());
        seance.setSalle(seanceMaj.getSalle());
        seance.setDebut(seanceMaj.getDebut());
        seance.setFin(seanceMaj.getFin());
        seance.setVersionLangue(seanceMaj.getVersionLangue());
        return seanceRepository.save(seance);
    }

    public void supprimerSeance(Long id) {
        seanceRepository.deleteById(id);
    }

    /**
     * Marquer une séance comme terminée
     */
    public Seance terminerSeance(Long id) {
        Seance seance = obtenirSeanceById(id);
        seance.setStatut("Terminee");
        return seanceRepository.save(seance);
    }

    @Transactional(readOnly = true)
    public Seance obtenirSeanceById(Long id) {
        return seanceRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Séance non trouvée avec l'ID: " + id));
    }

    @Transactional(readOnly = true)
    public List<Seance> obtenirSeancesParFilm(Long filmId) {
        return seanceRepository.findByFilmId(filmId);
    }

    @Transactional(readOnly = true)
    public List<Seance> obtenirSeancesParSalle(Long salleId) {
        return seanceRepository.findBySalleId(salleId);
    }

    @Transactional(readOnly = true)
    public List<Seance> obtenirToutesLesSeances() {
        return seanceRepository.findAll();
    }

    // 🆕 MÉTHODE POUR LE FLUX ACHAT CLIENT
    /**
     * Obtenir toutes les séances disponibles (futures) pour un film
     * Utile pour l'affichage client
     */
    @Transactional(readOnly = true)
    public List<Seance> obtenirSeancesDisponiblesParFilm(Long filmId) {
        List<Seance> seances = seanceRepository.findByFilmId(filmId);
        // Filtrer seulement les séances futures et enrichir avec places dispo
        return seances.stream()
            .filter(seance -> seance.estDisponible())
            .peek(seance -> {
                // Calculer et passer le nombre de places disponibles à la séance
                Integer placesDisponibles = obtenirNombrePlacesDisponibles(seance.getId());
                seance.setPlacesDisponiblesCalculees(placesDisponibles);
            })
            .collect(Collectors.toList());
    }

    /**
     * Obtenir toutes les séances disponibles (futures)
     */
    @Transactional(readOnly = true)
    public List<Seance> obtenirSeancesDisponibles() {
        List<Seance> seances = seanceRepository.findAll();
        return seances.stream()
            .filter(seance -> seance.estDisponible())
            .collect(Collectors.toList());
    }

    /**
     * Obtenir les places disponibles pour une séance
     */
    @Transactional(readOnly = true)
    public Integer obtenirNombrePlacesDisponibles(Long seanceId) {
        Seance seance = obtenirSeanceById(seanceId);
        Salle salle = seance.getSalle();
        long placesVendues = ticketRepository.countPlacesVenduesBySeance(seanceId);
        return (int) (salle.getCapacite() - placesVendues);
    }

    /**
     * Vérifier si une place est disponible pour une séance
     */
    @Transactional(readOnly = true)
    public boolean isPlaceDisponible(Long seanceId, Long placeId) {
        return !ticketRepository.isPlaceReservee(seanceId, placeId);
    }

    @Transactional(readOnly = true)
    public List<Film> obtenirTousLesFilms() {
        return filmRepository.findAll();
    }

    @Transactional(readOnly = true)
    public Film obtenirFilmById(Long filmId) {
        return filmRepository.findById(filmId)
            .orElseThrow(() -> new RuntimeException("Film non trouvé avec l'ID: " + filmId));
    }

    @Transactional(readOnly = true)
    public List<Salle> obtenirToutesLesSalles() {
        return salleRepository.findAll();
    }

    @Transactional(readOnly = true)
    public Salle obtenirSalleById(Long salleId) {
        return salleRepository.findById(salleId)
            .orElseThrow(() -> new RuntimeException("Salle non trouvée avec l'ID: " + salleId));
    }

    @Transactional(readOnly = true)
    public List<VersionLangue> obtenirToutesLesVersionsLangue() {
        return versionLangueRepository.findAll();
    }

    @Transactional(readOnly = true)
    public VersionLangue obtenirVersionLangueById(Long versionLangueId) {
        return versionLangueRepository.findById(versionLangueId)
            .orElseThrow(() -> new RuntimeException("Version langue non trouvée avec l'ID: " + versionLangueId));
    }

    /**
     * Filtrer les séances par date
     */
    @Transactional(readOnly = true)
    public List<Seance> filtrerSeancesParDate(List<Seance> seances, String dateStr) {
        try {
            LocalDate dateFiltre = LocalDate.parse(dateStr);
            return seances.stream()
                .filter(seance -> {
                    LocalDate seanceDate = seance.getDebut().toLocalDate();
                    return seanceDate.equals(dateFiltre);
                })
                .collect(Collectors.toList());
        } catch (Exception e) {
            // Si le parsing échoue, retourner toutes les séances
            return seances;
        }
    }

    /**
     * Calculer la valeur maximale qu'une salle peut générer pour une séance
     * 
     * Logique:
     * - Pour chaque type de place dans la salle, compter le nombre de places
     * - Pour chaque type, trouver le tarif maximal (la catégorie de personne la plus chère)
     * - Chercher d'abord dans tarif_seance, sinon utiliser tarif_defaut
     * - Multiplier nombre de places * tarif maximal pour chaque type
     * - Additionner tous les types
     */
    @Transactional(readOnly = true)
    public Double calculerRevenuMaximumSeance(Long seanceId) {
        Seance seance = seanceRepository.findById(seanceId)
            .orElseThrow(() -> new RuntimeException("Séance non trouvée"));
        
        Long salleId = seance.getSalle().getId();
        List<cinema.place.Place> toutesLesPlaces = placeRepository.findBySalleId(salleId);
        
        // Grouper les places par type
        Map<Long, Long> placesParType = new HashMap<>();
        for (cinema.place.Place place : toutesLesPlaces) {
            Long typeId = place.getTypePlace() != null ? place.getTypePlace().getId() : null;
            if (typeId != null) {
                placesParType.put(typeId, placesParType.getOrDefault(typeId, 0L) + 1);
            }
        }
        
        Double revenuTotal = 0.0;
        
        // Pour chaque type de place
        for (Map.Entry<Long, Long> entry : placesParType.entrySet()) {
            Long typePlaceId = entry.getKey();
            Long nombrePlaces = entry.getValue();
            
            // Trouver le tarif maximal pour ce type (tous catégories confondues)
            Double prixMax = 0.0;
            
            // D'abord chercher dans tarif_seance - récupérer TOUS les tarifs de ce type
            List<cinema.tarif.TarifSeance> tarifs = tarifSeanceRepository
                .findBySeanceIdAndCategoriePersonneId(seanceId, null); // Tous les tarifs de la séance
            
            // Filtrer pour ce type de place
            List<cinema.tarif.TarifSeance> tarifsDuType = tarifs.stream()
                .filter(t -> t.getTypePlace().getId().equals(typePlaceId))
                .collect(Collectors.toList());
            
            if (!tarifsDuType.isEmpty()) {
                prixMax = tarifsDuType.stream()
                    .mapToDouble(cinema.tarif.TarifSeance::getPrix)
                    .max()
                    .orElse(0.0);
            } else {
                // Sinon chercher dans tarif_defaut
                List<cinema.tarif.TarifDefaut> tarifDefauts = tarifDefautRepository
                    .findByTypePlaceId(typePlaceId);
                if (!tarifDefauts.isEmpty()) {
                    prixMax = tarifDefauts.stream()
                        .mapToDouble(cinema.tarif.TarifDefaut::getPrix)
                        .max()
                        .orElse(12.0);
                } else {
                    prixMax = 12.0; // Fallback
                }
            }
            
            revenuTotal += nombrePlaces * prixMax;
        }
        
        return revenuTotal;
    }
}
