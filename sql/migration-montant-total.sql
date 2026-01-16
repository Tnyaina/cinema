-- Migration: Augmenter la précision de toutes les colonnes numériques
-- Raison: Supporter les montants et prix en Ar (15000, 20000, etc.)
-- Date: 2026-01-16

-- 1. Modifier la colonne montant_total de la table reservation
ALTER TABLE reservation
ALTER COLUMN montant_total TYPE NUMERIC(15,2);

-- 2. Modifier la colonne prix de la table ticket
ALTER TABLE ticket
ALTER COLUMN prix TYPE NUMERIC(15,2);

-- 3. Modifier la colonne prix de la table tarif_seance
ALTER TABLE tarif_seance
ALTER COLUMN prix TYPE NUMERIC(15,2);

-- 4. Modifier la colonne prix de la table tarif_defaut
ALTER TABLE tarif_defaut
ALTER COLUMN prix TYPE NUMERIC(15,2);

-- Vérification des modifications (décommenter pour tester)
-- SELECT table_name, column_name, data_type, numeric_precision, numeric_scale 
-- FROM information_schema.columns 
-- WHERE table_name IN ('reservation', 'ticket', 'tarif_seance', 'tarif_defaut')
--   AND column_name IN ('montant_total', 'prix')
-- ORDER BY table_name, column_name;

-- Vérifier la modification
-- SELECT column_name, data_type, numeric_precision, numeric_scale 
-- FROM information_schema.columns 
-- WHERE table_name = 'reservation' AND column_name = 'montant_total';
