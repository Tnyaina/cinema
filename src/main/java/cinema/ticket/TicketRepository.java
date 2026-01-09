package cinema.ticket;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface TicketRepository extends JpaRepository<Ticket, Long> {

    @Query("SELECT t FROM Ticket t WHERE t.reservation.id = :reservationId ORDER BY t.id")
    List<Ticket> findByReservationId(@Param("reservationId") Long reservationId);

    @Query("SELECT t FROM Ticket t WHERE t.seance.id = :seanceId ORDER BY t.place.numero")
    List<Ticket> findBySeanceId(@Param("seanceId") Long seanceId);

    @Query("SELECT t FROM Ticket t WHERE t.status.id = :statusId ORDER BY t.id")
    List<Ticket> findByStatusId(@Param("statusId") Long statusId);
}
