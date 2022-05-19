SYSTEM clear;

DECLARE cuenta_contar_directores INT;
SET @cuenta_contar_directores = 0;


DROP TABLE IF EXISTS Directores;
DROP TABLE IF EXISTS ActoresPeliculas;
DROP TABLE IF EXISTS Peliculas;
DROP TABLE IF EXISTS Actores;

DROP PROCEDURE IF EXISTS listar_directores_peliculas;
DROP PROCEDURE IF EXISTS contar_directores;

CREATE TABLE Peliculas(
    ID_peliculas INT ,
    titulo VARCHAR(50),
    ID_director INT NOT NULL,
    nacionalidad VARCHAR(100),
    PRIMARY KEY(ID_peliculas),
    UNIQUE (ID_peliculas, titulo)
);

CREATE INDEX IndiceDirectores ON Peliculas(ID_director);

CREATE TABLE Directores(
    ID_director INT UNIQUE,
    edad INT CHECK (edad > 0 AND edad <= 120),
    nombre VARCHAR(50) NOT NULL,
    nacionalidad VARCHAR(100),
    PRIMARY KEY(ID_director),
    FOREIGN KEY(ID_director) REFERENCES Peliculas(ID_director)
);

CREATE TABLE Actores(
    ID_actor INT UNIQUE,
    edad INT CHECK (edad > 0 AND edad <= 120),
    nombre VARCHAR(50) NOT NULL ,
    nacionalidad VARCHAR(100),
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


INSERT INTO Actores (nombre,ID_actor, edad, nacionalidad) VALUES
    ('Russell Crowe', 128, 56, Francia),
    ('Robert Downey Jr', 375, 55, España),
    ('Tom Holland', 618, 24, USA ),
    ('Gwyneth Paltrow', 569, 48, Inglaterra),
    ('Matthew McConaughey', 190, 52, Francia),
    ('Matt Damon', 354, 51, España),
    ('Mark Hamill', 434, 70, España),
    ('Carrie Fisher', 402, 60, USA),
    ('Harrison Ford', 148, 79, USA),
    ('Hayden Christensen', 789, 50,USA);

INSERT INTO Peliculas (ID_peliculas, titulo, ID_director, nacionalidad) VALUES
    (0172495, 'Gladiator', 631, USA),
    (0371746, 'Iron Man', 939, USA),
    (6320628, 'SpiderMan', 939, España),
    (4154796, 'Los vengadores: Endgame', 939, España),
    (816692,  'Interstellar', 4240, España),
    (76759,   'Star Wars: A new hope', 184, España),
    (3659388, 'The Martian', 631, Inglaterra),
    (123456, 'Rodolfo en la ciudad', 631, Inglaterra);

INSERT INTO Directores (nombre, ID_director, edad, nacionalidad) VALUES
    ('Ridley Scott', 631, 83, Inglaterra),
    ('Marvel - Hermanos Russo', 939, 85, Inglaterra),
    ('Christopher Nolan', 4240, 50, USA),
    ('George Lucas', 184, 75, España);

INSERT INTO ActoresPeliculas (ID_actor, ID_peliculas) VALUES
    (128,0172495),(375,0371746),(375,4154796),
    (618,6320628),(618,4154796),(569,0371746),
    (569,4154796),(190,816692),(354,816692),
    (434,76759),(402,76759),(148,76759),(354,3659388);

/*Ejercicio 1*/

DELIMITER //

CREATE PROCEDURE listar_directores_peliculas()
BEGIN  
    SELECT Peliculas.titulo, Directores.nombre FROM Peliculas JOIN Directores ON Peliculas.id_director = Directores.id_director;
END //
DELIMITER ;

CALL listar_directores_peliculas();


/*Ejercicio 2 y 3*/

DELIMITER 

CREATE PROCEDURE contar_directores()
BEGIN   
    DECLARE contador INT;

    CREATE TABLE IF NOT EXISTS cuentaDirectores(
        id INT NOT NULL AUTO_INCREMENT,
        hora TIMESTAMP,
        cuenta INT,
        PRIMARY KEY(id)
    );

    SELECT COUNT(Directores.nombre) INTO @contador FROM Directores;

    INSERT INTO cuentaDirectores(cuenta, hora) VALUES (@contador, CURRENT_TIMESTAMP());

    SELECT * FROM cuentaDirectores;

    SET @cuenta_contar_directores = @cuenta_contar_directores +1;

END 

DELIMITER ;

CALL contar_directores();
SELECT @cuenta_contar_directores;



/*Ejercicio 4*/

DELIMITER //
CREATE PROCEDURE  consultarPorNacionalidad(IN nacionalidadIN VARCHAR(100))
BEGIN 

    SELECT * FROM Peliculas WHERE Peliculas.nacionalidad = nacionalidadIN;
    SELECT * FROM Directores WHERE Directores.nacionalidad = nacionalidadIN;
    SELECT * FROM Actores WHERE Actores.nacionalidad = nacionalidadIN;

END //
DELIMITER ;

CALL consultarPorNacionalidad("USA");

/*Ejercicio 5*/

DELIMITER //
CREATE PROCEDURE peliculasPorNacionalidad(IN nacionalidadIN VARCHAR(100), OUT numPeliculas INT)
BEGIN   
    SELECT COUNT(Peliculas.nacionalidad) INTO numPeliculas FROM Peliculas WHERE Peliculas.nacionalidad = nacionalidadIN;
END //
DELIMITER ;

CALL peliculasPorNacionalidad("Inglaterra", @numeroPeliculas);
SELECT @umeroPeliculas;

/*Ejercicio 6*/

DELIMITER //
DROP PROCEDURE IF EXISTS ponerEnMayusculas //
CREATE PROCEDURE ponerEnMayusculas(IN cadena VARCHAR(100), OUT cadenaMayus VARCHAR(100))
BEGIN 
    SET cadenaMayus = UPPER(cadena);
END 
//
DELIMITER ;

CALL ponerEnMayusuculas('Cadena para convertir', @cadenaMayus);
SELECT @cadenaMayus;

/*Ejercicio 7*/

DELIMITER //
DROP PROCEDURE IF EXISTS contar_directores
CREATE PROCEDURE contar_directores()
BEGIN   
    DECLARE numDirectores INT;
    DECLARE fecha DATETIME;
    DECLARE numeroEjecuciones INT DEFAULT 0;

    CREATE TABLE IF NOT EXISTS totalDirectores(
        fecha DATETIME,
        numDirectores INT
    );

    SET fecha = now();
    SELECT COUNT(*) INTO numDirectores FROM Directores;
    IF(numeroEjecuciones IS NULL) THEN 
        SET @numeroEjecuciones = 0;
    END IF;

    SET @numeroEjecuciones = @numeroEjecuciones +1;

    IF(numeroEjecuciones >= 10) THEN    
        DELETE FROM cuentaDirectores ORDER BY cuentaDirectores.hora ASC LIMIT 1;
    END IF;

    INSERT INTO cuentaDirectores(fecha, numDirectores);
    SELECT * FROM cuentaDirectores;
END //
DELIMITER ;
CALL contar_directores();

/*Ejercicio 8*/

DELIMITER //
DROP PROCEDURE IF EXISTS extraer_imbds (IN nacionalidadIN VARCHAR(100))
BEGIN

    DECLARE consultaPeliculas INT;
    DECLARE consultaActores INT;
    DECLARE consultaDirectores INT;

    DELCARE consultaTerminada BOOLEAN DEFAULT false;

    DECLARE cursorPeliculas CURSOR FOR SELECT Peliculas.ID_peliculas FROM Peliculas WHERE Peliculas.nacionalidad = nacionalidadIN;
    DECLARE cursorActores CURSOR FOR SELECT Actores.ID_actor FROM Actores WHERE Actores.nacionalidad = nacionalidadIN;
    DECLARE cursorDirectores CURSOR FOR SELECT Directores.ID_director FROM Directores WHERE Directores.nacionalidad = nacionalidadIN;

    SET @comandoDropTable = CONCAT ("DROP TABLE IF EXISTS ", nacionalidadIN, ";");
    SET @comandoCreateTable = CONCAT ("CREATE TABLE ", nacionalidadIN, " (IMBD INT)");

    SET consultaPeliculas = 0;
    SET consultaActores = 0;
    SET consultaDirectores = 0;

    PREPARE stmt_dropTable FROM @comandoDropTable;
    EXECUTE stmt_dropTable;

    PREPARE stmt_createTable FROM @comandoCreateTable;
    EXECUTE stmt_createTable;

    /*CURSOR PARA LAS PELICULAS*/

    OPEN cursorPeliculas;
    BEGIN  
        DECLARE consultaTerminada BOOLEAN DEFAULT false;
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET consultaTerminada = TRUE;

        buclePeliculas : LOOP

            FETCH cursorPeliculas INTO consultaPeliculas;
            IF consultaTerminada THEN   
                LEAVE buclePeliculas;
            ELSE    
                SET @añadirValor = CONCAT ("INSERT ", nacionalidadIN, " VALUES(",consultaPeliculas,");");
                PREPARE stmt_añadirValorPeliculas FROM @añadirValor;
                EXECUTE stmt_añadirValorPeliculas;
            END IF;
        END LOOP buclePeliculas;
    END;
    CLOSE cursorPeliculas;

    /*CURSOR DE ACTORES*/

    OPEN cursorActores;
    BEGIN 
        DELCARE consultaTerminada BOOLEAN DEFAULT FALSE;
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET consultaTerminada = TRUE;

        bucleActores : LOOP

            FETCH cursorActores INTO consultaActores;
            IF consultaTerminada THEN   
                LEAVE bucleActores;
            ELSE    
                SET @añadirValor = CONCAR ("INSERT ", nacionalidadIN, " VALUES(",consultaActores,");");
                PREPARE stmt_añadirValorActores FROM @añadirValor;
                EXECUTE stmt_añadirValorActores;
            END IF;
        END LOOP bucleActores;
    END;
    CLOSE cursorActores;

    /*CURSOR DE DIRECTORES*/

    OPEN cursorDirectores;
    BEGIN 
        DELCARE consultaTerminada BOOLEAN DEFAULT FALSE;
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET consultaTerminada = TRUE;

        bucleDirectores: LOOP

            FETCH cursorDirectores INTO consultaDirectores;
            IF consultaTerminada THEN
                LEAVE bucleDirectores;
            ELSE    
                SET @añadirValor = CONCAR ("INSERT ", nacionalidadIN, " VALUES(",consultaDirectores,");");
                PREPARE stmt_añadirValorDirectores FROM @añadirValor;
                EXECUTE stmt_añadirValorDirectores;
            END IF;
        END LOOP bucleDirectores;
    END;
    CLOSE cursorDirectores;

END //
DELIMITER ;

CALL extraer_imbds("España");
SELECT * FROM España;

/*Ejercicio 9 y 10*/

DELIMITER //
DROP PROCEDURE IF EXISTS introducir_pelicula;
CREATE PROCEDURE introducir_pelicula(IN ID_peliculaIN INT, IN tituloIN VARCHAR(100), IN ID_directorIN INT, IN nacionalidadIN VARCHAR(100))
BEGIN   

    START TRANSACTION;
        INSERT Peliculas VALUE(ID_peliculaIN, tituloIN, ID_directorIN, nacionalidadIN);
    COMMIT;

END //
DELIMITER ;

CALL introducir_pelicula(123456, "El perfume", 123, "Inglaterra");
SELECT * FROM Peliculas;

/*Ejercicio 11*/

DELIMITER //
DROP TRIGGER IF EXISTS triggerEliminarDirectores //
CREATE TRIGGER triggerEliminarDirectores AFTER DELETE ON Directores FOR EACH ROW
BEGIN

    DECLARE nacionalidadTrigger VARCHAR(100);
    DECLARE ID_directorTrigger INT;

    SELECT Directores.nacionalidad INTO nacionalidadTrigger FROM Directores WHERE Directores.ID_director = old.ID_director;
    SELECT Directores.ID_director INTO ID_directorTrigger FROM Directores WHERE Directores.ID_director = old.ID_director;

    IF(nacionalidadTrigger= "España") THEN
        DELETE FROM ESPAÑA WHERE ESPAÑA.IMBD = ID_directorTrigger;
    END IF;
END//
DELIMITER ;

DELIMITER //
DROP TRIGGER IF EXISTS triggerInsertarDirectores //
CREATE TRIGGER triggerInsertarDirectores AFTER INSERT ON Directores FOR EACH ROW
BEGIN

    DECLARE nacionalidadTrigger VARCHAR(100);
    DECLARE ID_directorTrigger INT;

    SELECT Directores.nacionalidad INTO nacionalidadTrigger FROM Directores WHERE Directores.ID_director = new.ID_director;
    SELECT Directores.ID_director INTO ID_directorTrigger FROM Directores WHERE Directores.ID_director = new.ID_director;

    IF(nacionalidadTrigger= "España") THEN
        INSERT INTO ESPAÑA(IMBD) VALUES (ID_directorTrigger);
    END IF;
END//
DELIMITER ;

INSERT Directores VALUES('Ghandi', 123, 76, España);
DELETE FROM Directores WHERE IMBD = 123;

SELECT * FROM España;





