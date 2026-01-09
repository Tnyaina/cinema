INSERT INTO genre (libelle) VALUES
('Action'),
('Comedie'),
('Drame'),
('Science-Fiction'),
('Animation');


INSERT INTO film (titre, description, duree_minutes, date_sortie, age_min, id_langue_originale) VALUES
('Inception', 'Un voleur infiltre les reves', 148, '2010-07-21', 12, 2),
('Le Roi Lion', 'Un jeune lion decouvre son destin', 88, '1994-06-15', 0, 2),
('Intouchables', 'Une amitie improbable', 112, '2011-11-02', 0, 1);

INSERT INTO film_genre (id_film, id_genre) VALUES
(1, 1), -- Inception - Action
(1, 4), -- Inception - Sci-Fi
(2, 5), -- Roi Lion - Animation
(3, 2), -- Intouchables - Comedie
(3, 3); -- Intouchables - Drame

INSERT INTO salle (nom, capacite) VALUES
('Salle 1', 6),
('Salle 2', 4),
('Salle VIP', 4);

INSERT INTO place (id_salle, rangee, numero, code_place, id_type_place) VALUES
(1, 'A', 1, 'A1', 1),
(1, 'A', 2, 'A2', 1),
(1, 'A', 3, 'A3', 1),
(1, 'B', 1, 'B1', 1),
(1, 'B', 2, 'B2', 1),
(1, 'P', 1, 'PMR1', 3);

INSERT INTO place (id_salle, rangee, numero, code_place, id_type_place) VALUES
(2, 'A', 1, 'A1', 1),
(2, 'A', 2, 'A2', 1),
(2, 'B', 1, 'B1', 1),
(2, 'B', 2, 'B2', 1);

INSERT INTO place (id_salle, rangee, numero, code_place, id_type_place) VALUES
(3, 'A', 1, 'VIP-A1', 2),
(3, 'A', 2, 'VIP-A2', 2),
(3, 'B', 1, 'VIP-B1', 2),
(3, 'B', 2, 'VIP-B2', 2);

INSERT INTO seance (id_film, id_salle, debut, fin, id_version_langue) VALUES
(1, 1, '2026-01-10 14:00', '2026-01-10 16:30', 3),
(2, 2, '2026-01-10 15:00', '2026-01-10 16:30', 1),
(3, 3, '2026-01-10 18:00', '2026-01-10 20:00', 1);

INSERT INTO tarif_defaut (id_type_place, id_categorie_personne, prix) VALUES
(1, 1, 8.00),
(1, 2, 5.00),
(1, 3, 6.00),
(2, 1, 12.00),
(2, 2, 9.00),
(2, 3, 10.00),
(3, 1, 6.00),
(3, 2, 4.00),
(3, 3, 5.00);
