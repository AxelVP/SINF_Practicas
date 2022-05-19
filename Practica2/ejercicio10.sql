SYSTEM clear;

\. UnivDDL.sql
\. UnivInsertPeque.sql

/*1*/
SELECT * FROM docente;

/*2*/
SELECT nombre FROM docente WHERE docente.nombre_dpto = "Ingeniería Telemática";

/*3*/
SELECT nombre FROM docente WHERE docente.nombre_dpto = "Ingeniería Telemática" AND docente.salario > 70000;

/*4*/
SELECT docente.ID, docente.nombre, docente.salario, docente.nombre_dpto, departamento.edificio, departamento.presupuesto FROM docente JOIN departamento ON departamento.nombre_dpto = docente.nombre_dpto;

/*5*/
SELECT nombre FROM materia WHERE materia.nombre_dpto = "Ingeniería Telemática" AND materia.creditos = 3;

/*6*/
SELECT alumno_3ciclo.ID, materia.id_materia, materia.nombre FROM alumno_3ciclo JOIN cursa ON alumno_3ciclo.ID = cursa.ID 
JOIN materia ON cursa.id_materia = materia.id_materia WHERE alumno_3ciclo.ID = "12345";

/*7*/
SELECT nombre FROM docente UNION SELECT nombre FROM alumno_3ciclo ORDER BY nombre;

/*8 revisar*/
SELECT nombre FROM docente UNION SELECT nombre, tot_creditos FROM alumno_3ciclo ORDER BY nombre;

/*9*/


/*10*/
SELECT DISTINCT alumno_3ciclo.nombre FROM alumno_3ciclo JOIN cursa ON cursa.ID = alumno_3ciclo.ID
JOIN materia ON materia.id_materia = cursa.id_materia WHERE materia.nombre_dpto ="Ingeniería Telemática";

/*11*/
/*SELECT docente.ID FROM docente JOIN imparte ON imparte.ID != docente.ID;*/

SELECT docente.ID FROM docente WHERE docente.ID NOT IN (SELECT imparte.ID FROM imparte);

/*12*/
SELECT docente.nombre FROM docente WHERE docente.ID NOT IN (SELECT imparte.ID FROM imparte);

/*13*/
/*SELECT * FROM grupo WHERE */

/*14*/
SELECT consulta.id_materia, consulta.id_grupo, consulta.cuenta AS max FROM (

    SELECT cursa.id_materia, cursa.id_grupo, COUNT(*) AS cuenta FROM cursa GROUP BY cursa.id_materia, cursa.id_grupo    
)consulta

/*15*/


/*16*/
SELECT grupo.id_materia, grupo.id_grupo, COUNT(cursa.ID) AS Consulta16 FROM cursa, grupo WHERE cursa.id_materia = grupo.id_materia AND cursa.id_grupo = grupo.id_grupo
AND cursa.cuatrimestre = grupo.cuatrimestre AND cursa.anho = grupo.anho
GROUP BY cursa.id_materia, cursa.id_grupo, cursa.cuatrimestre, cursa.anho ORDER BY Consulta16 DESC LIMIT 10
/*NO SÉ QUE COJONES ESTÁ MAL ESTOY HASTA LOS HUEVOS DE ESTA PRÁCTICA DE MIERDA : AYUDA*/


