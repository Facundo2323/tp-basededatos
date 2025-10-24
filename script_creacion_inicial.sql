USE GD2C2025
GO

CREATE SCHEMA KEY_GROUP;
GO

--Creacion de las tablas

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Provincia' AND schema_id = SCHEMA_ID('KEY_GROUP')) 
CREATE TABLE KEY_GROUP.Provincia (
    --id autoincremental, arranca en uno y salta de a 1
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
    cuit_institucion NVARCHAR(255),
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
    telefono NVARCHAR(255)
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
    codigo_curso BIGINT IDENTITY(1,1),
    nombre NVARCHAR(255),
    descripcion NVARCHAR(255) 
    id_categoria BIGINT,
    fecha_inicio DATETIME2(6),
    fecha_fin DATETIME2(6), 
    id_sede BIGINT,
    duracion_meses BIGINT,
    tipo_turno CHAR(1),
    precio_mensual DECIMAL(38,2),
    id_profesor BIGINT,

    CONSTRAINT PK_Curso_codigo PRIMARY KEY (codigo_curso),
    CONSTRAINT FK_Curso_categoria FOREIGN KEY (id_categoria) REFERENCES KEY_GROUP.Categoria(id_categoria),
    CONSTRAINT FK_Curso_sede FOREIGN KEY (id_sede) REFERENCES KEY_GROUP.Sede(id_sede),
    CONSTRAINT FK_Curso_tipo_turno FOREIGN KEY (tipo_turno) REFERENCES KEY_GROUP.Turno(tipo_turno),
    CONSTRAINT FK_Curso_profesor FOREIGN KEY (id_profesor) REFERENCES KEY_GROUP.Profesor(id_profesor)
);

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Encuesta' AND schema_id = SCHEMA_ID('KEY_GROUP'))
CREATE TABLE KEY_GROUP.Encuesta (
    id_encuesta BIGINT IDENTITY(1,1),
    codigo_curso BIGINT,
    fecha_registro DATETIME2(6),
    observaciones NVARCHAR(255),

    CONSTRAINT PK_Encuesta_id PRIMARY KEY (id_encuesta)
    CONSTRAINT FK_Encuesta_codigo_curso FOREIGN KEY (codigo_curso) REFERENCES KEY_GROUP.Curso(codigo_curso)
);

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Pregunta' AND schema_id = SCHEMA_ID('KEY_GROUP'))
CREATE TABLE KEY_GROUP.Pregunta (
    id_pregunta BIGINT IDENTITY(1,1),
    pregunta NVARCHAR(255),
    respuesta INT, -- nota(1 al 10)

    CONSTRAINT PK_Pregunta_id PRIMARY KEY (id_pregunta),
    CONSTRAINT FK_Pregunta_encuesta FOREIGN KEY (id_encuesta) REFERENCES KEY_GROUP.Encuesta(id_encuesta)
);

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Detalle_Factura' AND schema_id = SCHEMA_ID('KEY_GROUP'))
CREATE TABLE KEY_GROUP.Detalle_Factura (
    id_detalle_factura BIGINT IDENTITY(1,1),
    codigo_curso BIGINT,
    periodo BIGINT, --mes/año
    importe DECIMAL(18,2),

    CONSTRAINT PK_Detalle_Factura_id PRIMARY KEY (id_detalle_factura),
    CONSTRAINT FK_Inscripcion_codigo_curso FOREIGN KEY (codigo_curso) REFERENCES KEY_GROUP.Curso(codigo_curso)
)

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Alumno' AND schema_id = SCHEMA_ID('KEY_GROUP'))
CREATE TABLE KEY_GROUP.Alumno (
    legajo_alumno BIGINT IDENTITY(1,1),
    dni BIGINT,
    nombre NVARCHAR(255),
    apellido NVARCHAR(255),
    fecha_nacimiento DATETIME2(6)
    mail NVARCHAR(255),
    direccion NVARCHAR(255),
    id_localidad INT,
    telefono NVARCHAR(255),

    CONSTRAINT PK_Alumno_legajo PRIMARY KEY (legajo_alumno),
    CONSTRAINT FK_Alumno_localidad FOREIGN KEY (id_localidad) REFERENCES KEY_GROUP.Localidad(id_localidad)
)

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Factura' AND schema_id = SCHEMA_ID('KEY_GROUP'))
CREATE TABLE KEY_GROUP.Factura (
    id_factura BIGINT IDENTITY(1,1),
    fecha_emision DATETIME2(6),
    fecha_vencimiento DATETIME2(6),
    importe_total DECIMAL(18,2),
    id_detalle_factura BIGINT,
    legajo_alumno BIGINT,

    CONSTRAINT PK_Factura_id PRIMARY KEY (id_factura),
    CONSTRAINT FK_Factura_detalle FOREIGN KEY (id_detalle_factura) REFERENCES KEY_GROUP.Detalle_Factura(id_detalle_factura),
    CONSTRAINT FK_Factura_alumno FOREIGN KEY (legajo_alumno) REFERENCES KEY_GROUP.Alumno(legajo_alumno)
)

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Medio_de_Pago' AND schema_id = SCHEMA_ID('KEY_GROUP'))
CREATE TABLE KEY_GROUP.Medio_de_Pago (
    codigo_medio_de_pago BIGINT IDENTITY(1,1),
    descripcion NVARCHAR(255),

    CONSTRAINT PK_Medio_Pago_codigo PRIMARY KEY (codigo_medio_de_pago)
)

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Pago' AND schema_id = SCHEMA_ID('KEY_GROUP'))
CREATE TABLE KEY_GROUP.Pago (
    id_pago BIGINT IDENTITY(1,1),
    id_factura BIGINT,
    fecha_pago DATETIME2(6),
    codigo_medio_de_pago BIGINT,
    importe DECIMAL(18,2),

    CONSTRAINT PK_Pago_id PRIMARY KEY (id_pago)
    CONSTRAINT FK_Pago_factura FOREIGN KEY (id_factura) REFERENCES KEY_GROUP.Factura(id_factura),
    CONSTRAINT FK_Pago_medio_pago FOREIGN KEY (codigo_medio_de_pago) REFERENCES KEY_GROUP.Medio_de_Pago(codigo_medio_de_pago)
)

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Estado_Inscripcion' AND schema_id = SCHEMA_ID('KEY_GROUP'))
CREATE TABLE KEY_GROUP.Estado_Inscripcion (
    codigo_estado_inscripcion VARCHAR(255) NOT NULL,

    CONSTRAINT PK_Estado_Inscripcion_codigo PRIMARY KEY (codigo_estado_inscripcion)
)

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
)

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Dia' AND schema_id = SCHEMA_ID('KEY_GROUP'))
CREATE TABLE KEY_GROUP.Dia (
    dia CHAR(3) NOT NULL,

    CONSTRAINT PK_Dia_dia PRIMARY KEY (dia)
)

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Curso_por_Dia' AND schema_id = SCHEMA_ID('KEY_GROUP'))
CREATE TABLE KEY_GROUP.Curso_por_Dia (
    dia CHAR(3) NOT NULL,
    codigo_curso BIGINT NOT NULL,
    
    CONSTRAINT PK_Curso_por_Dia PRIMARY KEY (dia, codigo_curso),
    CONSTRAINT FK_Curso_por_Dia_Dia FOREIGN KEY (dia) REFERENCES KEY_GROUP.Dia(dia),
    CONSTRAINT FK_Curso_por_Dia_Curso FOREIGN KEY (codigo_curso) REFERENCES KEY_GROUP.Curso(codigo_curso)
)

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Modulo' AND schema_id = SCHEMA_ID('KEY_GROUP'))
CREATE TABLE KEY_GROUP.Modulo (
    id_modulo BIGINT IDENTITY(1,1),
    nombre NVARCHAR(255),
    descripcion NVARCHAR(255),

    CONSTRAINT PK_Modulo_id PRIMARY KEY (id_modulo)
)

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Modulo_por_Curso' AND schema_id = SCHEMA_ID('KEY_GROUP'))
CREATE TABLE KEY_GROUP.Modulo_por_Curso (
    id_modulo_curso BIGINT IDENTITY(1,1),
    id_curso BIGINT,
    id_modulo BIGINT,

    CONSTRAINT PK_Modulo_Curso_id PRIMARY KEY (id_modulo_curso),
    CONSTRAINT FK_Modulo_Curso_curso FOREIGN KEY (id_curso) REFERENCES KEY_GROUP.Curso(id_curso),
    CONSTRAINT FK_Modulo_Curso_modulo FOREIGN KEY (id_modulo) REFERENCES KEY_GROUP.Modulo(id_modulo)
)

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Trabajo_Practico' AND schema_id = SCHEMA_ID('KEY_GROUP'))
CREATE TABLE KEY_GROUP.Trabajo_Practico (
    id_trabajo_practico BIGINT IDENTITY(1,1),
    id_curso BIGINT,
    legajo_alumno BIGINT,
    fecha_evaluacion DATETIME2(6),
    nota BIGINT,

    CONSTRAINT PK_Trabajo_Practico_id PRIMARY KEY (id_trabajo_practico),
    CONSTRAINT FK_Trabajo_Practico_curso FOREIGN KEY (id_curso) REFERENCES KEY_GROUP.Curso(id_curso),
    CONSTRAINT FK_Trabajo_Practico_alumno FOREIGN KEY (legajo_alumno) REFERENCES KEY_GROUP.Alumno(legajo_alumno)
)

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Evaluacion' AND schema_id = SCHEMA_ID('KEY_GROUP'))
CREATE TABLE KEY_GROUP.Evaluacion (
    id_evaluacion BIGINT IDENTITY(1,1),
    fecha_evaluacion DATETIME2(6),
    nota INT,
    id_curso BIGINT,
    id_modulo BIGINT,
    presente bit,
    instancia BIGINT,
    legajo_alumno BIGINT,

    CONSTRAINT PK_Evaluacion_id PRIMARY KEY (id_evaluacion),
    CONSTRAINT FK_Evaluacion_curso FOREIGN KEY (id_curso) REFERENCES KEY_GROUP.Curso(id_curso),
    CONSTRAINT FK_Evaluacion_modulo FOREIGN KEY (id_modulo) REFERENCES KEY_GROUP.Modulo(id_modulo),
    CONSTRAINT FK_Evaluacion_alumno FOREIGN KEY (legajo_alumno) REFERENCES KEY_GROUP.Alumno(legajo_alumno)
)

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Final' AND schema_id = SCHEMA_ID('KEY_GROUP'))
CREATE TABLE KEY_GROUP.Final (
    id_final BIGINT IDENTITY(1,1),
    id_curso BIGINT,
    fecha_final DATE,
    hora TIME,

    CONSTRAINT PK_Final_id PRIMARY KEY (id_final),
    CONSTRAINT FK_Final_curso FOREIGN KEY (id_curso) REFERENCES KEY_GROUP.Curso(id_curso)
)

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Inscripcion_Final' AND schema_id = SCHEMA_ID('KEY_GROUP'))
CREATE TABLE KEY_GROUP.Trabajo_Practico (
    id_inscripcion_final BIGINT IDENTITY(1,1),
    fecha_inscripcion_final DATETIME2(6),
    legajo_alumno BIGINT,
    id_final BIGINT,

    CONSTRAINT PK_Inscripcion_Final_id PRIMARY KEY (id_inscripcion_final),
    CONSTRAINT FK_Inscripcion_Final_alumno FOREIGN KEY (legajo_alumno) REFERENCES KEY_GROUP.Alumno(legajo_alumno),
    CONSTRAINT FK_Inscripcion_Final_final FOREIGN KEY (id_final) REFERENCES KEY_GROUP.Final(id_final)
)

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Evaluacion_Final' AND schema_id = SCHEMA_ID('KEY_GROUP'))
CREATE TABLE KEY_GROUP.Evaluacion_Final (
    id_evaluacion_final BIGINT IDENTITY(1,1),
    id_final BIGINT,
    id_profesor BIGINT,
    presente bit,
    nota INT,
    legajo_alumno BIGINT,
    descripcion NVARCHAR(255),

    CONSTRAINT PK_Evaluacion_Final_id PRIMARY KEY (id_evaluacion_final),
    CONSTRAINT FK_Evaluacion_Final_final FOREIGN KEY (id_final) REFERENCES KEY_GROUP.Final(id_final),
    CONSTRAINT FK_Evaluacion_Final_profesor FOREIGN KEY (id_profesor) REFERENCES KEY_GROUP.Profesor(id_profesor),
    CONSTRAINT FK_Evaluacion_Final_alumno FOREIGN KEY (legajo_alumno) REFERENCES KEY_GROUP.Alumno(legajo_alumno)
)