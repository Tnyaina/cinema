-- Migration: Correction du schéma configuration_tarifaire
-- Suppression de la colonne 'est_reference' qui n'est plus utilisée
-- La logique de référence est maintenant basée sur le caractère nullable de 'id_categorie_reference'

-- Vérifier que la colonne existe avant de la supprimer
ALTER TABLE configuration_tarifaire DROP COLUMN IF EXISTS est_reference;

-- Vérifier que la contrainte de clé étrangère existe
-- Si elle n'existe pas, l'ajouter
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT constraint_name 
        FROM information_schema.table_constraints 
        WHERE table_name = 'configuration_tarifaire' 
        AND constraint_name = 'fk_config_ref_categorie'
    ) THEN
        ALTER TABLE configuration_tarifaire 
        ADD CONSTRAINT fk_config_ref_categorie 
        FOREIGN KEY (id_categorie_reference) 
        REFERENCES categorie_personne(id);
    END IF;
END $$;

-- Vérifier que la contrainte d'unicité existe
-- Si elle n'existe pas, l'ajouter
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT constraint_name 
        FROM information_schema.table_constraints 
        WHERE table_name = 'configuration_tarifaire' 
        AND constraint_name = 'uk_config_categorie'
    ) THEN
        ALTER TABLE configuration_tarifaire 
        ADD CONSTRAINT uk_config_categorie 
        UNIQUE (id_categorie_personne);
    END IF;
END $$;

-- Afficher le schéma actualisé
\d configuration_tarifaire
