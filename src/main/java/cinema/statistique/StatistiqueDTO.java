package cinema.statistique;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class StatistiqueDTO {
    
    private Double CATotal;
    private Long nombreSeances;
    private Long nombreTicketsVendus;
    private Long nombreTicketsAnnules;
    private Double prixMoyenTicket;
    private Double tauxOccupationMoyen;
}
