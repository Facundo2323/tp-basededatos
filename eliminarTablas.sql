USE GD1C2025;
GO

-- Eliminación de tablas en orden inverso para no romper las FK

IF OBJECT_ID('KEY_GROUP.Provincia', 'U') IS NOT NULL
    DROP TABLE KEY_GROUP.Provincia;


IF OBJECT_ID('KEY_GROUP.migrar_Provincia', 'P') IS NOT NULL
    DROP PROCEDURE KEY_GROUP.migrar_Provincia;