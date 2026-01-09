package cinema.shared;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import cinema.referentiel.status.Status;
import java.util.Optional;

@Repository
public interface StatusRepository extends JpaRepository<Status, Long> {
    
    @Query("SELECT s FROM Status s WHERE s.code = :code")
    Optional<Status> findByCode(@Param("code") String code);
}
