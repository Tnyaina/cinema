package cinema.produit;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;

@Repository
public interface CategorieProduitRepository extends JpaRepository<CategorieProduit, Long> {

    Optional<CategorieProduit> findByNom(String nom);
}