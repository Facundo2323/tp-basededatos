USE GD2C2025
GO

-- Dimensiones

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
               WHERE TABLE_SCHEMA = 'KEY_GROUP' AND TABLE_NAME = 'BI_DIM_Tiempo')
CREATE TABLE KEY_GROUP.BI_DIM_Tiempo (
    DIM_Tiempo_id INT IDENTITY(1,1) PRIMARY KEY,
    Anio INT,
    Cuatrimestre INT,
    Mes INT
);

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
               WHERE TABLE_SCHEMA = 'KEY_GROUP' AND TABLE_NAME = 'BI_DIM_Sede')
CREATE TABLE KEY_GROUP.BI_DIM_Sede (
    DIM_Sede_id INT IDENTITY(1,1) PRIMARY KEY, 
    Nombre NVARCHAR(255) NOT NULL UNIQUE,
);

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
               WHERE TABLE_SCHEMA = 'KEY_GROUP' AND TABLE_NAME = 'BI_DIM_Rango_Etario_Alumno')
CREATE TABLE KEY_GROUP.BI_DIM_Rango_Etario_Alumno (
    DIM_Rango_Etario_Alumno_id INT IDENTITY(1,1) PRIMARY KEY, 
    Descripcion NVARCHAR(255) NOT NULL UNIQUE, -- menor de 25, de 25 a 35, etc.
    Edad_desde INT NULL, 
    Edad_hasta INT NULL  
);

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
               WHERE TABLE_SCHEMA = 'KEY_GROUP' AND TABLE_NAME = 'BI_DIM_Rango_Etario_Profesor')
CREATE TABLE KEY_GROUP.BI_DIM_Rango_Etario_Profesor (
    DIM_Rango_Etario_Profesor_id INT IDENTITY(1,1) PRIMARY KEY, 
    Descripcion NVARCHAR(255) NOT NULL UNIQUE, -- menor de 25, de 25 a 35, etc.
    Edad_desde INT NULL, 
    Edad_hasta INT NULL  
);









--Categorías y Turnos más solicitados:
CREATE VIEW Categorias_Turnos
    (categoría, turno)
AS SELECT ct.descripcion, t.descripcion
    FROM cursos cr
    JOIN categorias ct  ON cr.id_categoria = ct.id_categoria
    JOIN turnos t       ON cr.tipo_turno = t.tipo_turno

--Tasa de rechazo de inscripciones:

CREATE VIEW Tasa_Reachazos_Inscr (tasa_mes, mes, sede)
AS
 SELECT (SUM(SELECT COUNT(*) FROM Inscripcion WHERE = sede )/SUM(SELECT COUNT(*) FROM ) * 100) AS promedio_mes, sede 
 FROM Inscripcion ins
 GROUP BY mes, sede
 ORDER BY mes, sede

--Comparación de desmpeño de cursada por sede:

CREATE VIEW comp_desempeño (porc_aprobado, sede, año)
AS
 SELECT (SUM()/SUM() * 100) AS porc_aprobado, sede, año
 FROM 
 GROUP BY sede, año
 ORDER BY sede, año

--Tiempo promedio de finalización de curso:

CREATE VIEW promedio_finalizacion_curso(prom_tiempo, curso, año)
AS
 SELECT (SUM(SELECT - SELECT)/SELECT COUNT(*)) AS prom_tiempo, curso, año
 FROM 
 GROUP BY curso, año
 ORDER BY curso, año

--Nota promedio de finales:

CREATE VIEW promedio_finales (prom_notas, alumno_rango_etario, Curso_Categoria)
AS
 SELECT (SELECT SUM() /SELECT COUNT()) AS prom_notas, alumno_rango_etario, Curso_Categoria
 FROM
 GROUP BY alumno_rango_etario, Curso_Categoria
 ORDER BY alumno_rango_etario, Curso_Categoria

--Tasa de ausentismo finales:

CREATE VIEW ausentismo_finales (porc_ausent, semestre, sede)
AS
 SELECT (SELECT COUNT() / SELECT COUNT () * 100) AS porc_ausent, semestre, sede
 FROM
 GROUP BY semestre, sede
 ORDER BY semestre, sede

--Desvío de pagos:

CREATE VIEW Desvio_pagos(porc_pagos, semestre)
AS
 SELECT ( SELECT COUNT(*) / SELECT COUNT(*) * 100) AS porc_pagos, semestre
 FROM
 GROUP BY semestre
 ORDER BY semestre

--Tasa de Morosidad Financiera mensual:

CREATE VIEW Morosidad_financiera_mensual (Tasa_Morosidad, monto_adeudado, mes)
AS
 SELECT (SELECT COUNT(*)/ SELECT SUM(*)) AS Tasa_Morosidad, monto_adeudado, mes
 FROM
 GROUP BY mes
 ORDER BY mes

--Ingresos por categoría de cursos:

CREATE VIEW ingresos_categoría_cursos (categoria_curso, ingresos, sede, año)
AS
 SELECT TOP 3 categoria_curso, (SELECT SUM(*)) ingresos, sede, año
 FROM
 GROUP BY
 ORDER BY categoria_curso, año, sede

--Índice de satisfacción:

CREATE VIEW indice_satisfaccion (satisfaccion_anual, profesor_rango_etario, sede)
AS
 SELECT ( ((%satisfechos - %insatisfechos) +100)/2) AS satisfaccion_anual
 FROM
 GROUP BY profesor_rango_etario, sede
 ORDER BY profesor_rango_etario, sede