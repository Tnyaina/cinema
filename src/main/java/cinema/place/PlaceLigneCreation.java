package cinema.place;

public class PlaceLigneCreation {

    private String rangee;
    private Integer numeroDebut;
    private Integer numeroFin;
    private Long typePlaceId;

    // Constructeurs
    public PlaceLigneCreation() {
    }

    public PlaceLigneCreation(String rangee, Integer numeroDebut, Integer numeroFin, Long typePlaceId) {
        this.rangee = rangee;
        this.numeroDebut = numeroDebut;
        this.numeroFin = numeroFin;
        this.typePlaceId = typePlaceId;
    }

    // Getters
    public String getRangee() {
        return rangee;
    }

    public Integer getNumeroDebut() {
        return numeroDebut;
    }

    public Integer getNumeroFin() {
        return numeroFin;
    }

    public Long getTypePlaceId() {
        return typePlaceId;
    }

    // Setters
    public void setRangee(String rangee) {
        this.rangee = rangee;
    }

    public void setNumeroDebut(Integer numeroDebut) {
        this.numeroDebut = numeroDebut;
    }

    public void setNumeroFin(Integer numeroFin) {
        this.numeroFin = numeroFin;
    }

    public void setTypePlaceId(Long typePlaceId) {
        this.typePlaceId = typePlaceId;
    }

    // Validation
    public boolean estValide() {
        return rangee != null && !rangee.trim().isEmpty()
            && numeroDebut != null && numeroDebut > 0
            && numeroFin != null && numeroFin > 0
            && numeroDebut <= numeroFin;
    }

    public int getNombrePlaces() {
        if (!estValide()) {
            return 0;
        }
        return numeroFin - numeroDebut + 1;
    }
}
