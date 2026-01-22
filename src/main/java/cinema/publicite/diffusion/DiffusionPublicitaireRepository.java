package cinema.publicite.diffusion;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface DiffusionPublicitaireRepository extends JpaRepository<DiffusionPublicitaire, Long> {

    @Query("SELECT d FROM DiffusionPublicitaire d WHERE d.seanceId = :seanceId ORDER BY d.dateDiffusion")
    List<DiffusionPublicitaire> findBySeanceId(@Param("seanceId") Long seanceId);

    @Query("SELECT d FROM DiffusionPublicitaire d WHERE d.videoPublicitaire.societe.id = :societeId ORDER BY d.dateDiffusion DESC")
    List<DiffusionPublicitaire> findBySocieteId(@Param("societeId") Long societeId);
}
