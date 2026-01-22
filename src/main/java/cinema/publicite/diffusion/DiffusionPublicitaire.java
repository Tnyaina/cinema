package cinema.publicite.diffusion;

import jakarta.persistence.*;
import cinema.shared.BaseEntity;
import cinema.publicite.video.VideoPublicitaire;
import cinema.publicite.type.TypeDiffusionPub;
import org.springframework.format.annotation.DateTimeFormat;
import java.time.LocalDateTime;

@Entity
@Table(name = "diffusion_publicitaire")
public class DiffusionPublicitaire extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "video_publicitaire_id", nullable = false)
    private VideoPublicitaire videoPublicitaire;

    @Column(name = "seance_id", nullable = false)
    private Long seanceId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "type_diffusion_id", nullable = false)
    private TypeDiffusionPub typeDiffusion;

    @Column(nullable = false, columnDefinition = "NUMERIC(15,2)")
    private Double tarifApplique;

    @Column(nullable = false, columnDefinition = "TIMESTAMPTZ")
    @DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm")
    private LocalDateTime dateDiffusion;

    // Constructeurs
    public DiffusionPublicitaire() {
    }

    public DiffusionPublicitaire(VideoPublicitaire videoPublicitaire, Long seanceId, TypeDiffusionPub typeDiffusion, Double tarifApplique, LocalDateTime dateDiffusion) {
        this.videoPublicitaire = videoPublicitaire;
        this.seanceId = seanceId;
        this.typeDiffusion = typeDiffusion;
        this.tarifApplique = tarifApplique;
        this.dateDiffusion = dateDiffusion;
    }

    // Getters et Setters
    public VideoPublicitaire getVideoPublicitaire() {
        return videoPublicitaire;
    }

    public void setVideoPublicitaire(VideoPublicitaire videoPublicitaire) {
        this.videoPublicitaire = videoPublicitaire;
    }

    public Long getSeanceId() {
        return seanceId;
    }

    public void setSeanceId(Long seanceId) {
        this.seanceId = seanceId;
    }

    public TypeDiffusionPub getTypeDiffusion() {
        return typeDiffusion;
    }

    public void setTypeDiffusion(TypeDiffusionPub typeDiffusion) {
        this.typeDiffusion = typeDiffusion;
    }

    public Double getTarifApplique() {
        return tarifApplique;
    }

    public void setTarifApplique(Double tarifApplique) {
        this.tarifApplique = tarifApplique;
    }

    public LocalDateTime getDateDiffusion() {
        return dateDiffusion;
    }

    public void setDateDiffusion(LocalDateTime dateDiffusion) {
        this.dateDiffusion = dateDiffusion;
    }

    @Override
    public String toString() {
        return "DiffusionPublicitaire{" +
                "id=" + getId() +
                ", seanceId=" + seanceId +
                ", tarifApplique=" + tarifApplique +
                ", dateDiffusion=" + dateDiffusion +
                '}';
    }
}
