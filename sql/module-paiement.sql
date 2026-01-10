CREATE TABLE paiement (
    id BIGSERIAL PRIMARY KEY,
    id_reservation BIGINT NOT NULL REFERENCES reservation(id),
    id_status BIGINT NOT NULL REFERENCES status(id),
    montant_total NUMERIC(8, 2) NOT NULL,
    cree_le TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE mode_paiement (
    id BIGSERIAL PRIMARY KEY,
    code TEXT UNIQUE NOT NULL,
    libelle TEXT NOT NULL
);

CREATE TABLE paiement_detail (
    id BIGSERIAL PRIMARY KEY,
    id_paiement BIGINT NOT NULL REFERENCES paiement(id) ON DELETE CASCADE,
    id_mode_paiement BIGINT NOT NULL REFERENCES mode_paiement(id),
    montant NUMERIC(8, 2) NOT NULL,
    reference_externe TEXT,
    cree_le TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE historique_statut_paiement (
    id BIGSERIAL PRIMARY KEY,
    id_paiement BIGINT NOT NULL REFERENCES paiement(id) ON DELETE CASCADE,
    id_status BIGINT NOT NULL REFERENCES status(id),
    date_changement TIMESTAMPTZ DEFAULT now(),
    commentaire TEXT
);

INSERT INTO status (code, libelle, valeur, est_final) VALUES
('PAIEMENT_PARTIEL','Paiement partiel',30,false);