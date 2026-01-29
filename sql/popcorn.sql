-- Table des catégories de produits
CREATE TABLE categorie_produits (
    id BIGSERIAL PRIMARY KEY,
    nom TEXT NOT NULL UNIQUE
);

-- Table des produits
CREATE TABLE produits (
    id BIGSERIAL PRIMARY KEY,
    nom TEXT NOT NULL,
    description TEXT,
    id_categorie BIGINT NOT NULL REFERENCES categorie_produits(id)
);

-- Table des tarifs des produits
CREATE TABLE tarif_produits (
    id BIGSERIAL PRIMARY KEY,
    id_produit BIGINT NOT NULL REFERENCES produits(id),
    prix NUMERIC(10,2) NOT NULL,
    date_debut DATE NOT NULL,
    date_fin DATE
);

-- Table des ventes de produits
CREATE TABLE vente_produits (
    id BIGSERIAL PRIMARY KEY,
    id_produit BIGINT NOT NULL REFERENCES produits(id),
    quantite INTEGER NOT NULL,
    prix_unitaire NUMERIC(10,2) NOT NULL,
    total NUMERIC(10,2) NOT NULL,
    date_vente TIMESTAMPTZ NOT NULL
);