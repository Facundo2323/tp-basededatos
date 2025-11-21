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
        GROUP BY YEAR(i.fecha_inscripcion), ct.descripcion, t.descripcion, s.id_sede
        ORDER BY COUNT(*) DESC;

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
        GROUP BY t.mes, s.id_sede
        ORDER BY [Porcentaje Aprobacion] DESC;

--3 Comparación de desmpeño de cursada por sede:
CREATE VIEW comp_desempeño 
    (Sede_Cursos, Anio_Cursos, Tasa_Aprobacion)
AS  SELECT T.Sede,
            T.Anio,
            SUM(T.alumno_aprobo) * 1.00 / COUNT(*) AS [Tasa Aprobacion]
        FROM (SELECT cr.codigo_curso,
                    s.nombre AS [Sede],
                    YEAR(cr.fecha_inicio) AS [Anio],
                    (CASE WHEN SUM(CASE WHEN ISNULL(e.nota, 0) < 4 THEN 1 --desaprobo el examen o estuvo ausente
                                        ELSE 0 END) = 0
                                AND (MAX(t.nota) >= 4 OR MAX(t.nota) IS NULL)
                        THEN 1 --aprobo
                        ELSE 0 --desaprobo
                    END) AS alumno_aprobo
                FROM KEY_GROUP.Curso cr
                JOIN KEY_GROUP.Sedes_por_Curso sc ON sc.codigo_curso = cr.codigo_curso
                JOIN KEY_GROUP.Sede s ON sc.id_sede = s.id_sede
                JOIN KEY_GROUP.Modulo_por_Curso mc ON mc.codigo_curso = cr.codigo_curso
                LEFT JOIN KEY_GROUP.Evaluacion e ON e.codigo_curso = cr.codigo_curso AND e.id_modulo = mc.id_modulo
                LEFT JOIN KEY_GROUP.Trabajo_Practico t ON t.codigo_curso = cr.codigo_curso AND t.codigo_curso = cr.codigo_curso
                GROUP BY cr.codigo_curso, s.nombre, YEAR(cr.fecha_inicio)) AS T
        GROUP BY T.Sede, T.Anio
        ORDER BY [Tasa Aprobacion] DESC;

--4 Tiempo promedio de finalización de curso:

CREATE VIEW promedio_finalizacion_curso
    (Categoria_Cursos, Anio_Cursos, Tiempo_Promedio)
AS  SELECT ct.descripcion AS            [Categoria],
            YEAR(cr.fecha_inicio) AS    [Anio],
            AVG(DATEDIFF(DAY, cr.fecha_inicio, cr.fecha_fin)) AS [Diferencia Promedio]
        FROM KEY_GROUP.Curso cr
        JOIN KEY_GROUP.Categoria ct ON cr.id_categoria = ct.id_categoria
        JOIN KEY_GROUP.Final f ON cr.codigo_curso = f.codigo_curso
        JOIN KEY_GROUP.Evaluacion_Final ef ON f.id_final = ef.id_final
        WHERE ef.nota >= 4
        GROUP BY ct.descripcion, YEAR(cr.fecha_inicio);

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
        JOIN KEY_GROUP.BI_Rango_Etario_Alumno re ON DATEDIFF(YEAR, a.fecha_nacimiento, GETDATE()) BETWEEN re.Edad_Desde AND re.Edad_Hasta
        GROUP BY re.Descripcion, ct.descripcion;

--6 Tasa de ausentismo finales:
CREATE VIEW ausentismo_finales 
    (Sede_Cursos, Semestre_Finales, Anio_Finales, Porcentaje_Ausentismo)
AS SELECT T.Sede, 
            T.Semestre,
            T.Anio,
            (T.Total - T.Presentes) * 100.0 /T.Total AS [Porcentaje Ausentismo]
    FROM (SELECT s.nombre AS        [Sede],
                t.cuatrimestre AS   [Semestre], --asumimos que son lo mismo
                t.anio AS           [Anio],
                COUNT(*) AS         [Total],
                SUM(ef.presente) AS [Presentes]
            FROM KEY_GROUP.Evaluacion_Final ef
            JOIN KEY_GROUP.Final f ON ef.id_final = f.id_final
            JOIN KEY_GROUP.Curso cr ON f.codigo_curso = cr.codigo_curso
            JOIN KEY_GROUP.Sedes_por_Curso sc ON sc.codigo_curso = cr.codigo_curso
            JOIN KEY_GROUP.Sede s ON sc.id_sede = s.id_sede
            JOIN KEY_GROUP.BI_Tiempo t ON MONTH(f.fecha_final) = t.mes AND YEAR(f.fecha_final) = t.anio
            GROUP BY s.nombre, t.cuatrimestre, t.anio) T

--7 Desvío de pagos:
CREATE VIEW Desvio_pagos
    (Semestre_Facturas, Anio_Facturas, Porcentaje_Vencidas)
AS SELECT T.Semestre,
            T.Anio,
            T.Vencidas * 100.0 / T.Total AS [Porcentaje Vencidas]
        FROM (SELECT COUNT(*) AS        [Total],
                    t.cuatrimestre AS   [Semestre],
                    t.anio AS           [Anio],
                    SUM(CASE WHEN p.fecha_pago > f.fecha_vencimiento THEN 1 ELSE 0 END) AS [Vencidas]
                FROM KEY_GROUP.Pago p
                JOIN KEY_GROUP.Factura f ON p.factura_numero = f.factura_numero
                JOIN KEY_GROUP.BI_Tiempo t ON MONTH(f.fecha_vencimiento) = t.mes AND YEAR(f.fecha_vencimiento) = t.anio
                GROUP BY t.cuatrimestre, t.anio) T

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
        JOIN KEY_GROUP.Factura f ON df.id_detalle_factura = f.id_detalle_factura
        JOIN KEY_GROUP.Pago p ON f.factura_numero = p.factura_numero
        GROUP BY ct.descripcion, s.nombre, YEAR(f.fecha_emision)
        ORDER BY 3 DESC

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
                JOIN KEY_GROUP.BI_Rango_Etario_Profesor re ON DATEDIFF(YEAR, p.fecha_nacimiento, GETDATE()) BETWEEN re.Edad_desde AND re.Edad_hasta
                JOIN KEY_GROUP.Curso cr ON p.id_profesor = cr.id_profesor
                JOIN KEY_GROUP.Sedes_por_Curso sc ON cr.codigo_curso = sc.codigo_curso
                JOIN KEY_GROUP.Sede s ON sc.id_sede = s.id_sede
                JOIN KEY_GROUP.Evaluacion e ON cr.codigo_curso = e.codigo_curso
                JOIN KEY_GROUP.BI_Bloques_de_satisfaccion bs ON e.nota BETWEEN bs.NotaMinima AND bs.NotaMaxima
                GROUP BY re.Descripcion, s.nombre, YEAR(cr.fecha_inicio)) T