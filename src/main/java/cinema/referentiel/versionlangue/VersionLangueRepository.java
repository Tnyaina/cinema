package cinema.referentiel.versionlangue;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface VersionLangueRepository extends JpaRepository<VersionLangue, Long> {
    
    List<VersionLangue> findByCodeContaining(String code);
    
    @Query("SELECT vl FROM VersionLangue vl WHERE vl.code = :code")
    Optional<VersionLangue> findByCodeExact(@Param("code") String code);
}
