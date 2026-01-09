package cinema.referentiel.typeplace;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;

@Repository
public interface TypePlaceRepository extends JpaRepository<TypePlace, Long> {
    Optional<TypePlace> findByLibelleIgnoreCase(String libelle);
}
