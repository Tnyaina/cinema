package cinema.publicite.type;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TypeDiffusionPubRepository extends JpaRepository<TypeDiffusionPub, Long> {
}
