INSERT INTO categorie (libelle) VALUES
('Goûter') ON CONFLICT (libelle) DO NOTHING;


INSERT INTO plat (nom, prix, id_categorie, description)
SELECT 'Mofo Gasy', 400, id, 'Mofo gasy mafana'
FROM categorie WHERE libelle = 'Goûter';

INSERT INTO plat (nom, prix, id_categorie, description)
SELECT 'Mokary', 600, id, 'Mokary mafana'
FROM categorie WHERE libelle = 'Goûter';

INSERT INTO plat (nom, prix, id_categorie, description)
SELECT 'Koba', 1000, id, 'Pâte d''arachide, banane et farine de riz, cuite en feuille de bananier'
FROM categorie WHERE libelle = 'Goûter';

INSERT INTO plat (nom, prix, id_categorie, description)
SELECT 'Godrogodro', 1000, id, 'Godrogodro mafana'
FROM categorie WHERE libelle = 'Goûter';

INSERT INTO plat (nom, prix, id_categorie, description)
SELECT 'Menakely', 500, id, 'Menakely mafana'
FROM categorie WHERE libelle = 'Goûter';

UPDATE plat SET description = 'Vary sy anana' WHERE nom = 'Vary amin''anana';
UPDATE plat SET description = 'Ravitoto miaraka amin''ny henakisoa' WHERE nom = 'Ravitoto sy henakisoa';
UPDATE plat SET description = 'Akoho miaraka amin''ny voanio' WHERE nom = 'Akoho sy voanio';
UPDATE plat SET description = 'Henakisoa miaraka amin''ny tsaramaso' WHERE nom = 'Henakisoa sy tsaramaso';

UPDATE plat SET description = 'Soupe bien garnie' WHERE nom = 'Soupe chinoise';


UPDATE plat SET disponible = FALSE WHERE nom = 'Ravitoto sy henakisoa';
UPDATE plat SET disponible = FALSE WHERE nom = 'Henakisoa sy tsaramaso';

INSERT INTO plat_du_jour (date_jour, id_plat)
SELECT now(), id
FROM plat where nom = 'Ravitoto sy henakisoa';

INSERT INTO plat_du_jour (date_jour, id_plat)
SELECT CURRENT_DATE - 1, id
FROM plat where nom = 'Mi sao';

INSERT INTO plat_du_jour (date_jour, id_plat)
SELECT CURRENT_DATE - 2, id
FROM plat where nom = 'Romazava';

INSERT INTO plat_du_jour (date_jour, id_plat)
SELECT CURRENT_DATE - 3, id
FROM plat where nom = 'Akoho sy voanio';

INSERT INTO plat_du_jour (date_jour, id_plat)
SELECT CURRENT_DATE - 4, id
FROM plat where nom = 'Henakisoa sy tsaramaso';

INSERT INTO plat_du_jour (date_jour, id_plat)
SELECT CURRENT_DATE - 5, id
FROM plat where nom = 'Soupe chinoise';
INSERT INTO plat_du_jour (date_jour, id_plat)
SELECT CURRENT_DATE - 6, id
FROM plat where nom = 'Romazava';

INSERT INTO plat (nom, prix, id_categorie) VALUES
('TEST', 0,1);
INSERT INTO plat (nom, prix, id_categorie) VALUES
('Romazava', 1000,1);