package cinema.referentiel.genre;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class GenreService {

    private final GenreRepository genreRepository;

    public Genre creerGenre(Genre genre) {
        if (genre.getLibelle() == null || genre.getLibelle().trim().isEmpty()) {
            throw new IllegalArgumentException("Le libellé du genre ne peut pas être vide");
        }
        
        // Vérifier l'unicité du libellé
        if (genreRepository.findByLibelleIgnoreCase(genre.getLibelle()).isPresent()) {
            throw new IllegalArgumentException("Un genre avec ce libellé existe déjà");
        }
        
        return genreRepository.save(genre);
    }

    public Genre modifierGenre(Long id, Genre genreMaj) {
        Genre genre = obtenirGenreById(id);
        
        if (genreMaj.getLibelle() == null || genreMaj.getLibelle().trim().isEmpty()) {
            throw new IllegalArgumentException("Le libellé du genre ne peut pas être vide");
        }
        
        // Vérifier l'unicité du libellé (sauf pour le même genre)
        genreRepository.findByLibelleIgnoreCase(genreMaj.getLibelle()).ifPresent(existing -> {
            if (!existing.getId().equals(id)) {
                throw new IllegalArgumentException("Un genre avec ce libellé existe déjà");
            }
        });
        
        genre.setLibelle(genreMaj.getLibelle());
        return genreRepository.save(genre);
    }

    public void supprimerGenre(Long id) {
        genreRepository.deleteById(id);
    }

    @Transactional(readOnly = true)
    public Genre obtenirGenreById(Long id) {
        return genreRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Genre non trouvé avec l'ID: " + id));
    }

    @Transactional(readOnly = true)
    public List<Genre> obtenirTousLesGenres() {
        return genreRepository.findAll();
    }
}
