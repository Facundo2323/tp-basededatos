USE GD2C2025
GO

-- DIMENSIONES

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
               WHERE TABLE_SCHEMA = 'KEY_GROUP' AND TABLE_NAME = 'BI_DIM_Tiempo')
CREATE TABLE KEY_GROUP.BI_DIM_Tiempo (
    DIM_Tiempo_id INT IDENTITY(1,1) PRIMARY KEY,
    Anio INT,
    Semestre INT,
    Mes INT
);

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
               WHERE TABLE_SCHEMA = 'KEY_GROUP' AND TABLE_NAME = 'BI_DIM_Sede')
CREATE TABLE KEY_GROUP.BI_DIM_Sede (
    DIM_Sede_id INT IDENTITY(1,1) PRIMARY KEY, 
    Nombre NVARCHAR(255),
);

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
               WHERE TABLE_SCHEMA = 'KEY_GROUP' AND TABLE_NAME = 'BI_DIM_Rango_etario_alumno')
CREATE TABLE KEY_GROUP.BI_DIM_Rango_etario_alumno (
    DIM_REA_id INT IDENTITY(1,1) PRIMARY KEY, 
    Descripcion NVARCHAR(255), -- menor de 25, de 25 a 35, etc.
    Edad_desde INT, 
    Edad_hasta INT  
);

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
               WHERE TABLE_SCHEMA = 'KEY_GROUP' AND TABLE_NAME = 'BI_DIM_Rango_etario_profesor')
CREATE TABLE KEY_GROUP.BI_DIM_Rango_etario_profesor (
    DIM_REP_id INT IDENTITY(1,1) PRIMARY KEY, 
    Descripcion NVARCHAR(255), -- menor de 25, de 25 a 35, etc.
    Edad_desde INT, 
    Edad_hasta INT
);

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
               WHERE TABLE_SCHEMA = 'KEY_GROUP' AND TABLE_NAME = 'BI_DIM_Turno_curso')
CREATE TABLE KEY_GROUP.BI_DIM_Turno_curso (
    DIM_Turno_curso_id INT IDENTITY(1,1) PRIMARY KEY, 
    Turno NVARCHAR(255)  --Mañ/Tar/Noc
);

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
               WHERE TABLE_SCHEMA = 'KEY_GROUP' AND TABLE_NAME = 'BI_DIM_Categoria_curso')
CREATE TABLE KEY_GROUP.BI_DIM_Categoria_curso (
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
    DIM_Bloque_sat_id INT IDENTITY(1,1) PRIMARY KEY,
    Descripcion NVARCHAR(255), --satisfechos, neutrales, insatisfechos
    NotaMinima INT, 
    NotaMaxima INT
);

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
               WHERE TABLE_SCHEMA = 'KEY_GROUP' AND TABLE_NAME = 'BI_DIM_Factura')
CREATE TABLE KEY_GROUP.BI_DIM_Factura (
    DIM_Factura_id INT IDENTITY(1,1) PRIMARY KEY,
    Estado_factura NVARCHAR(255)
);

-- VOLCADO ESQUEMA-BI DIMENSIONES

IF NOT EXISTS (SELECT * FROM KEY_GROUP.BI_DIM_Tiempo)
INSERT INTO KEY_GROUP.BI_DIM_Tiempo

SELECT anio, (CASE WHEN mes BETWEEN 1 AND 6 THEN 1 WHEN BETWEEN 7 AND 12 THEN 2) AS Semestre, generate_series(1,12) AS mes
FROM generate_series(1961,2100) AS anio
;

IF NOT EXISTS (SELECT * FROM KEY_GROUP.BI_DIM_Sede)
INSERT INTO KEY_GROUP.BI_DIM_Sede

SELECT nombre
FROM KEY_GROUP.Sede
ORDER BY id_sede
;

IF NOT EXISTS (SELECT * FROM KEY_GROUP.BI_DIM_Rango_etario_alumno)
INSERT INTO KEY_GROUP.BI_DIM_Rango_etario_alumno

VALUES ('menor de 25', 0, 25),('de 25 a 35', 25, 35),('de 35 a 50', 35, 50),('mayor de 50', 50, 120)
;

IF NOT EXISTS (SELECT * FROM KEY_GROUP.BI_DIM_Rango_etario_profesor)
INSERT INTO KEY_GROUP.BI_DIM_Rango_etario_profesor

VALUES ('menor de 25', 0, 25),('de 25 a 35', 25, 35),('de 35 a 50', 35, 50),('mayor de 50', 50, 120)
;

IF NOT EXISTS (SELECT * FROM KEY_GROUP.BI_DIM_Turno_curso)
INSERT INTO KEY_GROUP.BI_DIM_Turno_curso

VALUES ('mañana'),('tarde'),('noche')
;

IF NOT EXISTS (SELECT * FROM KEY_GROUP.BI_DIM_Categoria_curso)
INSERT INTO KEY_GROUP.BI_DIM_Categoria_curso

SELECT descripcion
FROM KEY_GROUP.Sede
ORDER BY id_categoria
;

IF NOT EXISTS (SELECT * FROM KEY_GROUP.BI_DIM_Medio_de_pago)
INSERT INTO KEY_GROUP.BI_DIM_Medio_de_pago

SELECT codigo_medio_de_pago
FROM KEY_GROUP.Medio_de_Pago
ORDER BY codigo_medio_de_pago
;

IF NOT EXISTS (SELECT * FROM KEY_GROUP.BI_DIM_Bloques_de_satisfaccion)
INSERT INTO KEY_GROUP.BI_DIM_Bloques_de_satisfaccion

VALUES ('satisfecho',7,10),('neutral',5,6),('insatisfecho',1,4)
;

IF NOT EXISTS (SELECT * FROM KEY_GROUP.BI_DIM_Factura)
INSERT INTO KEY_GROUP.BI_DIM_Factura

VALUES ('pendiente'),('pagado'),('atrasado')
;


--HECHOS + VOLCADO DE DATOS


IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'KEY_GROUP' AND TABLE_NAME = 'BI_HECHO_Inscripciones_a_cursos')

SELECT DIM_Tiempo_id, DIM_Sede_id, DIM_Turno_curso_id, DIM_Categoria_curso_id
INTO KEY_GROUP.BI_HECHO_Inscripciones_a_cursos
FROM (SELECT * FROM KEY_GROUP.BI_DIM_Tiempo 
      UNION 
      SELECT * FROM KEY_GROUP.BI_DIM_Sede 
      UNION 
      SELECT * FROM KEY_GROUP.BI_DIM_Turno_curso
      UNION 
      SELECT * FROM KEY_GROUP.BI_DIM_Categoria_curso) AS InscripcionesCursos
GROUP BY DIM_Tiempo_id, DIM_Sede_id, DIM_Turno_curso_id, DIM_Categoria_curso_id

  
ALTER TABLE KEY_GROUP.BI_HECHO_Inscripciones_a_cursos
      ADD inscripciones_totales BIGINT,
      cantidad_inscripciones_aceptadas BIGINT,
      pct_inscripciones_rechazadas DECIMAL(38,2),
      ingresos_recaudados DECIMAL(38,2)
;


IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'KEY_GROUP' AND TABLE_NAME = 'BI_HECHO_Evaluaciones')

SELECT DIM_Tiempo_id, DIM_Sede_id
INTO KEY_GROUP.BI_HECHO_Evaluaciones
FROM (SELECT * FROM KEY_GROUP.BI_DIM_Tiempo
      UNION 
      SELECT * FROM KEY_GROUP.BI_DIM_Sede) AS Evaluaciones
GROUP BY DIM_Tiempo_id, DIM_Sede_id

ALTER TABLE KEY_GROUP.BI_HECHO_Evaluaciones  
      ADD pct_aprobacion_cursada DECIMAL(38,2)
;


IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'KEY_GROUP' AND TABLE_NAME = 'BI_HECHO_Inscripciones_a_finales')

SELECT DIM_Tiempo_id, DIM_Sede_id
INTO KEY_GROUP.BI_HECHO_Inscripciones_a_finales
FROM (SELECT * FROM KEY_GROUP.BI_DIM_Tiempo
      UNION 
      SELECT * FROM KEY_GROUP.BI_DIM_Sede) AS InscripcionesFinales
GROUP BY DIM_Tiempo_id, DIM_Sede_id

ALTER TABLE KEY_GROUP.BI_HECHO_Evaluaciones  
      ADD cantidad_inscriptos INT
;


IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'KEY_GROUP' AND TABLE_NAME = 'BI_HECHO_Ev_finales')

SELECT DIM_Tiempo_id, DIM_Sede_id, DIM_REA_id,  DIM_Categoria_curso_id
INTO KEY_GROUP.BI_HECHO_Ev_finales
FROM (SELECT * FROM KEY_GROUP.BI_DIM_Tiempo
      UNION 
      SELECT * FROM KEY_GROUP.BI_DIM_Sede
      UNION
      SELECT * FROM KEY_GROUP.BI_DIM_Rango_etario_alumno
      UNION
      SELECT * FROM KEY_GROUP.BI_DIM_Categoria_curso) AS EvaluacionesFinales
GROUP BY DIM_Tiempo_id, DIM_Sede_id, DIM_REA_id,  DIM_Categoria_curso_id

ALTER TABLE KEY_GROUP.BI_HECHO_Ev_finales 
      ADD promedio_finalizacion_curso DECIMAL(38,2), 
          promedio_notas_finales DECIMAL(38,2),
          pct_ausentes DECIMAL(38,2)
;

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'KEY_GROUP' AND TABLE_NAME = 'BI_HECHO_Pagos')

SELECT DIM_Tiempo_id, DIM_Medio_de_pago_id, DIM_Factura_id
INTO KEY_GROUP.BI_HECHO_Pagos
FROM (SELECT * FROM KEY_GROUP.BI_DIM_Tiempo
      UNION 
      SELECT * FROM KEY_GROUP.BI_DIM_Medio_de_pago
      UNION
      SELECT * FROM KEY_GROUP.BI_DIM_Factura) AS Pagos
GROUP BY DIM_Tiempo_id, DIM_Medio_de_pago_id, DIM_Factura_id

ALTER TABLE KEY_GROUP.BI_HECHO_Ev_finales 
      ADD  pct_fuera_de_termino DECIMAL(38,2),
           cantidad_importes_adeudados INT
;

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'KEY_GROUP' AND TABLE_NAME = 'BI_HECHO_Encuestas')

SELECT DIM_Tiempo_id, DIM_Sede_id, DIM_REP_id,  DIM_Bloque_sat_id
INTO KEY_GROUP.BI_HECHO_Encuestas
FROM (SELECT * FROM KEY_GROUP.BI_DIM_Tiempo
      UNION 
      SELECT * FROM KEY_GROUP.BI_DIM_Sede
      UNION
      SELECT * FROM KEY_GROUP.BI_DIM_Rango_etario_profesor
      UNION
      SELECT * FROM KEY_GROUP.BI_DIM_Bloques_de_satisfaccion) AS Encuestas
GROUP BY DIM_Tiempo_id, DIM_Sede_id, DIM_REP_id,  DIM_Bloque_sat_id

ALTER TABLE KEY_GROUP.BI_HECHO_Encuestas
      ADD indice_sat_anual DECIMAL(38,2)
;
GO


--VIEWS
--1 Categorías y Turnos más solicitados:
CREATE VIEW Categorias_Turnos
    (Categoria_Cursos, Turno_Cursos, Anio_Cursos, Sede_Cursos, Cantidad)
AS SELECT TOP 3 ct.descripcion AS           [Categoria],
             t.descripcion AS               [Turno],
             YEAR(i.fecha_inscripcion) AS   [Anio],
             s.nombre AS                    [Sede], 
             COUNT(*) AS                    [Cantidad]
        FROM KEY_GROUP.Inscripcion i
        JOIN KEY_GROUP.Curso cr ON i.codigo_curso = cr.codigo_curso
        JOIN KEY_GROUP.Categoria ct ON cr.id_categoria = ct.id_categoria
        JOIN KEY_GROUP.Turno t ON cr.tipo_turno = t.tipo_turno
        JOIN KEY_GROUP.Sedes_por_Curso sc ON sc.codigo_curso = cr.codigo_curso
        JOIN KEY_GROUP.Sede s ON sc.id_sede = s.id_sede
        GROUP BY YEAR(i.fecha_inscripcion), ct.descripcion, t.descripcion, s.nombre
GO
--2 Tasa de rechazo de inscripciones:
CREATE VIEW Tasa_Rechazos_Inscr
    (Mes_Inscripciones, Sede_Inscripciones, Porcentaje_Aprobacion)
AS SELECT t.mes AS      [Mes], 
            s.nombre AS [Sede],
            COUNT(*) * 100.0
            / (SELECT COUNT(*)
                FROM KEY_GROUP.Inscripcion i2
                JOIN KEY_GROUP.Curso cr2 ON i2.codigo_curso = cr2.codigo_curso
                JOIN KEY_GROUP.Sedes_por_Curso sc2 ON sc2.codigo_curso = cr2.codigo_curso
                WHERE t.mes = MONTH(i2.fecha_inscripcion) AND s.id_sede = sc2.id_sede) AS [Porcentaje Aprobacion]
        FROM KEY_GROUP.Inscripcion i
        JOIN KEY_GROUP.Curso cr ON i.codigo_curso = cr.codigo_curso
        JOIN KEY_GROUP.Sedes_por_Curso sc ON sc.codigo_curso = cr.codigo_curso
        JOIN KEY_GROUP.Sede s ON sc.id_sede = s.id_sede
        JOIN KEY_GROUP.BI_DIM_Tiempo t ON MONTH(i.fecha_inscripcion) = t.mes AND YEAR(i.fecha_inscripcion) = t.anio
        WHERE i.codigo_estado_inscripcion = 'Rechazada'
        GROUP BY t.mes, s.nombre, s.id_sede
GO
--3 Comparación de desmpeño de cursada por sede:
CREATE VIEW comp_desempeño 
    (Sede_Cursos, Anio_Cursos, Tasa_Aprobacion)
AS SELECT T.Sede,
           T.Anio,
           SUM(T.alumno_aprobo) * 1.00 / COUNT(*) AS [Tasa Aprobacion]
    FROM (SELECT cr.codigo_curso,
                    s.nombre AS [Sede],
                    YEAR(cr.fecha_inicio) AS [Anio],
                    A.legajo_alumno, 
                    (CASE WHEN SUM(CASE WHEN ISNULL(e.nota, 0) < 4 THEN 1 ELSE 0 END) = 0
                             AND (MAX(t.nota) >= 4 OR MAX(t.nota) IS NULL)
                        THEN 1
                        ELSE 0
                    END) AS alumno_aprobo
            FROM KEY_GROUP.Curso cr
            JOIN KEY_GROUP.Sedes_por_Curso sc ON sc.codigo_curso = cr.codigo_curso
            JOIN KEY_GROUP.Sede s ON sc.id_sede = s.id_sede
            JOIN KEY_GROUP.Modulo_por_Curso mc ON mc.codigo_curso = cr.codigo_curso
            JOIN KEY_GROUP.Inscripcion I ON I.codigo_curso = cr.codigo_curso 
            JOIN KEY_GROUP.Alumno A ON A.legajo_alumno = I.legajo_alumno
            LEFT JOIN KEY_GROUP.Evaluacion e ON e.codigo_curso = cr.codigo_curso 
                                                AND e.id_modulo = mc.id_modulo
                                                AND e.legajo_alumno = A.legajo_alumno
            LEFT JOIN KEY_GROUP.Trabajo_Practico t ON t.codigo_curso = cr.codigo_curso 
                                                    AND t.legajo_alumno = A.legajo_alumno

            GROUP BY cr.codigo_curso, s.nombre, YEAR(cr.fecha_inicio), A.legajo_alumno) AS T
    GROUP BY T.Sede, T.Anio
GO
--4 Tiempo promedio de finalización de curso:
CREATE VIEW promedio_finalizacion_curso
    (Categoria_Cursos, Anio_Cursos, Tiempo_Promedio)
AS  SELECT ct.descripcion AS [Categoria],
            YEAR(cr.fecha_inicio) AS [Anio],
            AVG(DATEDIFF(DAY, cr.fecha_inicio, cr.fecha_fin)) AS [Diferencia Promedio]
        FROM KEY_GROUP.Curso cr
        JOIN KEY_GROUP.Categoria ct ON cr.id_categoria = ct.id_categoria
        JOIN KEY_GROUP.Final f ON cr.codigo_curso = f.codigo_curso
        JOIN KEY_GROUP.Evaluacion_Final ef ON f.id_final = ef.id_final
        WHERE ef.nota >= 4
        GROUP BY ct.descripcion, YEAR(cr.fecha_inicio);
GO
--5 Nota promedio de finales:
CREATE VIEW promedio_finales 
    (Rango_Etario_Alumnos, Categoria_Cursos, Nota_Promedio)
AS  SELECT re.Descripcion AS    [Rango Etario],
            ct.descripcion AS   [Categoria],
            AVG(ef.nota) AS     [Nota Promedio]
        FROM KEY_GROUP.Evaluacion_Final ef
        JOIN KEY_GROUP.Final f ON ef.id_final = f.id_final
        JOIN KEY_GROUP.Curso cr ON f.codigo_curso = cr.codigo_curso
        JOIN KEY_GROUP.Categoria ct ON cr.id_categoria = ct.id_categoria
        JOIN KEY_GROUP.Alumno a ON ef.legajo_alumno = a.legajo_alumno
        JOIN KEY_GROUP.BI_DIM_Rango_Etario_Alumno re ON DATEDIFF(YEAR, a.fecha_nacimiento, GETDATE()) BETWEEN re.Edad_Desde AND re.Edad_Hasta
        GROUP BY re.Descripcion, ct.descripcion;
GO
--6 Tasa de ausentismo finales:
CREATE VIEW ausentismo_finales 
    (Sede_Cursos, Semestre_Finales, Anio_Finales, Porcentaje_Ausentismo)
AS SELECT T.Sede, 
            T.Semestre,
            T.Anio,
            (T.Total - T.Presentes) * 100.0 /T.Total AS [Porcentaje Ausentismo]
    FROM (SELECT s.nombre AS        [Sede],
                t.Semestre AS       [Semestre],
                t.Anio AS           [Anio],
                COUNT(*) AS         [Total],
                SUM(CAST(ef.presente AS INT) AS [Presentes]
            FROM KEY_GROUP.Evaluacion_Final ef
            JOIN KEY_GROUP.Final f ON ef.id_final = f.id_final
            JOIN KEY_GROUP.Curso cr ON f.codigo_curso = cr.codigo_curso
            JOIN KEY_GROUP.Sedes_por_Curso sc ON sc.codigo_curso = cr.codigo_curso
            JOIN KEY_GROUP.Sede s ON sc.id_sede = s.id_sede
            JOIN KEY_GROUP.BI_DIM_Tiempo t ON MONTH(f.fecha_final) = t.Mes AND YEAR(f.fecha_final) = t.Anio
            GROUP BY s.nombre, t.Semestre, t.Anio) T
GO
--7 Desvío de pagos:
CREATE VIEW Desvio_pagos
    (Semestre_Facturas, Anio_Facturas, Porcentaje_Vencidas)
AS SELECT T.Semestre,
            T.Anio,
            T.Vencidas * 100.0 / T.Total AS [Porcentaje Vencidas]
        FROM (SELECT COUNT(*) AS        [Total],
                    t.Semestre AS   [Semestre],
                    t.Anio AS           [Anio],
                    SUM(CASE WHEN p.fecha_pago > f.fecha_vencimiento THEN 1 ELSE 0 END) AS [Vencidas]
                FROM KEY_GROUP.Pago p
                JOIN KEY_GROUP.Factura f ON p.factura_numero = f.factura_numero
                JOIN KEY_GROUP.BI_DIM_Tiempo t ON MONTH(f.fecha_vencimiento) = t.mes AND YEAR(f.fecha_vencimiento) = t.anio
                GROUP BY t.Semestre, t.Anio) T
GO
--8 Tasa de Morosidad Financiera mensual:
CREATE VIEW Morosidad_financiera_mensual 
    (Mes_Facturas, Anio_Facturas, Tasa_Morosidad)
AS SELECT T.Mes,
        T.Anio,
        T.[Total Adeudado] * 100.0 / T.[Total Esperado] AS [Porcentaje Morosidad]
        FROM (SELECT MONTH(f.fecha_vencimiento) AS  [Mes],
                    YEAR(f.fecha_vencimiento) AS    [Anio],
                    SUM(f.importe_total) AS         [Total Esperado],
                    SUM(CASE WHEN p.factura_numero IS NULL THEN f.importe_total ELSE 0 END) AS [Total Adeudado]
                FROM KEY_GROUP.Factura f
                LEFT JOIN KEY_GROUP.Pago p ON f.factura_numero = p.factura_numero AND MONTH(f.fecha_vencimiento) = MONTH(p.fecha_pago)
                GROUP BY MONTH(f.fecha_vencimiento), YEAR(f.fecha_vencimiento)) T
GO
--9 Ingresos por categoría de cursos:
CREATE VIEW ingresos_categoría_cursos 
    (Categoria_Cursos, Sede_Cursos, Anio_Cursos, Ingresos_Totales)
AS  SELECT TOP 3 ct.descripcion AS      [Categoria],
            s.nombre AS                 [Sede],
            YEAR(f.fecha_emision) AS    [Anio],
            SUM(p.importe) AS           [Total]
        FROM KEY_GROUP.Detalle_Factura df
        JOIN KEY_GROUP.Curso cr ON df.codigo_curso = cr.codigo_curso
        JOIN KEY_GROUP.Categoria ct ON cr.id_categoria = ct.id_categoria
        JOIN KEY_GROUP.Sedes_por_Curso sc ON cr.codigo_curso = sc.codigo_curso
        JOIN KEY_GROUP.Sede s ON sc.id_sede = s.id_sede
        JOIN KEY_GROUP.Factura f ON df.factura_numero = f.factura_numero
        JOIN KEY_GROUP.Pago p ON f.factura_numero = p.factura_numero
        GROUP BY ct.descripcion, s.nombre, YEAR(f.fecha_emision)
GO
--10 Índice de satisfacción:
CREATE VIEW indice_satisfaccion 
    (Rango_Etario_Profesores, Sede_Cursos, Anio_Cursos, Indice_Satisfaccion)
AS  SELECT T.[Rango Etario], 
            T.Sede, 
            T.Anio,
            ((T.[Total Satisfechos]-T.[Total Insatisfechos])*100.00/T.Total + 100)/2 AS [Indice Satisfaccion]
        FROM (SELECT re.Descripcion AS [Rango Etario],
                    s.nombre AS                 [Sede],
                    YEAR(cr.fecha_inicio) AS    [Anio],
                    SUM(CASE WHEN bs.Descripcion = 'Satisfecho' THEN 1 ELSE 0 END) AS [Total Satisfechos],
                    SUM(CASE WHEN bs.Descripcion = 'Insatisfecho' THEN 1 ELSE 0 END) AS [Total Insatisfechos],
                    COUNT(*) AS [Total]
                FROM KEY_GROUP.Profesor p
                JOIN KEY_GROUP.BI_DIM_Rango_Etario_Profesor re ON DATEDIFF(YEAR, p.fecha_nacimiento, GETDATE()) BETWEEN re.Edad_desde AND re.Edad_hasta
                JOIN KEY_GROUP.Curso cr ON p.id_profesor = cr.id_profesor
                JOIN KEY_GROUP.Sedes_por_Curso sc ON cr.codigo_curso = sc.codigo_curso
                JOIN KEY_GROUP.Sede s ON sc.id_sede = s.id_sede
                JOIN KEY_GROUP.Evaluacion e ON cr.codigo_curso = e.codigo_curso
                JOIN KEY_GROUP.BI_DIM_Bloques_de_satisfaccion bs ON e.nota BETWEEN bs.NotaMinima AND bs.NotaMaxima
                GROUP BY re.Descripcion, s.nombre, YEAR(cr.fecha_inicio)) T
