package cinema.statistique;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import cinema.ticket.TicketRepository;
import cinema.seance.SeanceRepository;
import java.time.LocalDateTime;
import java.time.YearMonth;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class StatistiqueService {

    private final TicketRepository ticketRepository;
    private final SeanceRepository seanceRepository;

    /**
     * Récupère les statistiques pour un mois spécifique
     */
    public StatistiqueDTO getStatistiquesByMoisAnnee(int mois, int annee) {
        YearMonth yearMonth = YearMonth.of(annee, mois);
        LocalDateTime debut = yearMonth.atDay(1).atStartOfDay();
        LocalDateTime fin = yearMonth.atEndOfMonth().atTime(23, 59, 59);

        return construireStatistiques(debut, fin);
    }

    /**
     * Récupère les statistiques pour une année entière
     */
    public StatistiqueDTO getStatistiquesByAnnee(int annee) {
        LocalDateTime debut = LocalDateTime.of(annee, 1, 1, 0, 0, 0);
        LocalDateTime fin = LocalDateTime.of(annee, 12, 31, 23, 59, 59);

        return construireStatistiques(debut, fin);
    }

    /**
     * Construit un DTO avec toutes les statistiques
     */
    private StatistiqueDTO construireStatistiques(LocalDateTime debut, LocalDateTime fin) {
        StatistiqueDTO stats = new StatistiqueDTO();

        // CA Total (somme des prix des tickets payés/confirmés)
        Double caTotal = ticketRepository.calculerCATotalParPeriode(debut, fin);
        stats.setCATotal(caTotal != null ? caTotal : 0.0);

        // Nombre de séances
        Long nbSeances = seanceRepository.countSeancesParPeriode(debut, fin);
        stats.setNombreSeances(nbSeances != null ? nbSeances : 0L);

        // Nombre de tickets vendus
        Long nbTicketsVendus = ticketRepository.countTicketsVendusParPeriode(debut, fin);
        stats.setNombreTicketsVendus(nbTicketsVendus != null ? nbTicketsVendus : 0L);

        // Nombre de tickets annulés
        Long nbTicketsAnnules = ticketRepository.countTicketsAnnulesParPeriode(debut, fin);
        stats.setNombreTicketsAnnules(nbTicketsAnnules != null ? nbTicketsAnnules : 0L);

        // Ticket moyen
        if (stats.getNombreTicketsVendus() > 0) {
            stats.setPrixMoyenTicket(stats.getCATotal() / stats.getNombreTicketsVendus());
        }

        // Nombre de séances remplies (taux d'occupation moyen) - calculé en Java
        List<Double> tauxParSeance = ticketRepository.calculerTauxOccupationParSeanceParPeriode(debut, fin);
        if (tauxParSeance != null && !tauxParSeance.isEmpty()) {
            double moyenne = tauxParSeance.stream()
                    .mapToDouble(Double::doubleValue)
                    .average()
                    .orElse(0.0);
            stats.setTauxOccupationMoyen(moyenne);
        } else {
            stats.setTauxOccupationMoyen(0.0);
        }

        return stats;
    }
}

