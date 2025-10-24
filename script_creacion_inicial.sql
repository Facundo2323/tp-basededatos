USE GD2C2025
GO

CREATE SCHEMA KEY_GROUP;
GO

--Creacion de las tablas

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Provincia' AND schema_id = SCHEMA_ID('KEY_GROUP')) 
CREATE TABLE KEY_GROUP.Provincia (
    --id autoincremental, arranca en uno y salta de a 1
    Id_provincia INT IDENTITY(1,1) PRIMARY KEY, 
    Nombre NVARCHAR(255)
);

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Localidad' AND schema_id = SCHEMA_ID('KEY_GROUP'))
CREATE TABLE KEY_GROUP.Localidad (
    Id_localidad INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(255),
    FOREIGN KEY (Id_provincia) REFERENCES KEY_GROUP.Provincia(Id_provincia)
);

-- PROFESOR
-- INSTITUCION
-- SEDE
