SYSTEM clear;

DROP TABLE IF EXISTS Directores;
DROP TABLE IF EXISTS ActoresPeliculas;
DROP TABLE IF EXISTS Peliculas;
DROP TABLE IF EXISTS Actores;

CREATE TABLE Peliculas(
    ID_peliculas INT ,
    titulo VARCHAR(50),
    ID_director INT NOT NULL,
    PRIMARY KEY(ID_peliculas),
    UNIQUE (ID_peliculas, titulo)
);

CREATE INDEX IndiceDirectores ON Peliculas(ID_director);

CREATE TABLE Directores(
    ID_director INT UNIQUE,
    edad INT CHECK (edad > 0 AND edad <= 120),
    nombre VARCHAR(50) NOT NULL,
    PRIMARY KEY(ID_director),
    FOREIGN KEY(ID_director) REFERENCES Peliculas(ID_director)
);

CREATE TABLE Actores(
    ID_actor INT UNIQUE,
    edad INT CHECK (edad > 0 AND edad <= 120),
    nombre VARCHAR(50) NOT NULL ,
    PRIMARY KEY(ID_actor)
);

/*CREATE INDEX IndiceActores ON Actores(ID_actor);
CREATE INDEX IndicePeliculas ON Peliculas(ID_peliculas);*/

CREATE TABLE ActoresPeliculas(
    ID_actor INT,
    ID_peliculas INT,
    PRIMARY KEY (ID_actor, ID_peliculas),
    FOREIGN KEY (ID_actor) REFERENCES Actores (ID_actor),
    FOREIGN KEY (ID_peliculas) REFERENCES Peliculas (ID_peliculas)
);

show tables;

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

INSERT INTO Peliculas (ID_peliculas, titulo, ID_director) VALUES
    (0172495, 'Gladiator', 631),
    (0371746, 'Iron Man', 939),
    (6320628, 'SpiderMan', 939),
    (4154796, 'Los vengadores: Endgame', 939),
    (816692,  'Interstellar', 4240),
    (76759,   'Star Wars: A new hope', 184),
    (3659388, 'The Martian', 631),
    (123456, 'Rodolfo en la ciudad', 631);

INSERT INTO Directores (nombre, ID_director, edad) VALUES
    ('Ridley Scott', 631, 83),
    ('Marvel - Hermanos Russo', 939, 85),
    ('Christopher Nolan', 4240, 50),
    ('George Lucas', 184, 75);

INSERT INTO ActoresPeliculas (ID_actor, ID_peliculas) VALUES
    (128,0172495),(375,0371746),(375,4154796),
    (618,6320628),(618,4154796),(569,0371746),
    (569,4154796),(190,816692),(354,816692),
    (434,76759),(402,76759),(148,76759),(354,3659388);




SELECT * FROM Peliculas;
SELECT * FROM Actores;   
SELECT * FROM Directores;
SELECT * FROM ActoresPeliculas;

/*******************Busca los actores de la pelicula Star Wars************************/

SELECT 'Actores Star Wars';
SELECT Actores.nombre, Peliculas.titulo
FROM Actores
JOIN ActoresPeliculas ON Actores.ID_actor = ActoresPeliculas.ID_actor
JOIN Peliculas ON Peliculas.ID_peliculas = ActoresPeliculas.ID_peliculas
WHERE Peliculas.titulo = 'Star Wars: A new hope'
ORDER BY Actores.nombre;

/*************************************************************************************/




/****************Busca los actores de más de 50 años***********************/

SELECT * FROM Actores WHERE edad>50 ORDER BY Actores.edad;

/**************************************************************************/





/*****************Todas las peliculas que dirigió un director****************************/

SELECT Directores.nombre, COUNT(Peliculas.titulo) AS NumeroPeliculas FROM Peliculas
JOIN Directores ON Directores.ID_director = Peliculas.ID_director
GROUP BY Directores.nombre;

/***************************************************************************************/


/*************************Busca los actores que no participen en ninguna pelicula***************************/
SELECT * FROM Actores WHERE ID_actor NOT IN (SELECT ID_actor FROM ActoresPeliculas);

/*************************************************************************************************************/



SELECT ID_actor FROM Actores


