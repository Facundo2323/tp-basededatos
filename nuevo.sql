USE GD2C2025
GO

CREATE SCHEMA KEY_GROUP
GO

--Creacion de las tablas

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Provincia' AND schema_id = SCHEMA_ID('KEY_GROUP')) 
CREATE TABLE KEY_GROUP.Provincia (
    id_provincia INT IDENTITY(1,1),
    nombre NVARCHAR(255),

    CONSTRAINT PK_Provincia_id PRIMARY KEY (id_provincia)
);

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Localidad' AND schema_id = SCHEMA_ID('KEY_GROUP'))
CREATE TABLE KEY_GROUP.Localidad (
    id_localidad INT IDENTITY(1,1),
    nombre NVARCHAR(255),
    id_provincia INT,

    CONSTRAINT PK_Localidad_id PRIMARY KEY (id_localidad),
    CONSTRAINT FK_Localidad_provincia FOREIGN KEY (id_provincia) REFERENCES KEY_GROUP.Provincia(id_provincia)
);

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Profesor' AND schema_id = SCHEMA_ID('KEY_GROUP'))
CREATE TABLE KEY_GROUP.Profesor (
    id_profesor INT IDENTITY(1,1),
    dni NVARCHAR(255),
    id_localidad INT,
    nombre NVARCHAR(255),
    apellido NVARCHAR(255),
    fecha_nacimiento DATETIME2(6),
    mail NVARCHAR(255),
    direccion NVARCHAR(255),
    telefono NVARCHAR(255),

    CONSTRAINT PK_Profesor_id PRIMARY KEY (id_profesor),
    CONSTRAINT FK_Profesor_localidad FOREIGN KEY (id_localidad) REFERENCES KEY_GROUP.Localidad(id_localidad),
);

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Institucion' AND schema_id = SCHEMA_ID('KEY_GROUP'))
CREATE TABLE KEY_GROUP.Institucion (
    id_institucion INT IDENTITY(1,1),
    cuit NVARCHAR(255),
    nombre NVARCHAR(255),
    razon_social NVARCHAR(255),

    CONSTRAINT PK_Institucion_id PRIMARY KEY (id_institucion)
);

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Sede' AND schema_id = SCHEMA_ID('KEY_GROUP'))
CREATE TABLE KEY_GROUP.Sede (
    id_sede BIGINT IDENTITY(1,1),
    id_institucion INT,
    nombre NVARCHAR(255),
    direccion NVARCHAR(255),
    telefono NVARCHAR(255),
    mail NVARCHAR(255),
    id_localidad INT,

    CONSTRAINT PK_Sede_id PRIMARY KEY (id_sede),
    CONSTRAINT FK_Sede_institucion FOREIGN KEY (id_institucion) REFERENCES KEY_GROUP.Institucion(id_institucion),
    CONSTRAINT FK_Sede_localidad FOREIGN KEY (id_localidad) REFERENCES KEY_GROUP.Localidad(id_localidad)
);

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Categoria' AND schema_id = SCHEMA_ID('KEY_GROUP'))
CREATE TABLE KEY_GROUP.Categoria (
    id_categoria BIGINT IDENTITY(1,1),
    descripcion VARCHAR(255),

    CONSTRAINT PK_Categoria_id PRIMARY KEY (id_categoria)
);

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Turno' AND schema_id = SCHEMA_ID('KEY_GROUP'))
CREATE TABLE KEY_GROUP.Turno (
    tipo_turno CHAR(1) NOT NULL,
    descripcion VARCHAR(255),

    CONSTRAINT PK_Turno_tipo PRIMARY KEY (tipo_turno)
);

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Curso' AND schema_id = SCHEMA_ID('KEY_GROUP'))
CREATE TABLE KEY_GROUP.Curso (
    codigo_curso BIGINT NOT NULL,
    nombre NVARCHAR(255),
    descripcion NVARCHAR(255),
    id_categoria BIGINT,
    fecha_inicio DATETIME2(6),
    fecha_fin DATETIME2(6),
    duracion_meses BIGINT,
    tipo_turno CHAR(1),
    precio_mensual DECIMAL(38,2),
    id_profesor INT,

    CONSTRAINT PK_Curso_codigo PRIMARY KEY (codigo_curso),
    CONSTRAINT FK_Curso_categoria FOREIGN KEY (id_categoria) REFERENCES KEY_GROUP.Categoria(id_categoria),
    CONSTRAINT FK_Curso_turno FOREIGN KEY (tipo_turno) REFERENCES KEY_GROUP.Turno(tipo_turno),
    CONSTRAINT FK_Curso_profesor FOREIGN KEY (id_profesor) REFERENCES KEY_GROUP.Profesor(id_profesor)
);

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Sedes_por_Curso' AND schema_id = SCHEMA_ID('KEY_GROUP'))
CREATE TABLE KEY_GROUP.Sedes_por_Curso (
    codigo_curso BIGINT NOT NULL,
    id_sede BIGINT NOT NULL,

    CONSTRAINT PK_Sede_por_Curso PRIMARY KEY (id_sede, codigo_curso),
    CONSTRAINT FK_Sede_por_Curso_sede FOREIGN KEY (id_sede) REFERENCES KEY_GROUP.Sede(id_sede),
    CONSTRAINT FK_Sede_por_Curso_curso FOREIGN KEY (codigo_curso) REFERENCES KEY_GROUP.Curso(codigo_curso)
);

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Encuesta' AND schema_id = SCHEMA_ID('KEY_GROUP'))
CREATE TABLE KEY_GROUP.Encuesta (
    id_encuesta BIGINT IDENTITY(1,1),
    codigo_curso BIGINT,
    fecha_registro DATETIME2(6),
    observaciones NVARCHAR(255),

    CONSTRAINT PK_Encuesta_id PRIMARY KEY (id_encuesta),
    CONSTRAINT FK_Encuesta_curso FOREIGN KEY (codigo_curso) REFERENCES KEY_GROUP.Curso(codigo_curso)
);

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Pregunta' AND schema_id = SCHEMA_ID('KEY_GROUP'))
CREATE TABLE KEY_GROUP.Pregunta (
    id_pregunta BIGINT IDENTITY(1,1),
    pregunta NVARCHAR(255),
    respuesta INT, -- nota(1 al 10)
    id_encuesta BIGINT,

    CONSTRAINT PK_Pregunta_id PRIMARY KEY (id_pregunta),
    CONSTRAINT FK_Pregunta_encuesta FOREIGN KEY (id_encuesta) REFERENCES KEY_GROUP.Encuesta(id_encuesta)
);

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Detalle_Factura' AND schema_id = SCHEMA_ID('KEY_GROUP'))
CREATE TABLE KEY_GROUP.Detalle_Factura (
    id_detalle_factura BIGINT IDENTITY(1,1),
    codigo_curso BIGINT,
    periodo VARCHAR(255), --mes/año
    importe DECIMAL(18,2),

    CONSTRAINT PK_Detalle_Factura_id PRIMARY KEY (id_detalle_factura),
    CONSTRAINT FK_Detalle_Factura_curso FOREIGN KEY (codigo_curso) REFERENCES KEY_GROUP.Curso(codigo_curso)
);

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Alumno' AND schema_id = SCHEMA_ID('KEY_GROUP'))
CREATE TABLE KEY_GROUP.Alumno (
    legajo_alumno BIGINT,
    dni BIGINT,
    nombre NVARCHAR(255),
    apellido NVARCHAR(255),
    fecha_nacimiento DATETIME2(6),
    mail NVARCHAR(255),
    direccion NVARCHAR(255),
    id_localidad INT,
    telefono NVARCHAR(255),

    CONSTRAINT PK_Alumno_legajo PRIMARY KEY (legajo_alumno),
    CONSTRAINT FK_Alumno_localidad FOREIGN KEY (id_localidad) REFERENCES KEY_GROUP.Localidad(id_localidad)
);

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Factura' AND schema_id = SCHEMA_ID('KEY_GROUP'))
CREATE TABLE KEY_GROUP.Factura (
    factura_numero BIGINT,
    fecha_emision DATETIME2(6),
    fecha_vencimiento DATETIME2(6),
    importe_total DECIMAL(18,2),
    id_detalle_factura BIGINT,
    legajo_alumno BIGINT,

    CONSTRAINT PK_Factura_id PRIMARY KEY (factura_numero),
    CONSTRAINT FK_Factura_detalle FOREIGN KEY (id_detalle_factura) REFERENCES KEY_GROUP.Detalle_Factura(id_detalle_factura),
    CONSTRAINT FK_Factura_alumno FOREIGN KEY (legajo_alumno) REFERENCES KEY_GROUP.Alumno(legajo_alumno)
);

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Medio_de_Pago' AND schema_id = SCHEMA_ID('KEY_GROUP'))
CREATE TABLE KEY_GROUP.Medio_de_Pago (
    codigo_medio_de_pago NVARCHAR(255)

    CONSTRAINT PK_Medio_Pago_codigo PRIMARY KEY (codigo_medio_de_pago)
);

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Pago' AND schema_id = SCHEMA_ID('KEY_GROUP'))
CREATE TABLE KEY_GROUP.Pago (
    id_pago BIGINT IDENTITY(1,1),
    factura_numero BIGINT,
    fecha_pago DATETIME2(6),
    codigo_medio_de_pago NVARCHAR(255),
    importe DECIMAL(18,2),

    CONSTRAINT PK_Pago_id PRIMARY KEY (id_pago),
    CONSTRAINT FK_Pago_factura FOREIGN KEY (factura_numero) REFERENCES KEY_GROUP.Factura(factura_numero),
    CONSTRAINT FK_Pago_medio_pago FOREIGN KEY (codigo_medio_de_pago) REFERENCES KEY_GROUP.Medio_de_Pago(codigo_medio_de_pago)
);

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Estado_Inscripcion' AND schema_id = SCHEMA_ID('KEY_GROUP'))
CREATE TABLE KEY_GROUP.Estado_Inscripcion (
    codigo_estado_inscripcion VARCHAR(255) NOT NULL,

    CONSTRAINT PK_Estado_Inscripcion_codigo PRIMARY KEY (codigo_estado_inscripcion)
);

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Inscripcion' AND schema_id = SCHEMA_ID('KEY_GROUP'))
CREATE TABLE KEY_GROUP.Inscripcion (
    numero_inscripcion BIGINT IDENTITY(1,1),
    fecha_inscripcion DATETIME2(6),
    codigo_curso BIGINT,
    legajo_alumno BIGINT,
    fecha_respuesta DATETIME2(6),
    codigo_estado_inscripcion VARCHAR(255),

    CONSTRAINT PK_Inscripcion_numero PRIMARY KEY (numero_inscripcion),
    CONSTRAINT FK_Inscripcion_curso FOREIGN KEY (codigo_curso) REFERENCES KEY_GROUP.Curso(codigo_curso),
    CONSTRAINT FK_Inscripcion_alumno FOREIGN KEY (legajo_alumno) REFERENCES KEY_GROUP.Alumno(legajo_alumno),
    CONSTRAINT FK_Inscripcion_estado FOREIGN KEY (codigo_estado_inscripcion) REFERENCES KEY_GROUP.Estado_Inscripcion(codigo_estado_inscripcion)
);

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Dia' AND schema_id = SCHEMA_ID('KEY_GROUP'))
CREATE TABLE KEY_GROUP.Dia (
    dia CHAR(3) NOT NULL,

    CONSTRAINT PK_Dia_dia PRIMARY KEY (dia)
);

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Curso_por_Dia' AND schema_id = SCHEMA_ID('KEY_GROUP'))
CREATE TABLE KEY_GROUP.Curso_por_Dia (
    dia CHAR(3),
    codigo_curso BIGINT,
    
    CONSTRAINT PK_Curso_por_Dia PRIMARY KEY (dia, codigo_curso),
    CONSTRAINT FK_Curso_por_Dia_Dia FOREIGN KEY (dia) REFERENCES KEY_GROUP.Dia(dia),
    CONSTRAINT FK_Curso_por_Dia_Curso FOREIGN KEY (codigo_curso) REFERENCES KEY_GROUP.Curso(codigo_curso)
);

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Modulo' AND schema_id = SCHEMA_ID('KEY_GROUP'))
CREATE TABLE KEY_GROUP.Modulo (
    id_modulo BIGINT IDENTITY(1,1),
    nombre NVARCHAR(255),
    descripcion NVARCHAR(255),

    CONSTRAINT PK_Modulo_id PRIMARY KEY (id_modulo)
);

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Modulo_por_Curso' AND schema_id = SCHEMA_ID('KEY_GROUP'))
CREATE TABLE KEY_GROUP.Modulo_por_Curso (
    id_modulo_curso BIGINT IDENTITY(1,1),
    codigo_curso BIGINT,
    id_modulo BIGINT,

    CONSTRAINT PK_Modulo_Curso_id PRIMARY KEY (id_modulo_curso),
    CONSTRAINT FK_Modulo_Curso_curso FOREIGN KEY (codigo_curso) REFERENCES KEY_GROUP.Curso(codigo_curso),
    CONSTRAINT FK_Modulo_Curso_modulo FOREIGN KEY (id_modulo) REFERENCES KEY_GROUP.Modulo(id_modulo)
);

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Trabajo_Practico' AND schema_id = SCHEMA_ID('KEY_GROUP'))
CREATE TABLE KEY_GROUP.Trabajo_Practico (
    id_trabajo_practico BIGINT IDENTITY(1,1),
    codigo_curso BIGINT,
    legajo_alumno BIGINT,
    fecha_evaluacion DATETIME2(6),
    nota BIGINT,

    CONSTRAINT PK_Trabajo_Practico_id PRIMARY KEY (id_trabajo_practico),
    CONSTRAINT FK_Trabajo_Practico_curso FOREIGN KEY (codigo_curso) REFERENCES KEY_GROUP.Curso(codigo_curso),
    CONSTRAINT FK_Trabajo_Practico_alumno FOREIGN KEY (legajo_alumno) REFERENCES KEY_GROUP.Alumno(legajo_alumno)
);

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Evaluacion' AND schema_id = SCHEMA_ID('KEY_GROUP'))
CREATE TABLE KEY_GROUP.Evaluacion (
    id_evaluacion BIGINT IDENTITY(1,1),
    fecha_evaluacion DATETIME2(6),
    nota INT,
    codigo_curso BIGINT,
    id_modulo BIGINT,
    presente bit,
    instancia BIGINT,
    legajo_alumno BIGINT,

    CONSTRAINT PK_Evaluacion_id PRIMARY KEY (id_evaluacion),
    CONSTRAINT FK_Evaluacion_curso FOREIGN KEY (codigo_curso) REFERENCES KEY_GROUP.Curso(codigo_curso),
    CONSTRAINT FK_Evaluacion_modulo FOREIGN KEY (id_modulo) REFERENCES KEY_GROUP.Modulo(id_modulo),
    CONSTRAINT FK_Evaluacion_alumno FOREIGN KEY (legajo_alumno) REFERENCES KEY_GROUP.Alumno(legajo_alumno)
);

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Final' AND schema_id = SCHEMA_ID('KEY_GROUP'))
CREATE TABLE KEY_GROUP.Final (
    id_final BIGINT IDENTITY(1,1),
    codigo_curso BIGINT,
    fecha_final DATE,
    hora TIME,

    CONSTRAINT PK_Final_id PRIMARY KEY (id_final),
    CONSTRAINT FK_Final_curso FOREIGN KEY (codigo_curso) REFERENCES KEY_GROUP.Curso(codigo_curso)
);

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Inscripcion_Final' AND schema_id = SCHEMA_ID('KEY_GROUP'))
CREATE TABLE KEY_GROUP.Inscripcion_Final (
    id_inscripcion_final BIGINT,
    fecha_inscripcion_final DATETIME2(6),
    legajo_alumno BIGINT,
    id_final BIGINT,

    CONSTRAINT PK_Inscripcion_Final_id PRIMARY KEY (id_inscripcion_final),
    CONSTRAINT FK_Inscripcion_Final_alumno FOREIGN KEY (legajo_alumno) REFERENCES KEY_GROUP.Alumno(legajo_alumno),
    CONSTRAINT FK_Inscripcion_Final_final FOREIGN KEY (id_final) REFERENCES KEY_GROUP.Final(id_final)
);

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Evaluacion_Final' AND schema_id = SCHEMA_ID('KEY_GROUP'))
CREATE TABLE KEY_GROUP.Evaluacion_Final (
    id_evaluacion_final BIGINT IDENTITY(1,1),
    id_final BIGINT,
    id_profesor INT,
    presente bit,
    nota INT,
    legajo_alumno BIGINT,
    descripcion NVARCHAR(255),

    CONSTRAINT PK_Evaluacion_Final_id PRIMARY KEY (id_evaluacion_final),
    CONSTRAINT FK_Evaluacion_Final_final FOREIGN KEY (id_final) REFERENCES KEY_GROUP.Final(id_final),
    CONSTRAINT FK_Evaluacion_Final_profesor FOREIGN KEY (id_profesor) REFERENCES KEY_GROUP.Profesor(id_profesor),
    CONSTRAINT FK_Evaluacion_Final_alumno FOREIGN KEY (legajo_alumno) REFERENCES KEY_GROUP.Alumno(legajo_alumno)
);

-- Migracion de datos --> Stored procedures
GO
CREATE PROCEDURE KEY_GROUP.migrar_Provincia
AS  
    BEGIN
        INSERT INTO KEY_GROUP.Provincia (nombre)
            SELECT DISTINCT Sede_Localidad AS Nombre FROM gd_esquema.Maestra WHERE Sede_Localidad IS NOT NULL --mal los campos de la maestra
            UNION
            SELECT DISTINCT Alumno_Provincia AS Nombre FROM gd_esquema.Maestra WHERE Alumno_Provincia IS NOT NULL
            UNION
            SELECT DISTINCT Profesor_Provincia AS Nombre FROM gd_esquema.Maestra WHERE Profesor_Provincia IS NOT NULL
    END
GO  


CREATE PROCEDURE KEY_GROUP.migrar_Localidad
AS 
    BEGIN        
        INSERT INTO KEY_GROUP.Localidad (nombre, id_provincia)
            SELECT DISTINCT Loc.Nombre, P.id_provincia
            FROM (
        
                SELECT DISTINCT Sede_Provincia AS Nombre, Sede_Localidad AS Provincia_nombre 
                --por campos invertidos en la maestra
                FROM gd_esquema.Maestra
                WHERE Sede_Localidad IS NOT NULL AND Sede_Provincia IS NOT NULL

                UNION

                SELECT DISTINCT Alumno_Localidad AS Nombre, Alumno_Provincia AS Provincia_nombre
                FROM gd_esquema.Maestra
                WHERE Alumno_Localidad IS NOT NULL AND Alumno_Provincia IS NOT NULL

                UNION

                SELECT DISTINCT Profesor_Localidad AS Nombre, Profesor_Provincia AS Provincia_nombre
                FROM gd_esquema.Maestra
                WHERE Profesor_Localidad IS NOT NULL AND Profesor_Provincia IS NOT NULL
                ) AS Loc
            JOIN KEY_GROUP.Provincia P ON Loc.Provincia_nombre = P.nombre 
            ORDER BY 1, 2
    END 
GO

CREATE PROCEDURE KEY_GROUP.migrar_Profesor
AS 
    BEGIN
        INSERT INTO KEY_GROUP.Profesor (dni, nombre, apellido, fecha_nacimiento, mail, direccion, telefono, id_localidad)
            SELECT P.Dni, P.Nombre, P.Apellido, P.FechaNacimiento, P.Mail, P.Direccion, P.Telefono, L.id_localidad
            FROM (SELECT DISTINCT   Profesor_Dni AS Dni, 
                                    Profesor_nombre AS Apellido, --estan invertidos nombre y apellido
                                    Profesor_Apellido AS Nombre, 
                                    Profesor_FechaNacimiento AS FechaNacimiento, 
                                    Profesor_Mail AS Mail, 
                                    Profesor_Direccion AS Direccion, 
                                    Profesor_Telefono AS Telefono,
                                    Profesor_Localidad AS Localidad
                    FROM GD2C2025.gd_esquema.Maestra WHERE Profesor_Dni IS NOT NULL) AS P
                    JOIN KEY_GROUP.Localidad L ON L.nombre = P.Localidad
    END
GO

CREATE PROCEDURE KEY_GROUP.migrar_Institucion
AS
    BEGIN

        INSERT INTO KEY_GROUP.Institucion (cuit, nombre, razon_social)
        SELECT DISTINCT Institucion_Cuit, Institucion_Nombre, Institucion_RazonSocial
            FROM gd_esquema.Maestra
            WHERE Institucion_Cuit IS NOT NULL AND Institucion_Nombre IS NOT NULL AND Institucion_RazonSocial IS NOT NULL
    END
GO

CREATE PROCEDURE KEY_GROUP.migrar_Sede 
AS
    BEGIN
        INSERT INTO KEY_GROUP.Sede (id_institucion, nombre, direccion, telefono, mail, id_localidad)
            SELECT DISTINCT I.Id_Institucion, M.Sede_Nombre, M.Sede_Direccion, M.Sede_Telefono, M.Sede_Mail, L.id_localidad
            FROM gd_esquema.Maestra M

            JOIN KEY_GROUP.Institucion I ON M.Institucion_Nombre = I.nombre
            JOIN KEY_GROUP.Localidad L ON M.Sede_Provincia = L.nombre
    END
GO


CREATE PROCEDURE KEY_GROUP.migrar_Categoria
AS
    BEGIN
        INSERT INTO KEY_GROUP.Categoria (descripcion)
            SELECT DISTINCT Curso_Categoria 
            FROM gd_esquema.Maestra 
            WHERE Curso_Categoria IS NOT NULL
            ORDER BY 1
    END
GO

CREATE PROCEDURE KEY_GROUP.migrar_Turno
AS
    BEGIN
        INSERT INTO KEY_GROUP.Turno (tipo_turno, descripcion)
        SELECT DISTINCT LEFT(Curso_Turno,1) AS Tipo_Turno, Curso_Turno
        FROM gd_esquema.Maestra
        WHERE Curso_Turno IS NOT NULL
		ORDER BY 1
    END
GO

CREATE PROCEDURE KEY_GROUP.migrar_Curso 
AS
    BEGIN
        INSERT INTO KEY_GROUP.Curso (codigo_curso, nombre, descripcion, id_categoria, fecha_inicio, fecha_fin, duracion_meses, tipo_turno, precio_mensual, id_profesor)
            SELECT DISTINCT M.Curso_Codigo, M.Curso_Nombre, M.Curso_Descripcion, C.id_categoria, M.Curso_FechaInicio, M.Curso_FechaFin, M.Curso_DuracionMeses, T.tipo_turno, M.Curso_PrecioMensual, P.id_profesor
            FROM gd_esquema.Maestra M

            JOIN KEY_GROUP.Categoria C ON C.descripcion = M.Curso_Categoria
            JOIN KEY_GROUP.Turno T ON T.descripcion = M.Curso_Turno
            JOIN KEY_GROUP.Profesor P ON P.dni = M.Profesor_Dni
            ORDER BY 1
    END
GO

CREATE PROCEDURE KEY_GROUP.migrar_Sedes_por_Curso
AS
    BEGIN
        INSERT INTO KEY_GROUP.Sedes_por_Curso (codigo_curso, id_sede)
            SELECT DISTINCT Curso_Codigo, S.id_sede
            FROM gd_esquema.Maestra M

            JOIN KEY_GROUP.Sede S ON M.Sede_Nombre = S.nombre
            ORDER BY 2
    END
GO

CREATE PROCEDURE KEY_GROUP.migrar_Encuesta
AS
    BEGIN
        INSERT INTO KEY_GROUP.Encuesta (fecha_registro, observaciones, codigo_curso) 
            SELECT DISTINCT M.Encuesta_FechaRegistro, M.Encuesta_Observacion, M.Curso_Codigo
            FROM gd_esquema.Maestra M
            WHERE Encuesta_FechaRegistro IS NOT NULL AND Encuesta_Observacion IS NOT NULL
            ORDER BY 1
    END
GO

CREATE PROCEDURE KEY_GROUP.migrar_Pregunta
AS
    BEGIN
        INSERT INTO KEY_GROUP.Pregunta (pregunta, respuesta, id_encuesta)
            SELECT M.Encuesta_Pregunta1, M.Encuesta_Nota1, E.id_encuesta
            FROM gd_esquema.Maestra M
            JOIN KEY_GROUP.Encuesta E ON E.observaciones = M.Encuesta_Observacion

            UNION

            SELECT M.Encuesta_Pregunta2, M.Encuesta_Nota2, E.id_encuesta
            FROM gd_esquema.Maestra M
            JOIN KEY_GROUP.Encuesta E ON E.observaciones = M.Encuesta_Observacion

            UNION

            SELECT M.Encuesta_Pregunta3, M.Encuesta_Nota3, E.id_encuesta
            FROM gd_esquema.Maestra M
            JOIN KEY_GROUP.Encuesta E ON E.observaciones = M.Encuesta_Observacion

            UNION

            SELECT M.Encuesta_Pregunta4, M.Encuesta_Nota4, E.id_encuesta
            FROM gd_esquema.Maestra M
            JOIN KEY_GROUP.Encuesta E ON E.observaciones = M.Encuesta_Observacion

            ORDER BY 3, 1
    END
GO

CREATE PROCEDURE KEY_GROUP.migrar_Detalle_factura
AS
    BEGIN
        INSERT INTO KEY_GROUP.Detalle_factura (periodo, importe, codigo_curso)
            SELECT FORMAT(Factura_FechaEmision, 'MM/yyyy') AS periodo, M.Detalle_Factura_Importe, M.Curso_Codigo
            FROM gd_esquema.Maestra M
            WHERE M.Detalle_Factura_Importe IS NOT NULL
    END
GO

CREATE PROCEDURE KEY_GROUP.migrar_Alumno
AS
    BEGIN 
        INSERT INTO KEY_GROUP.Alumno (legajo_alumno, dni, nombre, apellido, fecha_nacimiento, mail, direccion, id_localidad, telefono)
            SELECT DISTINCT M.Alumno_Legajo, M.Alumno_Dni, M.Alumno_Nombre, M.Alumno_Apellido, M.Alumno_FechaNacimiento, M.Alumno_Mail, M.Alumno_Direccion, L.id_localidad, M.Alumno_Telefono
            FROM gd_esquema.Maestra M

            JOIN KEY_GROUP.Localidad L ON L.nombre = M.Alumno_Localidad
            JOIN KEY_GROUP.Provincia P ON P.id_provincia = L.id_provincia AND P.nombre = M.Alumno_Provincia
            ORDER BY 1
    END
GO

CREATE PROCEDURE KEY_GROUP.migrar_Factura
AS
    BEGIN --cambié el identity de factura_numero por el atributo factura_numero de la tabla Maestra
        INSERT INTO KEY_GROUP.Factura (factura_numero, fecha_emision, fecha_vencimiento, importe_total, id_detalle_factura, legajo_alumno)
            SELECT DISTINCT M.Factura_Numero, M.Factura_FechaEmision, M.Factura_FechaVencimiento, M.Factura_Total, D.id_detalle_factura, M.Alumno_Legajo
            FROM gd_esquema.Maestra M

            JOIN KEY_GROUP.Detalle_Factura D ON D.importe = M.Detalle_Factura_Importe
    END
GO

CREATE PROCEDURE KEY_GROUP.migrar_Medio_de_pago
AS
    BEGIN
        INSERT INTO KEY_GROUP.Medio_de_pago (codigo_medio_de_pago)
            SELECT DISTINCT Pago_MedioPago 
            FROM gd_esquema.Maestra 
            WHERE Pago_MedioPago IS NOT NULL
    END
GO

CREATE PROCEDURE KEY_GROUP.migrar_Pago 
AS
    BEGIN
        INSERT INTO KEY_GROUP.Pago (fecha_pago, factura_numero, codigo_medio_de_pago, importe)
            SELECT M.Pago_Fecha, F.factura_numero, MP.codigo_medio_de_pago, M.Pago_Importe
            FROM gd_esquema.Maestra M 
                JOIN KEY_GROUP.Medio_de_pago MP ON MP.codigo_medio_de_pago = M.Pago_MedioPago
                JOIN KEY_GROUP.Factura F ON F.factura_numero = M.Factura_Numero -- chequear esto despues, factura_numero no es lo mismo que factura_numero
            WHERE M.Pago_Fecha IS NOT NULL AND M.Pago_Importe IS NOT NULL
    END
GO

CREATE PROCEDURE KEY_GROUP.migrar_Estado_inscripcion
AS
    BEGIN
        INSERT INTO KEY_GROUP.Estado_inscripcion 
            SELECT DISTINCT Inscripcion_Estado
            FROM gd_esquema.Maestra
            WHERE Inscripcion_Estado IS NOT NULL
    END
GO

CREATE PROCEDURE KEY_GROUP.migrar_Inscripcion
AS
    BEGIN 
        INSERT INTO KEY_GROUP.Inscripcion (fecha_inscripcion, fecha_respuesta, codigo_estado_inscripcion, codigo_curso, legajo_alumno)
            SELECT M.Inscripcion_Fecha, M.Inscripcion_FechaRespuesta, E.codigo_estado_inscripcion, M.Curso_Codigo, M.Alumno_Legajo
            FROM gd_esquema.Maestra M
            JOIN KEY_GROUP.Estado_Inscripcion E ON E.codigo_estado_inscripcion = M.Inscripcion_Estado
    END
GO

CREATE PROCEDURE KEY_GROUP.migrar_Dia
AS
    BEGIN
        INSERT INTO KEY_GROUP.Dia 
            SELECT DISTINCT LEFT(Curso_Dia, 3)
            FROM gd_esquema.Maestra
            WHERE Curso_Dia IS NOT NULL
    END
GO

CREATE PROCEDURE KEY_GROUP.migrar_Curso_por_dia
AS
    BEGIN
        INSERT INTO KEY_GROUP.Curso_por_Dia (dia, codigo_curso) 
            SELECT DISTINCT LEFT(Curso_Dia, 3), M.Curso_Codigo
            FROM gd_esquema.Maestra M
            WHERE Curso_Dia IS NOT NULL
    END
GO

CREATE PROCEDURE KEY_GROUP.migrar_Modulo
AS
    BEGIN
        INSERT INTO KEY_GROUP.Modulo(nombre, descripcion)
            SELECT DISTINCT Modulo_Nombre, Modulo_Descripcion
            FROM gd_esquema.Maestra
            WHERE Modulo_Nombre IS NOT NULL AND Modulo_Descripcion IS NOT NULL
            ORDER BY 1
    END
GO

CREATE PROCEDURE KEY_GROUP.migrar_Modulo_por_Curso
AS
    BEGIN
        INSERT INTO KEY_GROUP.Modulo_por_Curso(id_modulo, codigo_curso)
            SELECT DISTINCT md.id_modulo, M.Curso_Codigo
            FROM gd_esquema.Maestra M

            JOIN KEY_GROUP.Modulo md ON M.Modulo_Descripcion = md.descripcion
    END
GO

CREATE PROCEDURE KEY_GROUP.migrar_Trabajo_practico
AS
    BEGIN
        INSERT INTO KEY_GROUP.Trabajo_practico (fecha_evaluacion, nota, codigo_curso, legajo_alumno)
            SELECT Trabajo_Practico_FechaEvaluacion, Trabajo_Practico_Nota, Curso_Codigo, Alumno_Legajo
            FROM gd_esquema.Maestra
            WHERE Trabajo_Practico_FechaEvaluacion IS NOT NULL
    END
GO

CREATE PROCEDURE KEY_GROUP.migrar_Evaluacion 
AS
    BEGIN
        INSERT INTO KEY_GROUP.Evaluacion (fecha_evaluacion, nota, presente, instancia)
            SELECT Evaluacion_Curso_fechaEvaluacion, Evaluacion_Curso_Nota, Evaluacion_Curso_Presente, Evaluacion_Curso_Instancia
            FROM gd_esquema.Maestra
            WHERE Evaluacion_Curso_fechaEvaluacion IS NOT NULL
    END
GO

CREATE PROCEDURE KEY_GROUP.migrar_Final
AS
    BEGIN
        INSERT INTO KEY_GROUP.Final (fecha_final, hora, codigo_curso) 
        SELECT DISTINCT M.Examen_Final_Fecha, M.Examen_Final_Hora, M.Curso_Codigo
        FROM gd_esquema.Maestra M
        WHERE M.Examen_Final_Fecha IS NOT NULL
    END
GO

CREATE PROCEDURE KEY_GROUP.migrar_Inscripcion_final
AS
    BEGIN
        INSERT INTO KEY_GROUP.Inscripcion_final (id_inscripcion_final, fecha_inscripcion_final, legajo_alumno, id_final)
            SELECT DISTINCT Inscripcion_Final_Nro, Inscripcion_Final_Fecha, M.Alumno_Legajo, F.id_final
            FROM gd_esquema.Maestra M

            JOIN KEY_GROUP.Final F ON M.Examen_Final_Fecha = F.fecha_final AND M.Examen_Final_Hora = F.hora

            WHERE Inscripcion_Final_Nro IS NOT NULL
            ORDER BY 1
    END
GO

CREATE PROCEDURE KEY_GROUP.migrar_Evaluacion_final
AS
    BEGIN
        INSERT INTO KEY_GROUP.Evaluacion_final (presente, nota, descripcion, id_final, id_profesor, legajo_alumno)
            SELECT DISTINCT Evaluacion_Final_Presente, Evaluacion_Final_Nota, Examen_Final_Descripcion, F.id_final, P.id_profesor, M.Alumno_Legajo
            FROM gd_esquema.Maestra M

            JOIN KEY_GROUP.Final F      ON M.Examen_Final_Fecha = F.fecha_final AND M.Examen_Final_Hora = F.hora
            JOIN KEY_GROUP.Profesor P   ON M.Profesor_Dni = P.dni AND M.Profesor_Mail = P.mail
    END
GO

CREATE PROCEDURE KEY_GROUP.Correccion_General
AS
    BEGIN
        ---provincia---
        UPDATE KEY_GROUP.Provincia
        SET nombre = REPLACE(nombre, ';', 'go')
        WHERE nombre LIKE '%;%';

        ---localidad---
        UPDATE KEY_GROUP.Localidad
        SET nombre = REPLACE(nombre, ';', 'Go')
        WHERE nombre LIKE ';%';

        UPDATE KEY_GROUP.Localidad
        SET nombre = REPLACE(nombre, ';', 'go')
        WHERE nombre LIKE '%;%';        

        ---profesor---
        UPDATE KEY_GROUP.Profesor
		SET apellido = REPLACE(apellido,'DE LAS MERCEDES','De Las Mercedes'),
		mail = REPLACE(mail, 'PobleteDE LAS MERCEDES@gmail.com', 'PobleteDeLasMercedes@gmail.com')
		WHERE Id_profesor = 1;

        ---alumno---
        --apellido
        UPDATE KEY_GROUP.Alumno
        SET apellido = REPLACE(apellido, ';', 'Go')
        WHERE apellido LIKE ';%';
        UPDATE KEY_GROUP.Alumno
        SET apellido = REPLACE(apellido, ';', 'go')
        WHERE apellido LIKE '%_;%';
        --mail
        UPDATE KEY_GROUP.Alumno
        SET mail = REPLACE(mail, ';', 'go')
        WHERE mail LIKE '%_;%';
        --nombre
        UPDATE KEY_GROUP.Alumno
        SET nombre = REPLACE(nombre, ';', 'go')
        WHERE nombre LIKE '%_;%';
        --direccion
        UPDATE KEY_GROUP.Alumno
        SET direccion = REPLACE(direccion, ';', 'go')
        WHERE direccion LIKE '%_;%';
    END 
GO

CREATE NONCLUSTERED INDEX IX_Localidad_provincia ON KEY_GROUP.Localidad(id_provincia);
CREATE NONCLUSTERED INDEX IX_Profesor_localidad ON KEY_GROUP.Profesor(id_localidad);
CREATE NONCLUSTERED INDEX IX_Sede_institucion ON KEY_GROUP.Sede(id_institucion);
CREATE NONCLUSTERED INDEX IX_Sede_localidad ON KEY_GROUP.Sede(id_localidad);
CREATE NONCLUSTERED INDEX IX_Curso_categoria ON KEY_GROUP.Curso(id_categoria);
CREATE NONCLUSTERED INDEX IX_Sede_por_Curso_sede ON KEY_GROUP.Sedes_por_Curso(id_sede);
CREATE NONCLUSTERED INDEX IX_Sede_por_Curso_curso ON KEY_GROUP.Sedes_por_Curso(codigo_curso);
CREATE NONCLUSTERED INDEX IX_Curso_turno ON KEY_GROUP.Curso(tipo_turno);
CREATE NONCLUSTERED INDEX IX_Curso_profesor ON KEY_GROUP.Curso(id_profesor);
CREATE NONCLUSTERED INDEX IX_Encuesta_curso ON KEY_GROUP.Encuesta(codigo_curso);
CREATE NONCLUSTERED INDEX IX_Pregunta_encuesta ON KEY_GROUP.Pregunta(id_encuesta);
CREATE NONCLUSTERED INDEX IX_Detalle_Factura_curso ON KEY_GROUP.Detalle_Factura(codigo_curso);
CREATE NONCLUSTERED INDEX IX_Alumno_localidad ON KEY_GROUP.Alumno(id_localidad);
CREATE NONCLUSTERED INDEX IX_Factura_detalle ON KEY_GROUP.Factura(id_detalle_factura);
CREATE NONCLUSTERED INDEX IX_Factura_alumno ON KEY_GROUP.Factura(legajo_alumno);
CREATE NONCLUSTERED INDEX IX_Pago_factura ON KEY_GROUP.Pago(factura_numero);
CREATE NONCLUSTERED INDEX IX_Pago_medio_pago ON KEY_GROUP.Pago(codigo_medio_de_pago);
CREATE NONCLUSTERED INDEX IX_Inscripcion_curso ON KEY_GROUP.Inscripcion(codigo_curso);
CREATE NONCLUSTERED INDEX IX_Inscripcion_alumno ON KEY_GROUP.Inscripcion(legajo_alumno);
CREATE NONCLUSTERED INDEX IX_Inscripcion_estado ON KEY_GROUP.Inscripcion(codigo_estado_inscripcion);
CREATE NONCLUSTERED INDEX IX_Modulo_Curso_curso ON KEY_GROUP.Modulo_por_Curso(codigo_curso);
CREATE NONCLUSTERED INDEX IX_Modulo_Curso_modulo ON KEY_GROUP.Modulo_por_Curso(id_modulo);
CREATE NONCLUSTERED INDEX IX_Trabajo_Practico_curso ON KEY_GROUP.Trabajo_Practico(codigo_curso);
CREATE NONCLUSTERED INDEX IX_Trabajo_Practico_alumno ON KEY_GROUP.Trabajo_Practico(legajo_alumno);
CREATE NONCLUSTERED INDEX IX_Evaluacion_curso ON KEY_GROUP.Evaluacion(codigo_curso);
CREATE NONCLUSTERED INDEX IX_Evaluacion_modulo ON KEY_GROUP.Evaluacion(id_modulo);
CREATE NONCLUSTERED INDEX IX_Evaluacion_alumno ON KEY_GROUP.Evaluacion(legajo_alumno);
CREATE NONCLUSTERED INDEX IX_Final_curso ON KEY_GROUP.Final(codigo_curso);
CREATE NONCLUSTERED INDEX IX_Inscripcion_Final_alumno ON KEY_GROUP.Inscripcion_Final(legajo_alumno);
CREATE NONCLUSTERED INDEX IX_Inscripcion_Final_final ON KEY_GROUP.Inscripcion_Final(id_final);
CREATE NONCLUSTERED INDEX IX_Evaluacion_Final_final ON KEY_GROUP.Evaluacion_Final(id_final);
CREATE NONCLUSTERED INDEX IX_Evaluacion_Final_profesor ON KEY_GROUP.Evaluacion_Final(id_profesor);
CREATE NONCLUSTERED INDEX IX_Evaluacion_Final_alumno ON KEY_GROUP.Evaluacion_Final(legajo_alumno);

BEGIN TRANSACTION
 BEGIN TRY
	EXECUTE KEY_GROUP.migrar_Provincia
    EXECUTE KEY_GROUP.migrar_Localidad
    EXECUTE KEY_GROUP.migrar_Profesor
    EXECUTE KEY_GROUP.migrar_Institucion 
    EXECUTE KEY_GROUP.migrar_Sede
    EXECUTE KEY_GROUP.migrar_Categoria
    EXECUTE KEY_GROUP.migrar_Turno
    EXECUTE KEY_GROUP.migrar_Curso
    EXECUTE KEY_GROUP.migrar_Sedes_por_Curso
    EXECUTE KEY_GROUP.migrar_Encuesta--
    EXECUTE KEY_GROUP.migrar_Pregunta
    EXECUTE KEY_GROUP.migrar_Detalle_factura--
    EXECUTE KEY_GROUP.migrar_Alumno
    EXECUTE KEY_GROUP.migrar_Factura
    EXECUTE KEY_GROUP.migrar_Medio_de_pago--
    EXECUTE KEY_GROUP.migrar_Pago
    EXECUTE KEY_GROUP.migrar_Estado_inscripcion--
    EXECUTE KEY_GROUP.migrar_Inscripcion--
    EXECUTE KEY_GROUP.migrar_Dia--
    EXECUTE KEY_GROUP.migrar_Curso_por_dia--
    EXECUTE KEY_GROUP.migrar_Modulo
    EXECUTE KEY_GROUP.migrar_Modulo_por_Curso--
    EXECUTE KEY_GROUP.migrar_Trabajo_practico--
    EXECUTE KEY_GROUP.migrar_Evaluacion
    EXECUTE KEY_GROUP.migrar_Final--
    EXECUTE KEY_GROUP.migrar_Inscripcion_final
    EXECUTE KEY_GROUP.migrar_Evaluacion_final
    EXECUTE KEY_GROUP.Correccion_General
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
	THROW 50001, 'Ocurrió un error en la transaccion de datos.',1;
END CATCH
    PRINT 'Transaccion completada correctamente';
COMMIT TRANSACTION

SELECT * FROM KEY_GROUP.Alumno