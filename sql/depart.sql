-- ==============================
-- TYPE DE PLACE
-- ==============================
CREATE TABLE type_place (
  id SERIAL PRIMARY KEY,
  libelle TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ
);

-- ==============================
-- CATEGORIE PERSONNE
-- ==============================
CREATE TABLE categorie_personne (
  id SERIAL PRIMARY KEY,
  libelle TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ
);

-- ==============================
-- LANGUE
-- ==============================
CREATE TABLE langue (
  id SERIAL PRIMARY KEY,
  code TEXT UNIQUE NOT NULL,
  libelle TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ
);

-- ==============================
-- VERSION LINGUISTIQUE
-- ==============================
CREATE TABLE version_langue (
  id SERIAL PRIMARY KEY,
  code TEXT UNIQUE NOT NULL,
  libelle TEXT NOT NULL,
  id_langue_audio INT REFERENCES langue(id),
  id_langue_sous_titre INT REFERENCES langue(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ
);

-- ==============================
-- FILM
-- ==============================
CREATE TABLE film (
  id SERIAL PRIMARY KEY,
  titre TEXT NOT NULL,
  description TEXT,
  duree_minutes INT,
  date_sortie DATE,
  age_min INT DEFAULT 0,
  id_langue_originale INT REFERENCES langue(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ
);

-- ==============================
-- GENRE
-- ==============================
CREATE TABLE genre (
  id SERIAL PRIMARY KEY,
  libelle TEXT UNIQUE NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ
);

CREATE TABLE film_genre (
  id_film INT REFERENCES film(id) ON DELETE CASCADE,
  id_genre INT REFERENCES genre(id) ON DELETE CASCADE,
  PRIMARY KEY (id_film, id_genre)
);

-- ==============================
-- SALLE
-- ==============================
CREATE TABLE salle (
  id SERIAL PRIMARY KEY,
  nom TEXT NOT NULL,
  capacite INT NOT NULL CHECK (capacite > 0),
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ
);

-- ==============================
-- PLACE
-- ==============================
CREATE TABLE place (
  id SERIAL PRIMARY KEY,
  id_salle INT REFERENCES salle(id) ON DELETE CASCADE,
  rangee TEXT NOT NULL,
  numero INT NOT NULL,
  code_place TEXT,
  id_type_place INT REFERENCES type_place(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ,
  UNIQUE (id_salle, rangee, numero)
);

-- ==============================
-- SEANCE
-- ==============================
CREATE TABLE seance (
  id SERIAL PRIMARY KEY,
  id_film INT REFERENCES film(id),
  id_salle INT REFERENCES salle(id),
  debut TIMESTAMPTZ NOT NULL,
  fin TIMESTAMPTZ,
  id_version_langue INT REFERENCES version_langue(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ
);

CREATE INDEX idx_seance_salle_debut ON seance(id_salle, debut);

-- ==============================
-- PERSONNE
-- ==============================
CREATE TABLE personne (
  id SERIAL PRIMARY KEY,
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
  id SERIAL PRIMARY KEY,
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
  id SERIAL PRIMARY KEY,
  id_personne INT REFERENCES personne(id),
  id_seance INT REFERENCES seance(id),
  id_status INT REFERENCES status(id),
  montant_total NUMERIC(6,2) DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ
);

-- ==============================
-- HISTORIQUE RESERVATION
-- ==============================
CREATE TABLE historique_statut_reservation (
  id SERIAL PRIMARY KEY,
  id_reservation INT REFERENCES reservation(id) ON DELETE CASCADE,
  id_status INT REFERENCES status(id),
  date_changement TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  change_par INT REFERENCES personne(id),
  commentaire TEXT
);

-- ==============================
-- TICKET
-- ==============================
CREATE TABLE ticket (
  id SERIAL PRIMARY KEY,
  id_reservation INT REFERENCES reservation(id),
  id_seance INT REFERENCES seance(id),
  id_place INT REFERENCES place(id),
  id_status INT REFERENCES status(id),
  id_categorie_personne INT REFERENCES categorie_personne(id),
  prix NUMERIC(6,2) NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ,
  UNIQUE (id_seance, id_place)
);

-- ==============================
-- HISTORIQUE TICKET
-- ==============================
CREATE TABLE historique_statut_ticket (
  id SERIAL PRIMARY KEY,
  id_ticket INT REFERENCES ticket(id) ON DELETE CASCADE,
  id_status INT REFERENCES status(id),
  date_changement TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  change_par INT REFERENCES personne(id),
  commentaire TEXT
);

-- ==============================
-- TARIFICATION
-- ==============================
CREATE TABLE tarif_defaut (
  id SERIAL PRIMARY KEY,
  id_type_place INT REFERENCES type_place(id),
  id_categorie_personne INT REFERENCES categorie_personne(id),
  prix NUMERIC(6,2) NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ
);

CREATE TABLE tarif_seance (
  id SERIAL PRIMARY KEY,
  id_seance INT REFERENCES seance(id),
  id_type_place INT REFERENCES type_place(id),
  id_categorie_personne INT REFERENCES categorie_personne(id),
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
