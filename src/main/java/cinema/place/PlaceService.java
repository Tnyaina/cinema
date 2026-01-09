package cinema.place;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import cinema.salle.Salle;
import cinema.salle.SalleRepository;
import cinema.referentiel.typeplace.TypePlace;
import cinema.referentiel.typeplace.TypePlaceRepository;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.LinkedHashMap;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional
public class PlaceService {

    private final PlaceRepository placeRepository;
    private final SalleRepository salleRepository;
    private final TypePlaceRepository typePlaceRepository;

    public Place creerPlace(Place place) {
        if (!place.estValide()) {
            throw new IllegalArgumentException("La place n'est pas valide");
        }
        verifierCapaciteSalle(place.getSalle());
        place.genererCodePlace();
        return placeRepository.save(place);
    }

    public List<Place> creerPlacesEnMasse(Long salleId, List<PlaceLigneCreation> lignes) {
        Salle salle = obtenirSalleById(salleId);
        List<Place> placesCreees = new ArrayList<>();
        
        // Valider et compter le nombre total de places à créer
        int totalPlaces = 0;
        for (PlaceLigneCreation ligne : lignes) {
            if (!ligne.estValide()) {
                throw new IllegalArgumentException(
                    "La ligne rangée '" + ligne.getRangee() + "' n'est pas valide"
                );
            }
            totalPlaces += ligne.getNombrePlaces();
        }
        
        // Vérifier que la salle peut accueillir toutes les places
        long placesExistantes = placeRepository.countBySalleId(salleId);
        if (placesExistantes + totalPlaces > salle.getCapacite()) {
            throw new IllegalArgumentException(
                "Impossible de créer " + totalPlaces + " places. "
                + "La salle '" + salle.getNom() + "' a seulement " + salle.getCapacite() + " places "
                + "et " + placesExistantes + " sont déjà utilisées. "
                + "Capacité restante: " + (salle.getCapacite() - placesExistantes) + " places."
            );
        }
        
        // Créer les places
        for (PlaceLigneCreation ligne : lignes) {
            TypePlace typePlace = null;
            if (ligne.getTypePlaceId() != null) {
                typePlace = obtenirTypePlaceById(ligne.getTypePlaceId());
            }
            
            for (int numero = ligne.getNumeroDebut(); numero <= ligne.getNumeroFin(); numero++) {
                Place place = new Place(salle, ligne.getRangee(), numero, typePlace);
                place.genererCodePlace();
                Place saved = placeRepository.save(place);
                placesCreees.add(saved);
            }
        }
        
        return placesCreees;
    }

    public Place modifierPlace(Long id, Place placeMaj) {
        Place place = obtenirPlaceById(id);
        if (!placeMaj.estValide()) {
            throw new IllegalArgumentException("La place n'est pas valide");
        }
        // Si la salle a changé, vérifier la nouvelle capacité
        if (!place.getSalle().getId().equals(placeMaj.getSalle().getId())) {
            verifierCapaciteSalle(placeMaj.getSalle());
        }
        place.setSalle(placeMaj.getSalle());
        place.setRangee(placeMaj.getRangee());
        place.setNumero(placeMaj.getNumero());
        place.setCodePlace(placeMaj.getCodePlace());
        place.setTypePlace(placeMaj.getTypePlace());
        place.genererCodePlace();
        return placeRepository.save(place);
    }

    public void supprimerPlace(Long id) {
        placeRepository.deleteById(id);
    }

    @Transactional(readOnly = true)
    public Place obtenirPlaceById(Long id) {
        return placeRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Place non trouvée avec l'ID: " + id));
    }

    @Transactional(readOnly = true)
    public List<Place> obtenirPlacesParSalle(Long salleId) {
        return placeRepository.findBySalleId(salleId);
    }

    @Transactional(readOnly = true)
    public Map<String, List<Place>> obtenirPlacesGroupeesParRangee(Long salleId) {
        List<Place> places = obtenirPlacesParSalle(salleId);
        return places.stream()
            .collect(Collectors.groupingBy(
                Place::getRangee,
                LinkedHashMap::new,
                Collectors.toList()
            ));
    }

    @Transactional(readOnly = true)
    public List<Place> rechercherParCodePlace(Long salleId, String codePlace) {
        return placeRepository.findByCodePlaceContaining(salleId, codePlace);
    }

    @Transactional(readOnly = true)
    public List<Place> obtenirToutesLesPlaces() {
        return placeRepository.findAll();
    }

    @Transactional(readOnly = true)
    public Salle obtenirSalleById(Long salleId) {
        return salleRepository.findById(salleId)
            .orElseThrow(() -> new RuntimeException("Salle non trouvée avec l'ID: " + salleId));
    }

    @Transactional(readOnly = true)
    public List<Salle> obtenirToutesLesSalles() {
        return salleRepository.findAll();
    }

    @Transactional(readOnly = true)
    public List<TypePlace> obtenirTousLesTypesPlace() {
        return typePlaceRepository.findAll();
    }

    @Transactional(readOnly = true)
    public TypePlace obtenirTypePlaceById(Long typePlaceId) {
        return typePlaceRepository.findById(typePlaceId)
            .orElseThrow(() -> new RuntimeException("Type de place non trouvé avec l'ID: " + typePlaceId));
    }

    @Transactional(readOnly = true)
    public long compterPlacesDeSalle(Long salleId) {
        return placeRepository.countBySalleId(salleId);
    }

    @Transactional(readOnly = true)
    public void verifierCapaciteSalle(Salle salle) {
        long nombrePlaces = placeRepository.countBySalleId(salle.getId());
        if (nombrePlaces >= salle.getCapacite()) {
            throw new IllegalArgumentException(
                "La salle '" + salle.getNom() + "' a atteint sa capacité maximale (" 
                + salle.getCapacite() + " places). Impossible d'ajouter plus de places."
            );
        }
    }

    public boolean estValide(Place place) {
        return place != null && place.estValide();
    }
}
