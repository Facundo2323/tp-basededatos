USE GD2C2025
GO

--Categorías y Turnos más solicitados:
CREATE VIEW Categorias_Turnos
    (categoría, turno)
AS SELECT ct.descripcion, t.descripcion
    FROM cursos cr
    JOIN categorias ct  ON cr.id_categoria = ct.id_categoria
    JOIN turnos t       ON cr.tipo_turno = t.tipo_turno

--Tasa de rechazo de inscripciones:

CREATE VIEW Tasa_Reachazos_Inscr (tasa_mes, sede)
AS
SELECT (SUM(SELECT COUNT(*) FROM Inscripcion WHERE = sede )/SUM(SELECT COUNT(*) FROM ) * 100) AS promedio_mes,  
AS sede 
  FROM Inscripcion ins

--Comparación de desmpeño de cursada por sede:

CREATE VIEW ()
AS
SELECT FROM

--Tiempo promedio de finalización de curso:

CREATE VIEW ()
AS
SELECT FROM

--Nota promedio de finales:

CREATE VIEW ()
AS
SELECT FROM

--Tasa de ausentismo finales:

CREATE VIEW ()
AS
SELECT FROM

--Desvío de pagos:

CREATE VIEW ()
AS
SELECT FROM

--Tasa de Morosidad Financiera mensual:

CREATE VIEW ()
AS
SELECT FROM

--Ingresos por categoría de cursos:

CREATE VIEW ()
AS
SELECT FROM

--Índice de satisfacción:

CREATE VIEW ()
AS
SELECT FROM