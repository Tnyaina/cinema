package cinema.reservation;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface ReservationRepository extends JpaRepository<Reservation, Long> {

    @Query("SELECT r FROM Reservation r WHERE r.personne.id = :personneId ORDER BY r.id DESC")
    List<Reservation> findByPersonneId(@Param("personneId") Long personneId);

    @Query("SELECT r FROM Reservation r WHERE r.seance.id = :seanceId")
    List<Reservation> findBySeanceId(@Param("seanceId") Long seanceId);
}

