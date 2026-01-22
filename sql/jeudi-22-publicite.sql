-- Table Societe
CREATE TABLE societe (
    id BIGSERIAL PRIMARY KEY,
    libelle VARCHAR(255) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table TypeDiffusionPub
CREATE TABLE type_diffusion_pub (
    id BIGSERIAL PRIMARY KEY,
    libelle VARCHAR(255) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table VideoPublicitaire
CREATE TABLE video_publicitaire (
    id BIGSERIAL PRIMARY KEY,
    societe_id BIGINT NOT NULL,
    libelle VARCHAR(255) NOT NULL,
    duree INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_video_pub_societe FOREIGN KEY (societe_id) REFERENCES societe(id) ON DELETE CASCADE
);

-- Table DiffusionPublicitaire
CREATE TABLE diffusion_publicitaire (
    id BIGSERIAL PRIMARY KEY,
    video_publicitaire_id BIGINT NOT NULL,
    seance_id BIGINT NOT NULL,
    type_diffusion_id BIGINT NOT NULL,
    tarif_applique NUMERIC(15,2) NOT NULL,
    date_diffusion TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_diffusion_video FOREIGN KEY (video_publicitaire_id) REFERENCES video_publicitaire(id) ON DELETE CASCADE,
    CONSTRAINT fk_diffusion_type FOREIGN KEY (type_diffusion_id) REFERENCES type_diffusion_pub(id) ON DELETE RESTRICT
);

-- Table TarifPubliciteDefaut
CREATE TABLE tarif_publicite_defaut (
    id BIGSERIAL PRIMARY KEY,
    type_diffusion_id BIGINT NOT NULL,
    prix_unitaire NUMERIC(15,2) NOT NULL,
    date_debut DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_tarif_defaut_type FOREIGN KEY (type_diffusion_id) REFERENCES type_diffusion_pub(id) ON DELETE CASCADE,
    CONSTRAINT uq_tarif_defaut_type_date UNIQUE (type_diffusion_id, date_debut)
);

-- Table TarifPublicitePersonnalise
CREATE TABLE tarif_publicite_personnalise (
    id BIGSERIAL PRIMARY KEY,
    societe_id BIGINT NOT NULL,
    type_diffusion_id BIGINT NOT NULL,
    prix_unitaire NUMERIC(15,2) NOT NULL,
    date_debut DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_tarif_pers_societe FOREIGN KEY (societe_id) REFERENCES societe(id) ON DELETE CASCADE,
    CONSTRAINT fk_tarif_pers_type FOREIGN KEY (type_diffusion_id) REFERENCES type_diffusion_pub(id) ON DELETE CASCADE,
    CONSTRAINT uq_tarif_pers_societe_type_date UNIQUE (societe_id, type_diffusion_id, date_debut)
);

-- Table PaiementPublicite
CREATE TABLE paiement_publicite (
    id BIGSERIAL PRIMARY KEY,
    societe_id BIGINT NOT NULL,
    montant NUMERIC(15,2) NOT NULL,
    date_paiement DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_paiement_societe FOREIGN KEY (societe_id) REFERENCES societe(id) ON DELETE CASCADE
);