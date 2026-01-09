package cinema.personne;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.Optional;

@Repository
public interface PersonneRepository extends JpaRepository<Personne, Long> {
    
    @Query("SELECT p FROM Personne p WHERE p.email = :email")
    Optional<Personne> findByEmail(@Param("email") String email);
    
    @Query("SELECT p FROM Personne p WHERE p.telephone = :telephone")
    Optional<Personne> findByTelephone(@Param("telephone") String telephone);
}
