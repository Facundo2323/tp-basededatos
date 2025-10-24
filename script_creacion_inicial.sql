USE GD2C2025
GO

CREATE SCHEMA KEY_GROUP;
GO

--Creacion de las tablas

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Provincia' AND schema_id = SCHEMA_ID('KEY_GROUP')) 
CREATE TABLE KEY_GROUP.Provincia (
    --id autoincremental, arranca en uno y salta de a 1
    id_provincia INT IDENTITY(1,1) PRIMARY KEY, 
    nombre NVARCHAR(255)
);

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Localidad' AND schema_id = SCHEMA_ID('KEY_GROUP'))
CREATE TABLE KEY_GROUP.Localidad (
    id_localidad INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(255),
    FOREIGN KEY (id_provincia) REFERENCES KEY_GROUP.Provincia(id_provincia)
);

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Profesor' AND schema_id = SCHEMA_ID('KEY_GROUP'))
CREATE TABLE KEY_GROUP.Profesor (
    id_profesor INT IDENTITY(1,1) PRIMARY KEY,
    dni NVARCHAR(255),
    FOREIGN KEY (id_localidad) REFERENCES KEY_GROUP.Localidad(id_localidad),
    nombre NVARCHAR(255),
    apellido NVARCHAR(255),
    fecha_nacimiento DATETIME2(6),
    mail NVARCHAR(255),
    direccion NVARCHAR(255),
    telefono NVARCHAR(255)
);

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Institucion' AND schema_id = SCHEMA_ID('KEY_GROUP'))
CREATE TABLE KEY_GROUP.Institucion (
    id_institucion INT IDENTITY(1,1) PRIMARY KEY,
    cuit_institucion NVARCHAR(255),
    nombre NVARCHAR(255),
    razon_social NVARCHAR(255)
);

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Sede' AND schema_id = SCHEMA_ID('KEY_GROUP'))
CREATE TABLE KEY_GROUP.Sede (
    id_sede BIGINT IDENTITY(1,1) PRIMARY KEY,
    FOREIGN KEY (id_institucion) REFERENCES KEY_GROUP.Institucion(id_institucion),
    nombre NVARCHAR(255),
    direccion NVARCHAR(255),
    telefono NVARCHAR(255)
    mail NVARCHAR(255),
    FOREIGN KEY (id_localidad) REFERENCES KEY_GROUP.Localidad(id_localidad)
);

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Categoria' AND schema_id = SCHEMA_ID('KEY_GROUP'))
CREATE TABLE KEY_GROUP.Categoria (
    id_categoria BIGINT IDENTITY(1,1) PRIMARY KEY,
    descripcion VARCHAR(255)
);

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Turno' AND schema_id = SCHEMA_ID('KEY_GROUP'))
CREATE TABLE KEY_GROUP.Turno (
    tipo_turno CHAR(1) IDENTITY(1,1) PRIMARY KEY,
    descripcion VARCHAR(255)
);

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Categoria' AND schema_id = SCHEMA_ID('KEY_GROUP'))
CREATE TABLE KEY_GROUP.Categoria (
    id_pregunta BIGINT IDENTITY(1,1) PRIMARY KEY,
    pregunta NVARCHAR(255),
    respuesta BIGINT, 
    FOREIGN KEY (id_encuesta) REFERENCES KEY_GROUP.Encuesta(id_encuesta)
);

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Curso' AND schema_id = SCHEMA_ID('KEY_GROUP'))
CREATE TABLE KEY_GROUP.Curso (
    codigo_curso BIGINT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(255),
    descripcion NVARCHAR(255) 
    FOREIGN KEY (id_categoria) REFERENCES KEY_GROUP.Categoria(id_categoria),
    fecha_inicio DATETIME2(6),
    fecha_fin DATETIME2(6), 
    FOREIGN KEY (id_sede) REFERENCES KEY_GROUP.Sede(id_sede),
    duracion_meses BIGINT,
    FOREIGN KEY (tipo_turno) REFERENCES KEY_GROUP.Turno(tipo_turno),
    precio_mensual DECIMAL(38,2),
    FOREIGN KEY (id_profesor) REFERENCES KEY_GROUP.Profesor(id_profesor)
);

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Encuesta' AND schema_id = SCHEMA_ID('KEY_GROUP'))
CREATE TABLE KEY_GROUP.Encuesta (
    id_encuesta BIGINT IDENTITY(1,1) PRIMARY KEY,
    FOREIGN KEY (codigo_curso) REFERENCES KEY_GROUP.Curso(codigo_curso),
    fecha_registro DATETIME2(6),
    observaciones NVARCHAR(255)
);

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Pregunta' AND schema_id = SCHEMA_ID('KEY_GROUP'))
CREATE TABLE KEY_GROUP.Pregunta (
    id_pregunta BIGINT IDENTITY(1,1) PRIMARY KEY,
    pregunta NVARCHAR(255),
    respuesta BIGINT, -- nota1, nota2, nota3, nota4
    FOREIGN KEY (id_encuesta) REFERENCES KEY_GROUP.Encuesta(id_encuesta)
);







-- DETALLE_FACTURA
-- ALUMNO
-- FACTURA
-- MEDIO_DE_PAGO
-- PAGO
-- ESTADO_INSCRIPCION
-- INSCRIPCION
-- DIA
-- CURSO_POR_DIA
-- MODULO
-- MODULO_POR_CURSO
-- TP
-- EVALUACION
-- FINAL
-- INSCRIPCION_FINAL
-- EVALUACION_FINAL