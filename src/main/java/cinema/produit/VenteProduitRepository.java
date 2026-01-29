package cinema.produit;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface VenteProduitRepository extends JpaRepository<VenteProduit, Long> {

    List<VenteProduit> findByProduitId(Long produitId);

    @Query("SELECT v FROM VenteProduit v WHERE v.dateVente BETWEEN :debut AND :fin")
    List<VenteProduit> findByDateVenteBetween(@Param("debut") LocalDateTime debut, @Param("fin") LocalDateTime fin);

    @Query("SELECT SUM(v.total) FROM VenteProduit v WHERE v.dateVente BETWEEN :debut AND :fin")
    Double getTotalVentesBetween(@Param("debut") LocalDateTime debut, @Param("fin") LocalDateTime fin);
}