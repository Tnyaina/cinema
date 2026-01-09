package cinema.referentiel.typeplace;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class TypePlaceService {

    private final TypePlaceRepository typePlaceRepository;

    public TypePlace creerTypePlace(TypePlace typePlace) {
        if (typePlace.getLibelle() == null || typePlace.getLibelle().trim().isEmpty()) {
            throw new IllegalArgumentException("Le libellé du type de place ne peut pas être vide");
        }
        
        // Vérifier l'unicité du libellé
        if (typePlaceRepository.findByLibelleIgnoreCase(typePlace.getLibelle()).isPresent()) {
            throw new IllegalArgumentException("Un type de place avec ce libellé existe déjà");
        }
        
        return typePlaceRepository.save(typePlace);
    }

    public TypePlace modifierTypePlace(Long id, TypePlace typePlaceMaj) {
        TypePlace typePlace = obtenirTypePlaceById(id);
        
        if (typePlaceMaj.getLibelle() == null || typePlaceMaj.getLibelle().trim().isEmpty()) {
            throw new IllegalArgumentException("Le libellé du type de place ne peut pas être vide");
        }
        
        // Vérifier l'unicité du libellé (sauf pour le même type)
        typePlaceRepository.findByLibelleIgnoreCase(typePlaceMaj.getLibelle()).ifPresent(existing -> {
            if (!existing.getId().equals(id)) {
                throw new IllegalArgumentException("Un type de place avec ce libellé existe déjà");
            }
        });
        
        typePlace.setLibelle(typePlaceMaj.getLibelle());
        return typePlaceRepository.save(typePlace);
    }

    public void supprimerTypePlace(Long id) {
        typePlaceRepository.deleteById(id);
    }

    @Transactional(readOnly = true)
    public TypePlace obtenirTypePlaceById(Long id) {
        return typePlaceRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Type de place non trouvé avec l'ID: " + id));
    }

    @Transactional(readOnly = true)
    public List<TypePlace> obtenirTousLesTypesPlace() {
        return typePlaceRepository.findAll();
    }
}
