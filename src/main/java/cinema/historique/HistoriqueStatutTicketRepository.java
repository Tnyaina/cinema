package cinema.historique;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface HistoriqueStatutTicketRepository extends JpaRepository<HistoriqueStatutTicket, Long> {
    List<HistoriqueStatutTicket> findByTicketId(Long ticketId);
}
