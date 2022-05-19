SYSTEM clear;

DROP TABLE IF EXISTS Directores;
DROP TABLE IF EXISTS ActoresPeliculas;
DROP TABLE IF EXISTS Peliculas;
DROP TABLE IF EXISTS Actores;


CREATE TABLE Peliculas(
    ID_pelicula INT ,
    titulo VARCHAR(50),
    ID_director INT NOT NULL,
    nacionalidad VARCHAR(100) DEFAULT "Estadounidense",
    ano INT,
    PRIMARY KEY(ID_pelicula),
    UNIQUE (ID_pelicula, titulo),
    fecha_creacion DATETIME DEFAULT NOW()
);

CREATE INDEX IndiceDirectores ON Peliculas(ID_director);

CREATE TABLE Directores(
    ID_director INT UNIQUE,
    edad INT CHECK (edad > 0 AND edad <= 120),
    nombre VARCHAR(50) NOT NULL,
    nacionalidad VARCHAR(100) DEFAULT "Estadounidense",
    PRIMARY KEY(ID_director),
    FOREIGN KEY(ID_director) REFERENCES Peliculas(ID_director),
    fecha_creacion DATETIME DEFAULT NOW()
);

CREATE TABLE Actores(
    ID_actor INT UNIQUE,
    edad INT CHECK (edad > 0 AND edad <= 120),
    nombre VARCHAR(50) NOT NULL ,
    nacionalidad VARCHAR(100) DEFAULT "Estadounidense",
    PRIMARY KEY(ID_actor),
    fecha_creacion DATETIME DEFAULT NOW()
);

/*CREATE INDEX IndiceActores ON Actores(ID_actor);
CREATE INDEX IndicePeliculas ON Peliculas(ID_pelicula);*/

CREATE TABLE ActoresPeliculas(
    ID_actor INT,
    ID_pelicula INT,
    PRIMARY KEY (ID_actor, ID_pelicula),
    FOREIGN KEY (ID_actor) REFERENCES Actores (ID_actor),
    FOREIGN KEY (ID_pelicula) REFERENCES Peliculas (ID_pelicula)
);


INSERT INTO Actores (nombre,ID_actor, edad) VALUES
    ('Russell Crowe', 128, 56),
    ('Robert Downey Jr', 375, 55),
    ('Tom Holland', 618, 24),
    ('Gwyneth Paltrow', 569, 48),
    ('Matthew McConaughey', 190, 52),
    ('Matt Damon', 354, 51),
    ('Mark Hamill', 434, 70),
    ('Carrie Fisher', 402, 60),
    ('Harrison Ford', 148, 79),
    ('Hayden Christensen', 789, 50);

INSERT INTO Peliculas (ID_pelicula, titulo, ID_director, ano) VALUES
    (0172495, 'Gladiator', 631, 2001),
    (0371746, 'Iron Man', 939, 1997),
    (6320628, 'SpiderMan', 939, 1999),
    (4154796, 'Los vengadores: Endgame', 939, 2019),
    (816692,  'Interstellar', 4240, 2008),
    (76759,   'Star Wars: A new hope', 184, 1986),
    (3659388, 'The Martian', 631, 1990),
    (123456, 'Rodolfo en la ciudad', 631, 2042);

INSERT INTO Directores (nombre, ID_director, edad) VALUES
    ('Ridley Scott', 631, 83),
    ('Marvel - Hermanos Russo', 939, 85),
    ('Christopher Nolan', 4240, 50),
    ('George Lucas', 184, 75);

INSERT INTO ActoresPeliculas (ID_actor, ID_pelicula) VALUES
    (128,0172495),(375,0371746),(375,4154796),
    (618,6320628),(618,4154796),(569,0371746),
    (569,4154796),(190,816692),(354,816692),
    (434,76759),(402,76759),(148,76759),(354,3659388);

/*Ejercicio 1*/
ALTER TABLE Actores ADD fotografia BLOB;
ALTER TABLE Directores ADD fotografia BLOB;

UPDATE Actores SET fotografia = LOAD_FILE('/var/lib/mysql-files/gladiator.png') WHERE ID_actor=128;
SELECT * FROM Actores;

UPDATE Directores SET fotografia = LOAD_FILE('/var/lib/mysql-files/gladiator.png') WHERE ID_director =631;
SELECT * FROM Directores;

/*Ejercicio 2*/
ALTER TABLE Peliculas ADD valoracion FLOAT(3,2);

UPDATE Peliculas SET valoracion = 0.59 WHERE titulo="Gladiator";
UPDATE Peliculas SET valoracion = 8.92 WHERE titulo="SpiderMan";

SELECT * FROM Peliculas;

/*Ejercicio 3*/
/*nacionalidad VARCHAR(100) nacionalidad VARCHAR(100) DEFAULT "Estadounidense" a cada CREATE TABLE*/

/*Ejercicio 4*/
/*fecha_creacion DATETIME DEFAULT NOW() en cada CREATE TABLE*/

/*Ejercicio 5*/

/*Ejercicio 6*/
DROP VIEW VistaEJ6;

CREATE VIEW VistaEJ6 AS SELECT titulo, nacionalidad FROM Peliculas;
SELECT * FROM VistaEJ6;
SELECT titulo FROM VistaEJ6;

/*Ejercicio 7*/
DROP VIEW VistaEJ7;

CREATE VIEW VistaEJ7 AS SELECT Peliculas.titulo, Peliculas.nacionalidad, Directores.ID_director, Actores.ID_actor FROM Peliculas
    JOIN Directores ON Directores.ID_director = Peliculas.ID_director
    JOIN ActoresPeliculas ON Peliculas.ID_pelicula = ActoresPeliculas.ID_pelicula
    JOIN Actores ON Actores.ID_actor = ActoresPeliculas.ID_actor;

SELECT * FROM VistaEJ7;

/*Ejercicio 8*/
DROP VIEW VistaEJ8;

CREATE VIEW VistaEJ8 AS SELECT * FROM Peliculas WHERE Peliculas.ano >1900 AND Peliculas.ano < 2000;

SELECT * FROM VistaEJ8;

/*Ejercicio 9*/
/*
    NO ES POSIBLE OPERAR (INSERT, DELETE, UPDATE) CUANDO UNA VISTA CONTIENE :
        Añaden funciones como MIN, MAX, SUM, AVG y COUNT
        DISTINCT
        GROUP BY    
        HAVING
        UNION o UNION ALL
        Left JOIN o right
        
*/





