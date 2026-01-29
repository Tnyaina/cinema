package cinema.produit;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface TarifProduitRepository extends JpaRepository<TarifProduit, Long> {

    List<TarifProduit> findByProduitId(Long produitId);

    @Query("SELECT t FROM TarifProduit t WHERE t.produit.id = :produitId AND t.dateDebut <= :date AND (t.dateFin IS NULL OR t.dateFin >= :date)")
    Optional<TarifProduit> findTarifActifByProduitAndDate(@Param("produitId") Long produitId, @Param("date") LocalDate date);
}