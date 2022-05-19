/*Ejercicio 10*/

CREATE USER 'random1'@'localhost' IDENTIFIED by 'random';
CREATE USER 'random2'@'localhost' IDENTIFIED by 'random';

GRANT SELECT ON practicas.VistaEJ6 TO 'random1'@'localhost';
GRANT SELECT ON practicas.VistaEJ7 TO 'random1'@'localhost';
GRANT SELECT ON practicas.VistaEJ8 TO 'random1'@'localhost';

GRANT SELECT ON practicas.VistaEJ6 TO 'random2'@'localhost';
GRANT SELECT ON practicas.VistaEJ7 TO 'random2'@'localhost';
GRANT SELECT ON practicas.VistaEJ8 TO 'random2'@'localhost';

FLUSH PRIVILEGES;