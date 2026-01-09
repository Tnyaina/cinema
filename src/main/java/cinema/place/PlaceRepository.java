package cinema.place;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface PlaceRepository extends JpaRepository<Place, Long> {

    @Query("SELECT p FROM Place p WHERE p.salle.id = :salleId ORDER BY p.rangee, p.numero")
    List<Place> findBySalleId(@Param("salleId") Long salleId);

    @Query("SELECT p FROM Place p WHERE p.salle.id = :salleId AND p.codePlace LIKE %:codePlace%")
    List<Place> findByCodePlaceContaining(@Param("salleId") Long salleId, @Param("codePlace") String codePlace);

    @Query("SELECT COUNT(p) FROM Place p WHERE p.salle.id = :salleId")
    long countBySalleId(@Param("salleId") Long salleId);
}
