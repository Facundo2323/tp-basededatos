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
    Nombre NVARCHAR(255) UNIQUE,
);

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
               WHERE TABLE_SCHEMA = 'KEY_GROUP' AND TABLE_NAME = 'BI_DIM_Rango_Etario_Alumno')
CREATE TABLE KEY_GROUP.BI_DIM_Rango_Etario_Alumno (
    DIM_REA_id INT IDENTITY(1,1) PRIMARY KEY, 
    Descripcion NVARCHAR(255) UNIQUE, -- menor de 25, de 25 a 35, etc.
    Edad_desde INT, 
    Edad_hasta INT  
);

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
               WHERE TABLE_SCHEMA = 'KEY_GROUP' AND TABLE_NAME = 'BI_DIM_Rango_Etario_Profesor')
CREATE TABLE KEY_GROUP.BI_DIM_Rango_Etario_Profesor (
    DIM_REP_id INT IDENTITY(1,1) PRIMARY KEY, 
    Descripcion NVARCHAR(255), -- menor de 25, de 25 a 35, etc.
    Edad_desde INT, 
    Edad_hasta INT
);

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
               WHERE TABLE_SCHEMA = 'KEY_GROUP' AND TABLE_NAME = 'BI_DIM_Turno_Curso')
CREATE TABLE KEY_GROUP.BI_DIM_Turno_Curso (
    DIM_Turno_Curso_id INT IDENTITY(1,1) PRIMARY KEY, 
    Turno NVARCHAR(255)  --Mañ/Tar/Noc
);

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
               WHERE TABLE_SCHEMA = 'KEY_GROUP' AND TABLE_NAME = 'BI_DIM_Categoria_Curso')
CREATE TABLE KEY_GROUP.BI_DIM_Categoria_Curso (
    DIM_Categoria_Curso_id INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(255)
);


IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
               WHERE TABLE_SCHEMA = 'KEY_GROUP' AND TABLE_NAME = 'BI_DIM_Medio_de_pago')
CREATE TABLE KEY_GROUP.BI_DIM_Medio_de_pago (
    DIM_Medio_de_pago_id INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(255)
);


IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
               WHERE TABLE_SCHEMA = 'KEY_GROUP' AND TABLE_NAME = 'BI_DIM_Bloques_de_satisfaccion')
CREATE TABLE KEY_GROUP.BI_DIM_Bloques_de_satisfaccion (
    DIM_Bloques_de_satisfaccion_id INT IDENTITY(1,1) PRIMARY KEY,
    Descripcion NVARCHAR(255), --satisfechos, neutrales, insatisfechos
    NotaMinima INT, 
    NotaMaxima INT
);




--Categorías y Turnos más solicitados:
CREATE VIEW Categorias_Turnos
    (categoría, turno)
AS SELECT ct.descripcion, t.descripcion
    FROM cursos cr
    JOIN categorias ct  ON cr.id_categoria = ct.id_categoria
    JOIN turnos t       ON cr.tipo_turno = t.tipo_turno

--Tasa de rechazo de inscripciones: HECHO! Sin dimensión. Falta probar

CREATE VIEW Tasa_Rechazos_Inscr (tasa_mes, mes, sede)
AS
 SELECT ((SUM(SELECT COUNT(*) FROM Inscripcion i2 WHERE i2.sede = i1.sede AND MONTH(i2.fecha_respuesta) = mes AND i2.cod_estado = 'rechazado')/SUM(SELECT COUNT(*) FROM Inscripcion i3 WHERE i3.sede = i1.sede AND MONTH(i3.fecha_respuesta) = mes)) * 100) AS promedio_mes, MONTH(i1.fecha_respuesta) AS mes, sede 
 FROM Inscripcion i1
 GROUP BY mes, sede
 ORDER BY mes, sede

--Comparación de desmpeño de cursada por sede:

CREATE VIEW comp_desempeño (porc_aprobado, sede, año)
AS
 SELECT (SELECT SUM(*) FROM alumno a WHERE/SELECT SUM() FROM * 100) AS porc_aprobado, sede, año
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
 SELECT (SELECT SUM(ef.nota) from Evaluacion_final ef WHERE /SELECT COUNT()) AS prom_notas, alumno_rango_etario, Curso_Categoria
 FROM
 GROUP BY alumno_rango_etario, Curso_Categoria
 ORDER BY alumno_rango_etario, Curso_Categoria

--Tasa de ausentismo finales:

CREATE VIEW ausentismo_finales (porc_ausent, semestre, sede)
AS
 SELECT 
 (SELECT COUNT(*) 
  FROM Evaluacion_final ef JOIN final JOIN curso JOIN Sedes_por_Curso
  WHERE (ef.presente = 0) AND (fecha_fin <= semestre) AND ( curso.sede = sede) / 
  SELECT COUNT(*) 
  FROM Inscripcion_final WHERE (fecha_inscripcion_final ) * 100) AS porc_ausent, semestre, sede
 FROM
 GROUP BY semestre, sede
 ORDER BY semestre, sede

--Desvío de pagos: HECHO! falta probar

CREATE VIEW Desvio_pagos(porc_pagos, semestre)
AS
 SELECT ((COUNT(*)/ SELECT COUNT(*) FROM pago p2 WHERE (CASE MONTH(p2.fecha_pago) WHEN <6 THEN 'primer semestre' ELSE 'segundo semestre' = semestre)) * 100) AS porc_pagos,
  semestre = CASE MONTH(fecha_pago) --supondré que por semestre se refiere a CUANDO fue pagado y no CUANDO expiró.
  WHEN <6 THEN 'primer semestre'
  ELSE 'segundo semestre'
 FROM pago p JOIN factura f ON (p.factura_numero = f.factura_numero)
 WHERE (p.fecha_pago > f.Factura_FechaVencimiento)
 GROUP BY semestre
 ORDER BY semestre

-- el COUNT(*) FROM pago trae de TODOS los pagos, no los casos mensuales específicamente.

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
 SELECT ( ((SELECT SUM(nota) FROM Encuesta e JOIN curso c ON (e.encuesta_curso = c.codigo_curso) WHERE (cumple condición rango etario) e.profesor)  - %insatisfechos) +100)/2) AS satisfaccion_anual
 FROM
 GROUP BY profesor_rango_etario, sede
 ORDER BY profesor_rango_etario, sede