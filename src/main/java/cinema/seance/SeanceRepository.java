package cinema.seance;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface SeanceRepository extends JpaRepository<Seance, Long> {

    @Query("SELECT s FROM Seance s WHERE s.film.id = :filmId ORDER BY s.debut ASC")
    List<Seance> findByFilmId(@Param("filmId") Long filmId);

    @Query("SELECT s FROM Seance s WHERE s.salle.id = :salleId ORDER BY s.debut ASC")
    List<Seance> findBySalleId(@Param("salleId") Long salleId);
}
