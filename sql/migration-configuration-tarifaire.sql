-- ============================================================================
-- Migration : Configuration Tarifaire
-- Description : Création de la table de configuration des relations tarifaires
--               entre catégories de personne avec coefficients multiplicateurs
-- Date : 16 janvier 2026
-- ============================================================================

-- Création de la table configuration_tarifaire
CREATE TABLE IF NOT EXISTS configuration_tarifaire (
    id SERIAL PRIMARY KEY,
    id_categorie_personne INTEGER NOT NULL,
    id_categorie_reference INTEGER NULL,
    coefficient_multiplicateur NUMERIC(5,2) NOT NULL CHECK (coefficient_multiplicateur > 0),
    description VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Contraintes
    CONSTRAINT fk_config_tarif_categorie 
        FOREIGN KEY (id_categorie_personne) 
        REFERENCES categorie_personne(id) 
        ON DELETE RESTRICT,
    
    CONSTRAINT fk_config_tarif_reference 
        FOREIGN KEY (id_categorie_reference) 
        REFERENCES categorie_personne(id) 
        ON DELETE RESTRICT,
    
    CONSTRAINT uk_config_tarif_categorie 
        UNIQUE (id_categorie_personne),
    
    -- Une catégorie ne peut pas se référencer elle-même
    CONSTRAINT chk_config_tarif_no_self_reference 
        CHECK (id_categorie_personne != id_categorie_reference)
);

-- Index pour optimiser les recherches
CREATE INDEX IF NOT EXISTS idx_config_tarif_categorie 
    ON configuration_tarifaire(id_categorie_personne);

CREATE INDEX IF NOT EXISTS idx_config_tarif_reference 
    ON configuration_tarifaire(id_categorie_reference);

-- Commentaires sur la table et les colonnes
COMMENT ON TABLE configuration_tarifaire IS 
    'Configuration des relations tarifaires entre catégories de personne. Permet de définir des coefficients multiplicateurs pour calculer automatiquement les tarifs.';

COMMENT ON COLUMN configuration_tarifaire.id_categorie_personne IS 
    'La catégorie de personne dont on définit le tarif';

COMMENT ON COLUMN configuration_tarifaire.id_categorie_reference IS 
    'La catégorie de référence utilisée pour calculer le tarif (NULL = catégorie autonome avec tarif fixe)';

COMMENT ON COLUMN configuration_tarifaire.coefficient_multiplicateur IS 
    'Coefficient multiplicateur à appliquer au tarif de référence (ex: 0.5 pour 50%, 1.5 pour 150%)';

COMMENT ON COLUMN configuration_tarifaire.description IS 
    'Description de la relation tarifaire (ex: "50% du tarif Adulte")';

-- ============================================================================
-- Données par défaut (à adapter selon vos catégories existantes)
-- ============================================================================

-- Insertion des configurations par défaut
-- Note: Ces insertions supposent que les catégories Adulte, Enfant et Senior existent déjà

DO $$
DECLARE
    v_id_adulte INTEGER;
    v_id_enfant INTEGER;
    v_id_senior INTEGER;
BEGIN
    -- Récupérer les IDs des catégories existantes
    SELECT id INTO v_id_adulte FROM categorie_personne WHERE LOWER(libelle) = 'adulte' LIMIT 1;
    SELECT id INTO v_id_enfant FROM categorie_personne WHERE LOWER(libelle) = 'enfant' LIMIT 1;
    SELECT id INTO v_id_senior FROM categorie_personne WHERE LOWER(libelle) = 'senior' LIMIT 1;
    
    -- Configuration pour Adulte (catégorie autonome - pas de référence)
    IF v_id_adulte IS NOT NULL THEN
        INSERT INTO configuration_tarifaire 
            (id_categorie_personne, id_categorie_reference, coefficient_multiplicateur, description)
        VALUES 
            (v_id_adulte, NULL, 1.0, 'Catégorie autonome - tarif de base')
        ON CONFLICT (id_categorie_personne) DO NOTHING;
    END IF;
    
    -- Configuration pour Enfant (50% du tarif Adulte)
    IF v_id_enfant IS NOT NULL AND v_id_adulte IS NOT NULL THEN
        INSERT INTO configuration_tarifaire 
            (id_categorie_personne, id_categorie_reference, coefficient_multiplicateur, description)
        VALUES 
            (v_id_enfant, v_id_adulte, 0.5, '50% du tarif Adulte')
        ON CONFLICT (id_categorie_personne) DO NOTHING;
    END IF;
    
    -- Configuration pour Senior (150% du tarif Adulte)
    IF v_id_senior IS NOT NULL AND v_id_adulte IS NOT NULL THEN
        INSERT INTO configuration_tarifaire 
            (id_categorie_personne, id_categorie_reference, coefficient_multiplicateur, description)
        VALUES 
            (v_id_senior, v_id_adulte, 1.5, '150% du tarif Adulte (50% plus cher)')
        ON CONFLICT (id_categorie_personne) DO NOTHING;
    END IF;
    
    RAISE NOTICE 'Configuration tarifaire initialisée avec succès';
    
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Erreur lors de l''initialisation: %', SQLERRM;
END $$;

-- ============================================================================
-- Exemples d'utilisation et requêtes utiles
-- ============================================================================

-- Afficher toutes les configurations tarifaires
/*
SELECT 
    ct.id,
    cp.libelle as categorie,
    cr.libelle as reference,
    ct.coefficient_multiplicateur,
    ct.coefficient_multiplicateur * 100 as pourcentage,
    ct.description
FROM configuration_tarifaire ct
JOIN categorie_personne cp ON ct.id_categorie_personne = cp.id
LEFT JOIN categorie_personne cr ON ct.id_categorie_reference = cr.id
ORDER BY ct.coefficient_multiplicateur;
*/

-- Calculer les tarifs pour un type de place donné (ex: Place Standard à 10000 Ar)
/*
WITH tarif_base AS (
    SELECT 10000.0 AS prix_adulte
)
SELECT 
    cp.libelle as categorie,
    CASE 
        WHEN ct.id_categorie_reference IS NULL THEN tb.prix_adulte
        ELSE ROUND(tb.prix_adulte * ct.coefficient_multiplicateur, 2)
    END as tarif_calcule,
    ct.description
FROM configuration_tarifaire ct
JOIN categorie_personne cp ON ct.id_categorie_personne = cp.id
CROSS JOIN tarif_base tb
ORDER BY ct.coefficient_multiplicateur;
*/

-- Vérifier les références circulaires potentielles
/*
WITH RECURSIVE reference_chain AS (
    -- Départ : toutes les configurations
    SELECT 
        id_categorie_personne,
        id_categorie_reference,
        ARRAY[id_categorie_personne] as path,
        1 as depth
    FROM configuration_tarifaire
    WHERE id_categorie_reference IS NOT NULL
    
    UNION ALL
    
    -- Récursion : suivre la chaîne de références
    SELECT 
        rc.id_categorie_personne,
        ct.id_categorie_reference,
        rc.path || ct.id_categorie_reference,
        rc.depth + 1
    FROM reference_chain rc
    JOIN configuration_tarifaire ct ON ct.id_categorie_personne = rc.id_categorie_reference
    WHERE ct.id_categorie_reference IS NOT NULL
      AND ct.id_categorie_reference != ALL(rc.path) -- Détection de cycle
      AND rc.depth < 10 -- Limite de profondeur
)
SELECT 
    cp.libelle as categorie,
    array_agg(cp2.libelle ORDER BY rc.depth) as chaine_references
FROM reference_chain rc
JOIN categorie_personne cp ON cp.id = rc.id_categorie_personne
JOIN categorie_personne cp2 ON cp2.id = ANY(rc.path)
GROUP BY cp.libelle;
*/

-- ============================================================================
-- Rollback (en cas de besoin)
-- ============================================================================
/*
-- Supprimer la table et toutes les données
DROP TABLE IF EXISTS configuration_tarifaire CASCADE;

-- Note: Cette opération est irréversible !
*/
