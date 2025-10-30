USE GD1C2025;
GO

-- Eliminación de tablas en orden inverso para no romper las FK


IF OBJECT_ID('KEY_GROUP.Curso', 'U') IS NOT NULL
    DROP TABLE KEY_GROUP.Curso;

IF OBJECT_ID('KEY_GROUP.Turno', 'U') IS NOT NULL
    DROP TABLE KEY_GROUP.Turno;

IF OBJECT_ID('KEY_GROUP.Categoria', 'U') IS NOT NULL
    DROP TABLE KEY_GROUP.Categoria;

IF OBJECT_ID('KEY_GROUP.Sede', 'U') IS NOT NULL
    DROP TABLE KEY_GROUP.Sede;

IF OBJECT_ID('KEY_GROUP.Institucion', 'U') IS NOT NULL
    DROP TABLE KEY_GROUP.Institucion;

IF OBJECT_ID('KEY_GROUP.Profesor', 'U') IS NOT NULL
    DROP TABLE KEY_GROUP.Profesor;

IF OBJECT_ID('KEY_GROUP.Localidad', 'U') IS NOT NULL
    DROP TABLE KEY_GROUP.Localidad;

IF OBJECT_ID('KEY_GROUP.Provincia', 'U') IS NOT NULL
    DROP TABLE KEY_GROUP.Provincia;


-- dropear SP

IF OBJECT_ID('KEY_GROUP.migrar_Provincia', 'P') IS NOT NULL
    DROP PROCEDURE KEY_GROUP.migrar_Provincia;

IF OBJECT_ID('KEY_GROUP.migrar_Localidad', 'P') IS NOT NULL
    DROP PROCEDURE KEY_GROUP.migrar_Localidad;

IF OBJECT_ID('KEY_GROUP.migrar_Profesor', 'P') IS NOT NULL
    DROP PROCEDURE KEY_GROUP.migrar_Profesor;

IF OBJECT_ID('KEY_GROUP.migrar_Institucion', 'P') IS NOT NULL
    DROP PROCEDURE KEY_GROUP.migrar_Institucion;

IF OBJECT_ID('KEY_GROUP.migrar_Sede', 'P') IS NOT NULL
    DROP PROCEDURE KEY_GROUP.migrar_Sede;

IF OBJECT_ID('KEY_GROUP.migrar_Turno', 'P') IS NOT NULL
    DROP PROCEDURE KEY_GROUP.migrar_Turno;

IF OBJECT_ID('KEY_GROUP.migrar_Curso', 'P') IS NOT NULL
    DROP PROCEDURE KEY_GROUP.migrar_Curso;



