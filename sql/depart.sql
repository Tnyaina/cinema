-- ==============================
-- TYPE DE PLACE
-- ==============================
CREATE TABLE type_place (
  id BIGSERIAL PRIMARY KEY,
  libelle TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ
);

-- ==============================
-- CATEGORIE PERSONNE
-- ==============================
CREATE TABLE categorie_personne (
  id BIGSERIAL PRIMARY KEY,
  libelle TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ
);

-- ==============================
-- LANGUE
-- ==============================
CREATE TABLE langue (
  id BIGSERIAL PRIMARY KEY,
  code TEXT UNIQUE NOT NULL,
  libelle TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ
);

-- ==============================
-- VERSION LINGUISTIQUE
-- ==============================
CREATE TABLE version_langue (
  id BIGSERIAL PRIMARY KEY,
  code TEXT UNIQUE NOT NULL,
  libelle TEXT NOT NULL,
  id_langue_audio BIGINT REFERENCES langue(id),
  id_langue_sous_titre BIGINT REFERENCES langue(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ
);

-- ==============================
-- FILM
-- ==============================
CREATE TABLE film (
  id BIGSERIAL PRIMARY KEY,
  titre TEXT NOT NULL,
  description TEXT,
  duree_minutes INT,
  date_sortie DATE,
  age_min INT DEFAULT 0,
  id_langue_originale BIGINT REFERENCES langue(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ
);

-- ==============================
-- GENRE
-- ==============================
CREATE TABLE genre (
  id BIGSERIAL PRIMARY KEY,
  libelle TEXT UNIQUE NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ
);

CREATE TABLE film_genre (
  id_film BIGINT REFERENCES film(id) ON DELETE CASCADE,
  id_genre BIGINT REFERENCES genre(id) ON DELETE CASCADE,
  PRIMARY KEY (id_film, id_genre)
);

-- ==============================
-- SALLE
-- ==============================
CREATE TABLE salle (
  id BIGSERIAL PRIMARY KEY,
  nom TEXT NOT NULL,
  capacite INT NOT NULL CHECK (capacite > 0),
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ
);

-- ==============================
-- PLACE
-- ==============================
CREATE TABLE place (
  id BIGSERIAL PRIMARY KEY,
  id_salle BIGINT REFERENCES salle(id) ON DELETE CASCADE,
  rangee TEXT NOT NULL,
  numero INT NOT NULL,
  code_place TEXT,
  id_type_place BIGINT REFERENCES type_place(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ,
  UNIQUE (id_salle, rangee, numero)
);

-- ==============================
-- SEANCE
-- ==============================
CREATE TABLE seance (
  id BIGSERIAL PRIMARY KEY,
  id_film BIGINT REFERENCES film(id),
  id_salle BIGINT REFERENCES salle(id),
  debut TIMESTAMPTZ NOT NULL,
  fin TIMESTAMPTZ,
  id_version_langue BIGINT REFERENCES version_langue(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ
);

CREATE INDEX idx_seance_salle_debut ON seance(id_salle, debut);

-- ==============================
-- PERSONNE
-- ==============================
CREATE TABLE personne (
  id BIGSERIAL PRIMARY KEY,
  nom_complet TEXT,
  email TEXT UNIQUE,
  telephone TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ
);

-- ==============================
-- STATUS
-- ==============================
CREATE TABLE status (
  id BIGSERIAL PRIMARY KEY,
  code TEXT UNIQUE NOT NULL,
  libelle TEXT NOT NULL,
  valeur INT NOT NULL,
  est_final BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ
);

-- ==============================
-- RESERVATION
-- ==============================
CREATE TABLE reservation (
  id BIGSERIAL PRIMARY KEY,
  id_personne BIGINT REFERENCES personne(id),
  id_seance BIGINT REFERENCES seance(id),
  id_status BIGINT REFERENCES status(id),
  montant_total NUMERIC(6,2) DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ
);

-- ==============================
-- HISTORIQUE RESERVATION
-- ==============================
CREATE TABLE historique_statut_reservation (
  id BIGSERIAL PRIMARY KEY,
  id_reservation BIGINT REFERENCES reservation(id) ON DELETE CASCADE,
  id_status BIGINT REFERENCES status(id),
  date_changement TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  change_par BIGINT REFERENCES personne(id),
  commentaire TEXT
);

-- ==============================
-- TICKET
-- ==============================
CREATE TABLE ticket (
  id BIGSERIAL PRIMARY KEY,
  id_reservation BIGINT REFERENCES reservation(id),
  id_seance BIGINT REFERENCES seance(id),
  id_place BIGINT REFERENCES place(id),
  id_status BIGINT REFERENCES status(id),
  id_categorie_personne BIGINT REFERENCES categorie_personne(id),
  prix NUMERIC(6,2) NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ,
  UNIQUE (id_seance, id_place)
);

-- ==============================
-- HISTORIQUE TICKET
-- ==============================
CREATE TABLE historique_statut_ticket (
  id BIGSERIAL PRIMARY KEY,
  id_ticket BIGINT REFERENCES ticket(id) ON DELETE CASCADE,
  id_status BIGINT REFERENCES status(id),
  date_changement TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  change_par BIGINT REFERENCES personne(id),
  commentaire TEXT
);

-- ==============================
-- TARIFICATION
-- ==============================
CREATE TABLE tarif_defaut (
  id BIGSERIAL PRIMARY KEY,
  id_type_place BIGINT REFERENCES type_place(id),
  id_categorie_personne BIGINT REFERENCES categorie_personne(id),
  prix NUMERIC(6,2) NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ
);

CREATE TABLE tarif_seance (
  id BIGSERIAL PRIMARY KEY,
  id_seance BIGINT REFERENCES seance(id),
  id_type_place BIGINT REFERENCES type_place(id),
  id_categorie_personne BIGINT REFERENCES categorie_personne(id),
  prix NUMERIC(6,2) NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ
);

INSERT INTO status (code, libelle, valeur, est_final) VALUES
('CREE','Cree',1,false),
('EN_ATTENTE','En attente',11,false),
('PAYE','Paye',21,false),
('CONFIRMEE','Confirmee',31,false),
('ANNULEE','Annulee',100,true),
('EXPIREE','Expiree',101,true),
('DISPONIBLE','Disponible',2,false),
('RESERVEE','Reservee',12,false);

INSERT INTO categorie_personne (libelle) VALUES
('ADULTE'),('ENFANT'),('SENIOR');

INSERT INTO type_place (libelle) VALUES
('STANDARD'),('VIP'),('PMR');

INSERT INTO langue (code, libelle) VALUES
('FR','Francais'),
('EN','Anglais');

INSERT INTO version_langue (code, libelle, id_langue_audio, id_langue_sous_titre) VALUES
('VF','Version Francaise',1,NULL),
('VO','Version Originale',2,NULL),
('VOSTFR','Version Originale Sous-titree Francais',2,1);
