-- ==============================
-- MIGRATION: Remplacer la contrainte unique par une contrainte partielle
-- Permet plusieurs tickets pour la même place/séance si l'un est annulé
-- ==============================

-- Supprimer les contraintes uniques existantes sur (id_seance, id_place)
ALTER TABLE ticket DROP CONSTRAINT IF EXISTS ticket_id_seance_id_place_unique_active;
ALTER TABLE ticket DROP CONSTRAINT IF EXISTS ticket_id_seance_id_place_key;
ALTER TABLE ticket DROP CONSTRAINT IF EXISTS uk8jbngt67hfjyucshavkkqnrfl;

-- Supprimer les index associés s'ils existent
DROP INDEX IF EXISTS idx_ticket_seance_place_active;

-- Créer une contrainte unique partielle qui exclut les tickets annulés
-- Cette contrainte permet d'avoir plusieurs tickets pour la même place/séance
-- tant que les tickets en doublon ne sont pas tous "actifs" (non annulés)

-- Récupérer l'ID du statut ANNULEE pour l'utiliser dans l'index
DO $$ 
DECLARE 
    v_status_annulee_id BIGINT;
BEGIN
    SELECT id INTO v_status_annulee_id FROM status WHERE code = 'ANNULEE' LIMIT 1;
    
    IF v_status_annulee_id IS NOT NULL THEN
        -- L'index partiel exclut les tickets annulés
        EXECUTE format(
            'CREATE UNIQUE INDEX idx_ticket_seance_place_active 
             ON ticket(id_seance, id_place) 
             WHERE id_status != %L',
            v_status_annulee_id
        );
        RAISE NOTICE 'Index partiel créé avec exclusion des tickets annulés (id_status = %)', v_status_annulee_id;
    ELSE
        RAISE EXCEPTION 'Statut ANNULEE non trouvé en base de données';
    END IF;
END $$;


