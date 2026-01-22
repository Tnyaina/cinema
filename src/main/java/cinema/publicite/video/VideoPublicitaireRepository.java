package cinema.publicite.video;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface VideoPublicitaireRepository extends JpaRepository<VideoPublicitaire, Long> {

    @Query("SELECT v FROM VideoPublicitaire v WHERE v.societe.id = :societeId ORDER BY v.libelle")
    List<VideoPublicitaire> findBySocieteId(@Param("societeId") Long societeId);
}
