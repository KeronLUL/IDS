-- Projekt 2. část - SQL skript pro vytvoření základních objektů schématu
-- Autor: Karel Norek - xnorek01
-- Autor: Martin Kneslík - xknesl02

DROP TABLE vrazdy;
DROP TABLE don_schuzka;
DROP TABLE uzemi;
DROP TABLE clen;
DROP TABLE kriminalni_cinnost;
DROP TABLE don;
DROP TABLE aliance;
DROP TABLE schuzka;

CREATE TABLE schuzka (
    poradi      INT GENERATED AS IDENTITY PRIMARY KEY,
    cislo_domu  INT NOT NULL CHECK (cislo_domu >= 0),
    ulice       VARCHAR(50) NOT NULL,
    mesto       VARCHAR(50) NOT NULL,
    cas         TIMESTAMP NOT NULL
);

CREATE TABLE aliance (
    id          INT GENERATED AS IDENTITY PRIMARY KEY,
    jmeno       VARCHAR(50) NOT NULL,
    doba_trvani INT NOT NULL CHECK (doba_trvani >= 0)
);

CREATE TABLE don (
    id          INT GENERATED AS IDENTITY PRIMARY KEY,
    jmeno       VARCHAR(50) NOT NULL,
    vek         INT NOT NULL CHECK (vek >= 0),
    doba_funkce INT NOT NULL CHECK (doba_funkce >= 0),
    id_aliance  INT,
    CONSTRAINT don_fk
        FOREIGN KEY (id_aliance)
        REFERENCES aliance (id) ON DELETE CASCADE
);

CREATE TABLE kriminalni_cinnost (
    id          INT GENERATED AS IDENTITY PRIMARY KEY,
    typ         VARCHAR(50) NOT NULL,
    unik_jmeno  VARCHAR(50) NOT NULL,
    datum       DATE NOT NULL,
    delka       INT NOT NULL CHECK (delka >= 0),
    don         INT,
    id_aliance  INT,
    CONSTRAINT osoba_nebo_aliance
        CHECK ((don IS NOT NULL) OR (id_aliance IS NOT NULL)),
    CONSTRAINT kriminalni_cinnost_fk
        FOREIGN KEY (don)
        REFERENCES don (id) ON DELETE CASCADE,
        FOREIGN KEY (id_aliance)
        REFERENCES aliance (id) ON DELETE CASCADE
);

CREATE TABLE clen (
    id          INT GENERATED AS IDENTITY PRIMARY KEY,
    jmeno       VARCHAR(50) NOT NULL,
    vek         INT NOT NULL CHECK (vek >= 0),
    hodnost     VARCHAR(50) NOT NULL CHECK(hodnost IN ('Radny clen', 'Zkuseny clen')),
    id_cinnosti INT,
    don         INT NOT NULL,
    CONSTRAINT osoba_fk
        FOREIGN KEY (id_cinnosti)
        REFERENCES kriminalni_cinnost (id) ON DELETE CASCADE,
        FOREIGN KEY (don)
        REFERENCES don (id) ON DELETE CASCADE
);

CREATE TABLE uzemi (
    id          INT GENERATED AS IDENTITY PRIMARY KEY,
    gps_lat     FLOAT NOT NULL CHECK (gps_lat >= -90 AND gps_lat <= 90),
    gps_lng     FLOAT NOT NULL CHECK (gps_lng >= -180 AND gps_lng <= 180),
    ulice       VARCHAR(50) NOT NULL,
    mesto       VARCHAR(50) NOT NULL,
    rozloha     INT NOT NULL, CHECK (rozloha >= 0),
    komu_patri  VARCHAR(50),
    cinnost  INT,
    CONSTRAINT uzemi_fk
        FOREIGN KEY (cinnost)
        REFERENCES kriminalni_cinnost (id) ON DELETE CASCADE
);

CREATE table don_schuzka(
    don             INT NOT NULL,
    poradi_schuzky  INT NOT NULL,
    CONSTRAINT schuzka_fk
        FOREIGN KEY (don)
        REFERENCES don (id) ON DELETE CASCADE,
        FOREIGN KEY (poradi_schuzky)
        REFERENCES schuzka (poradi) ON DELETE CASCADE
);

CREATE TABLE vrazdy (
    id           INT GENERATED AS IDENTITY PRIMARY KEY,
    cil          VARCHAR(50) NOT NULL,
    vrah         INT NOT NULL,
    objednavatel INT NOT NULL,
    id_uzemi     INT NOT NULL,
    CONSTRAINT vrazdy_fk
        FOREIGN KEY (vrah)
        REFERENCES clen (id) ON DELETE CASCADE,
        FOREIGN KEY (objednavatel)
        REFERENCES don (id) ON DELETE CASCADE,
        FOREIGN KEY (id_uzemi)
        REFERENCES uzemi (id) ON DELETE CASCADE
);

INSERT INTO schuzka (cislo_domu, ulice, mesto, cas)
VALUES (157, '2nd street', 'New York', timestamp '2021-06-06 15:00:00');
INSERT INTO schuzka (cislo_domu, ulice, mesto, cas)
VALUES (142, '1nd street', 'New York', timestamp '2021-07-06 22:00:00');
INSERT INTO schuzka (cislo_domu, ulice, mesto, cas)
VALUES (51, 'Elm street', 'New York', timestamp '2021-10-10 8:00:00');

INSERT INTO aliance (jmeno, doba_trvani)
VALUES ('Salieriho aliance', 15);
INSERT INTO aliance (jmeno, doba_trvani)
VALUES ('Morrelo-Clemente', 3);

INSERT INTO don (jmeno, vek, doba_funkce, id_aliance)
VALUES ('Ennio Salieri', 65, 12, 1);
INSERT INTO don (jmeno, vek, doba_funkce, id_aliance)
VALUES ('Marcu Morello', 63, 11, 2);
INSERT INTO don (jmeno, vek, doba_funkce, id_aliance)
VALUES ('Alberto Clemente', 59, 6, 2);
INSERT INTO don (jmeno, vek, doba_funkce, id_aliance)
VALUES ('Frank Vinci', 78, 20, 1);
INSERT INTO don (jmeno, vek, doba_funkce, id_aliance)
VALUES ('Carlo Falcone', 55, 3, NULL);

INSERT INTO kriminalni_cinnost (typ, unik_jmeno, datum, delka, don, id_aliance)
VALUES ('Kradez', 'Kradez diamantu', date '2021-03-04', 1, 1, NULL);
INSERT INTO kriminalni_cinnost (typ, unik_jmeno, datum, delka, don, id_aliance)
VALUES ('Vypalne', 'Vyber vypalneho', date '2021-01-01', 2, 2, NULL);
INSERT INTO kriminalni_cinnost (typ, unik_jmeno, datum, delka, don, id_aliance)
VALUES ('Ochrana', 'Ochrana Dona Salieriho', date '2021-01-05', 10, NULL, 1);
INSERT INTO kriminalni_cinnost (typ, unik_jmeno, datum, delka, don, id_aliance)
VALUES ('Dovoz', 'Dovoz ukradene whiskey', date '2021-07-04', 7, 3, NULL);

INSERT INTO clen (jmeno, vek, hodnost, id_cinnosti, don)
VALUES ('Sam Trapani', 31, 'Zkuseny clen', NULL, 1);
INSERT INTO clen (jmeno, vek, hodnost, id_cinnosti, don)
VALUES ('Paulie Lombardo', 40, 'Radny clen', 1, 1);
INSERT INTO clen (jmeno, vek, hodnost, id_cinnosti, don)
VALUES ('Thomas Angelo', 26, 'Radny clen', 3, 1);
INSERT INTO clen (jmeno, vek, hodnost, id_cinnosti, don)
VALUES ('Leo Galante', 60, 'Zkuseny clen', 3, 4);
INSERT INTO clen (jmeno, vek, hodnost, id_cinnosti, don)
VALUES ('Luca Gurino', 45, 'Radny clen', 4, 3);
INSERT INTO clen (jmeno, vek, hodnost, id_cinnosti, don)
VALUES ('Harry Marsden', 32, 'Radny clen', 4, 3);
INSERT INTO clen (jmeno, vek, hodnost, id_cinnosti, don)
VALUES ('Eddie Scarpa', 41, 'Radny clen', 2, 2);
INSERT INTO clen (jmeno, vek, hodnost, id_cinnosti, don)
VALUES ('Mike Bruski', 52, 'Radny clen', 3, 4);

INSERT INTO uzemi (gps_lat, gps_lng, ulice, mesto, rozloha, komu_patri, cinnost)
VALUES (25.554, 14.445, '1st Street', 'New York', 25, NULL, 1);
INSERT INTO uzemi (gps_lat, gps_lng, ulice, mesto, rozloha, komu_patri, cinnost)
VALUES (31.254, -16.45, 'Long Island', 'New York', 150, 'Morello', 2);
INSERT INTO uzemi (gps_lat, gps_lng, ulice, mesto, rozloha, komu_patri, cinnost)
VALUES (25.54, 52.552, 'Little Italy', 'New York', 200, 'Salieri', 3);
INSERT INTO uzemi (gps_lat, gps_lng, ulice, mesto, rozloha, komu_patri, cinnost)
VALUES (15.4, -52.552, 'Donk street', 'New York', 45, 'Alberto Clemente', 4);

INSERT INTO don_schuzka (don, poradi_schuzky)
VALUES (1, 1);
INSERT INTO don_schuzka (don, poradi_schuzky)
VALUES (2, 1);
INSERT INTO don_schuzka (don, poradi_schuzky)
VALUES (1, 2);
INSERT INTO don_schuzka (don, poradi_schuzky)
VALUES (3, 2);
INSERT INTO don_schuzka (don, poradi_schuzky)
VALUES (3, 3);
INSERT INTO don_schuzka (don, poradi_schuzky)
VALUES (4, 3);
INSERT INTO don_schuzka (don, poradi_schuzky)
VALUES (5, 3);

INSERT INTO vrazdy (cil, vrah, objednavatel, id_uzemi)
VALUES ('Thomas Angelo', 3, 1, 3);
INSERT INTO vrazdy (cil, vrah, objednavatel, id_uzemi)
VALUES ('Luca Gurino', 4, 5, 1);
