-- Active: 1764327171931@@127.0.0.1@5432@gargote


ALTER TABLE plat ADD IF NOT EXISTS description VARCHAR(255) ;
ALTER TABLE plat ADD IF NOT EXISTS disponible BOOLEAN NOT NULL DEFAULT TRUE;

ALTER TABLE plat
ADD CONSTRAINT chk_prix_plat CHECK (prix > 0);

ALTER TABLE plat
ADD CONSTRAINT chk_unique_nom_plat UNIQUE (nom);

CREATE TABLE IF NOT EXISTS plat_du_jour (
    date_jour DATE PRIMARY KEY,
    id_plat INT REFERENCES plat(id)
);