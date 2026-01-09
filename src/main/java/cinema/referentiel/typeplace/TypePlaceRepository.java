package cinema.referentiel.typeplace;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TypePlaceRepository extends JpaRepository<TypePlace, Long> {
}
