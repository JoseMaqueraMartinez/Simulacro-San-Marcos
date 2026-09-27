/* ============================================================
   SIMULACRO UNMSM 2026-2 vs 2027-1 - ETL
   ============================================================ */


/* ============================================================
   1. BASE DE DATOS
   ============================================================ */
IF DB_ID('SimulacroUNMSM') IS NULL
    CREATE DATABASE SimulacroUNMSM;
GO

USE SimulacroUNMSM;
GO


/* ============================================================
   2. DIMENSIÓN ÁREAS
   ============================================================ */
DROP TABLE IF EXISTS areas;
CREATE TABLE areas (
    cod_area CHAR(1)     PRIMARY KEY,
    area     VARCHAR(60) NOT NULL
);

INSERT INTO areas (cod_area, area) VALUES
('A', 'Ciencias de la Salud'),
('B', 'Ciencias Básicas'),
('C', 'Ingenierías'),
('D', 'Ciencias Económicas y de la Gestión'),
('E', 'Humanidades y Ciencias Jurídicas y Sociales');
GO


/* ============================================================
   3. DIMENSIÓN FACULTADES
   ============================================================ */
DROP TABLE IF EXISTS facultades;
CREATE TABLE facultades (
    cod_escuela VARCHAR(20)  PRIMARY KEY,
    escuela     VARCHAR(200) NOT NULL,
    facultad    VARCHAR(100) NOT NULL,
    cod_area    CHAR(1)      NOT NULL,
    area        VARCHAR(60)  NOT NULL
);

INSERT INTO facultades (cod_escuela, escuela, facultad, cod_area, area) VALUES
-- 01 Medicina
('011','MEDICINA HUMANA','Medicina','A','Ciencias de la Salud'),
('012','OBSTETRICIA','Medicina','A','Ciencias de la Salud'),
('013','ENFERMERÍA','Medicina','A','Ciencias de la Salud'),
('0141','TEC. MED. LAB. CLÍNICO Y ANATOMÍA PATOLÓGICA','Medicina','A','Ciencias de la Salud'),
('0142','TEC. MED. TERAPIA FÍSICA Y REHABILITACIÓN','Medicina','A','Ciencias de la Salud'),
('0143','TEC. MED. RADIOLOGÍA','Medicina','A','Ciencias de la Salud'),
('0144','TEC. MED. TERAPIA OCUPACIONAL','Medicina','A','Ciencias de la Salud'),
('015','NUTRICIÓN','Medicina','A','Ciencias de la Salud'),
-- 02 Derecho y Ciencia Política
('022','DERECHO','Derecho y Ciencia Política','E','Humanidades y Ciencias Jurídicas y Sociales'),
('023','CIENCIA POLÍTICA','Derecho y Ciencia Política','E','Humanidades y Ciencias Jurídicas y Sociales'),
-- 03 Letras y Ciencias Humanas
('031','LITERATURA','Letras y Ciencias Humanas','E','Humanidades y Ciencias Jurídicas y Sociales'),
('0310','LENGUAS, TRADUCCIÓN E INTERPRETACIÓN','Letras y Ciencias Humanas','E','Humanidades y Ciencias Jurídicas y Sociales'),
('033','FILOSOFÍA','Letras y Ciencias Humanas','E','Humanidades y Ciencias Jurídicas y Sociales'),
('034','LINGÜÍSTICA','Letras y Ciencias Humanas','E','Humanidades y Ciencias Jurídicas y Sociales'),
('035','COMUNICACIÓN SOCIAL','Letras y Ciencias Humanas','E','Humanidades y Ciencias Jurídicas y Sociales'),
('036','ARTE','Letras y Ciencias Humanas','E','Humanidades y Ciencias Jurídicas y Sociales'),
('037','BIBLIOTECOLOGÍA Y CIENCIAS DE LA INFORMACIÓN','Letras y Ciencias Humanas','E','Humanidades y Ciencias Jurídicas y Sociales'),
('038','DANZA','Letras y Ciencias Humanas','E','Humanidades y Ciencias Jurídicas y Sociales'),
('039','CONSERVACIÓN Y RESTAURACIÓN','Letras y Ciencias Humanas','E','Humanidades y Ciencias Jurídicas y Sociales'),
-- 04 Farmacia y Bioquímica
('041','FARMACIA Y BIOQUÍMICA','Farmacia y Bioquímica','A','Ciencias de la Salud'),
('042','CIENCIAS DE LOS ALIMENTOS','Farmacia y Bioquímica','A','Ciencias de la Salud'),
('043','TOXICOLOGÍA','Farmacia y Bioquímica','A','Ciencias de la Salud'),
-- 05 Odontología
('051','ODONTOLOGÍA','Odontología','A','Ciencias de la Salud'),
-- 06 Educación
('0611','EDUCACIÓN INICIAL','Educación','E','Humanidades y Ciencias Jurídicas y Sociales'),
('0612','EDUCACIÓN PRIMARIA','Educación','E','Humanidades y Ciencias Jurídicas y Sociales'),
('0613','EDUCACIÓN SECUNDARIA','Educación','E','Humanidades y Ciencias Jurídicas y Sociales'),
('062','EDUCACIÓN FÍSICA','Educación','E','Humanidades y Ciencias Jurídicas y Sociales'),
-- 07 Química e Ing. Química
('071','QUÍMICA','Química e Ing. Química','B','Ciencias Básicas'),
('072','INGENIERÍA QUÍMICA','Química e Ing. Química','C','Ingenierías'),
('073','INGENIERÍA AGROINDUSTRIAL','Química e Ing. Química','C','Ingenierías'),
('074','INGENIERÍA DEL AGUA Y TECNOLOGÍAS DE TRATAMIENTO','Química e Ing. Química','C','Ingenierías'),
-- 08 Medicina Veterinaria
('081','MEDICINA VETERINARIA','Medicina Veterinaria','A','Ciencias de la Salud'),
-- 09 Ciencias Administrativas
('091','ADMINISTRACIÓN','Ciencias Administrativas','D','Ciencias Económicas y de la Gestión'),
('092','ADMINISTRACIÓN DE TURISMO','Ciencias Administrativas','D','Ciencias Económicas y de la Gestión'),
('093','ADMINISTRACIÓN DE NEGOCIOS INTERNACIONALES','Ciencias Administrativas','D','Ciencias Económicas y de la Gestión'),
('094','ADMINISTRACIÓN DE LA GASTRONOMÍA','Ciencias Administrativas','D','Ciencias Económicas y de la Gestión'),
('095','ADMINISTRACIÓN MARÍTIMA Y PORTUARIA','Ciencias Administrativas','D','Ciencias Económicas y de la Gestión'),
('096','MARKETING','Ciencias Administrativas','D','Ciencias Económicas y de la Gestión'),
-- 10 Ciencias Biológicas
('101','CIENCIAS BIOLÓGICAS','Ciencias Biológicas','B','Ciencias Básicas'),
('102','GENÉTICA Y BIOTECNOLOGÍA','Ciencias Biológicas','B','Ciencias Básicas'),
('103','MICROBIOLOGÍA Y PARASITOLOGÍA','Ciencias Biológicas','B','Ciencias Básicas'),
-- 11 Ciencias Contables
('111','CONTABILIDAD','Ciencias Contables','D','Ciencias Económicas y de la Gestión'),
('112','GESTIÓN TRIBUTARIA','Ciencias Contables','D','Ciencias Económicas y de la Gestión'),
('113','AUDITORÍA EMPRESARIAL Y DEL SECTOR PÚBLICO','Ciencias Contables','D','Ciencias Económicas y de la Gestión'),
('114','PRESUPUESTO Y FINANZAS PÚBLICAS','Ciencias Contables','D','Ciencias Económicas y de la Gestión'),
('115','CRIMINALÍSTICA FINANCIERA FORENSE','Ciencias Contables','D','Ciencias Económicas y de la Gestión'),
-- 12 Ciencias Económicas
('121','ECONOMÍA','Ciencias Económicas','D','Ciencias Económicas y de la Gestión'),
('122','ECONOMÍA PÚBLICA','Ciencias Económicas','D','Ciencias Económicas y de la Gestión'),
('123','ECONOMÍA INTERNACIONAL','Ciencias Económicas','D','Ciencias Económicas y de la Gestión'),
-- 13 Ciencias Físicas
('131','FÍSICA','Ciencias Físicas','B','Ciencias Básicas'),
('132','INGENIERÍA MECÁNICA DE FLUIDOS','Ciencias Físicas','C','Ingenierías'),
('133','GEOFÍSICA','Ciencias Físicas','B','Ciencias Básicas'),
('134','CIENCIA DE MATERIALES Y NANOTECNOLOGÍA','Ciencias Físicas','B','Ciencias Básicas'),
-- 14 Ciencias Matemáticas
('141','MATEMÁTICA','Ciencias Matemáticas','B','Ciencias Básicas'),
('142','ESTADÍSTICA','Ciencias Matemáticas','B','Ciencias Básicas'),
('144','INVESTIGACIÓN OPERATIVA','Ciencias Matemáticas','B','Ciencias Básicas'),
('145','COMPUTACIÓN CIENTÍFICA','Ciencias Matemáticas','B','Ciencias Básicas'),
-- 15 Ciencias Sociales
('151','HISTORIA','Ciencias Sociales','E','Humanidades y Ciencias Jurídicas y Sociales'),
('152','SOCIOLOGÍA','Ciencias Sociales','E','Humanidades y Ciencias Jurídicas y Sociales'),
('153','ANTROPOLOGÍA','Ciencias Sociales','E','Humanidades y Ciencias Jurídicas y Sociales'),
('154','ARQUEOLOGÍA','Ciencias Sociales','E','Humanidades y Ciencias Jurídicas y Sociales'),
('155','TRABAJO SOCIAL','Ciencias Sociales','E','Humanidades y Ciencias Jurídicas y Sociales'),
('157','GEOGRAFÍA','Ciencias Sociales','E','Humanidades y Ciencias Jurídicas y Sociales'),
-- 16 FIGMMG
('162','INGENIERÍA GEOLÓGICA','FIGMMG','C','Ingenierías'),
('163','INGENIERÍA GEOGRÁFICA','FIGMMG','C','Ingenierías'),
('165','INGENIERÍA DE MINAS','FIGMMG','C','Ingenierías'),
('166','INGENIERÍA METALÚRGICA','FIGMMG','C','Ingenierías'),
('167','INGENIERÍA CIVIL','FIGMMG','C','Ingenierías'),
('168','INGENIERÍA AMBIENTAL','FIGMMG','C','Ingenierías'),
('169','ARQUITECTURA Y URBANISMO','FIGMMG','C','Ingenierías'),
-- 17 Ingeniería Industrial
('171','INGENIERÍA INDUSTRIAL','Ingeniería Industrial','C','Ingenierías'),
('172','INGENIERÍA TEXTIL Y CONFECCIONES','Ingeniería Industrial','C','Ingenierías'),
('173','INGENIERÍA DE SEGURIDAD Y SALUD EN EL TRABAJO','Ingeniería Industrial','C','Ingenierías'),
('174','INGENIERÍA LOGÍSTICA Y CADENA DE SUMINISTRO DIGITAL','Ingeniería Industrial','C','Ingenierías'),
('175','INGENIERÍA DE TRANSPORTE Y SISTEMAS FERROVIARIOS','Ingeniería Industrial','C','Ingenierías'),
-- 18 Psicología
('181','PSICOLOGÍA','Psicología','A','Ciencias de la Salud'),
('182','PSICOLOGÍA ORGANIZACIONAL Y DE LA GESTIÓN HUMANA','Psicología','A','Ciencias de la Salud'),
-- 19 Ing. Electrónica y Eléctrica
('191','INGENIERÍA ELECTRÓNICA','Ing. Electrónica y Eléctrica','C','Ingenierías'),
('192','INGENIERÍA ELÉCTRICA','Ing. Electrónica y Eléctrica','C','Ingenierías'),
('193','INGENIERÍA DE TELECOMUNICACIONES','Ing. Electrónica y Eléctrica','C','Ingenierías'),
('194','INGENIERÍA BIOMÉDICA','Ing. Electrónica y Eléctrica','C','Ingenierías'),
('195','INGENIERÍA NUCLEAR','Ing. Electrónica y Eléctrica','C','Ingenierías'),
('196','INGENIERÍA MECATRÓNICA','Ing. Electrónica y Eléctrica','C','Ingenierías'),
-- 20 Ing. de Sistemas e Informática
('201','INGENIERÍA DE SISTEMAS','Ing. de Sistemas e Informática','C','Ingenierías'),
('202','INGENIERÍA DE SOFTWARE','Ing. de Sistemas e Informática','C','Ingenierías'),
('203','CIENCIAS DE LA COMPUTACIÓN','Ing. de Sistemas e Informática','C','Ingenierías'),
('204','INGENIERÍA DE INTELIGENCIA ARTIFICIAL','Ing. de Sistemas e Informática','C','Ingenierías');
GO


/* ============================================================
   4. TABLAS DESTINO
   ============================================================ */
DROP TABLE IF EXISTS postulantes_20262;
CREATE TABLE postulantes_20262 (
    id          INT IDENTITY(1,1) PRIMARY KEY,
    cod_escuela VARCHAR(20),
    escuela     VARCHAR(200),
    codigo      VARCHAR(100),
    puntaje     FLOAT,
    merito      DECIMAL(10,3),
    observacion VARCHAR(200),
    ausente     BIT
);

DROP TABLE IF EXISTS postulantes_20271;
CREATE TABLE postulantes_20271 (
    id          INT IDENTITY(1,1) PRIMARY KEY,
    cod_escuela VARCHAR(20),
    escuela     VARCHAR(200),
    codigo      VARCHAR(100),
    puntaje     FLOAT,
    merito      DECIMAL(10,3),
    observacion VARCHAR(200),
    ausente     BIT
);
GO


/* ============================================================
   5. STAGING Y BULK INSERT
   ============================================================ */
DROP TABLE IF EXISTS stg_20262;
CREATE TABLE stg_20262 (
    cod_escuela NVARCHAR(20),
    escuela     NVARCHAR(200),
    codigo      NVARCHAR(100),
    puntaje     NVARCHAR(20),
    merito      NVARCHAR(20),
    observacion NVARCHAR(200),
    ausente     NVARCHAR(10)
);

BULK INSERT stg_20262
FROM 'C:/ruta/a/simulacro_unmsm_20262.csv'
WITH (
    FORMAT          = 'CSV',
    FIRSTROW        = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR   = '0x0a',
    CODEPAGE        = '65001'
);

DROP TABLE IF EXISTS stg_20271;
CREATE TABLE stg_20271 (
    cod_escuela NVARCHAR(20),
    escuela     NVARCHAR(200),
    codigo      NVARCHAR(100),
    puntaje     NVARCHAR(20),
    merito      NVARCHAR(20),
    observacion NVARCHAR(200),
    ausente     NVARCHAR(10)
);

BULK INSERT stg_20271
FROM 'C:/ruta/a/simulacro_unmsm_2027I.csv'
WITH (
    FORMAT          = 'CSV',
    FIRSTROW        = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR   = '0x0a',
    CODEPAGE        = '65001'
);
GO


/* ============================================================
   6. CARGA A TABLAS FINALES
   ============================================================ */
INSERT INTO postulantes_20262
    (cod_escuela, escuela, codigo, puntaje, merito, observacion, ausente)
SELECT
    cod_escuela,
    escuela,
    codigo,
    TRY_CAST(NULLIF(puntaje, '') AS FLOAT),
    CAST(NULLIF(merito, '') AS DECIMAL(10,3)),
    NULLIF(observacion, ''),
    CASE WHEN UPPER(ausente) IN ('TRUE','1','SI','SÍ') THEN 1 ELSE 0 END
FROM stg_20262;

INSERT INTO postulantes_20271
    (cod_escuela, escuela, codigo, puntaje, merito, observacion, ausente)
SELECT
    cod_escuela,
    escuela,
    codigo,
    TRY_CAST(NULLIF(puntaje, '') AS FLOAT),
    CAST(NULLIF(merito, '') AS DECIMAL(10,3)),
    NULLIF(observacion, ''),
    CASE WHEN UPPER(ausente) IN ('TRUE','1','SI','SÍ') THEN 1 ELSE 0 END
FROM stg_20271;
GO


/* ============================================================
   7. LIMPIEZA
   ============================================================ */
-- 7.1 Código de Geofísica
UPDATE postulantes_20271
SET cod_escuela = '133'
WHERE cod_escuela = '13.3';

-- 7.2 Nombres de carrera desde el catálogo
UPDATE p SET p.escuela = f.escuela
FROM postulantes_20262 p
JOIN facultades f ON p.cod_escuela = f.cod_escuela
WHERE p.escuela <> f.escuela;

UPDATE p SET p.escuela = f.escuela
FROM postulantes_20271 p
JOIN facultades f ON p.cod_escuela = f.cod_escuela
WHERE p.escuela <> f.escuela;
GO


/* ============================================================
   8. VALIDACIONES
   ============================================================ */
-- 8.1 Conteos y rango de puntajes
SELECT 'postulantes_20262' AS tabla,
       COUNT(*)     AS total,
       MIN(puntaje) AS min_puntaje,
       MAX(puntaje) AS max_puntaje,
       SUM(CASE WHEN ausente = 1 THEN 1 ELSE 0 END) AS ausentes
FROM postulantes_20262
UNION ALL
SELECT 'postulantes_20271',
       COUNT(*),
       MIN(puntaje),
       MAX(puntaje),
       SUM(CASE WHEN ausente = 1 THEN 1 ELSE 0 END)
FROM postulantes_20271;
-- Esperado: 9794 / 15026 filas; 269 / 249 ausentes.

-- 8.2 Duplicados por código de postulante
SELECT '20262' AS tabla, codigo, COUNT(*) AS veces
FROM postulantes_20262
GROUP BY codigo HAVING COUNT(*) > 1
UNION ALL
SELECT '20271', codigo, COUNT(*)
FROM postulantes_20271
GROUP BY codigo HAVING COUNT(*) > 1;
-- Esperado: 0 filas.

-- 8.3 Orden de mérito
SELECT TOP 5 escuela, codigo, puntaje, merito
FROM postulantes_20271
WHERE escuela = 'ADMINISTRACIÓN'
ORDER BY puntaje DESC;

-- 8.4 Carreras sin registro en el catálogo
SELECT '20262' AS tabla, p.cod_escuela, p.escuela
FROM postulantes_20262 p
LEFT JOIN facultades f ON p.cod_escuela = f.cod_escuela
WHERE f.cod_escuela IS NULL
GROUP BY p.cod_escuela, p.escuela
UNION ALL
SELECT '20271', p.cod_escuela, p.escuela
FROM postulantes_20271 p
LEFT JOIN facultades f ON p.cod_escuela = f.cod_escuela
WHERE f.cod_escuela IS NULL
GROUP BY p.cod_escuela, p.escuela;
-- Esperado: 0 filas.

-- 8.5 Nombres distintos al catálogo
SELECT '20262' AS tabla, p.cod_escuela, p.escuela, f.escuela AS nombre_catalogo
FROM postulantes_20262 p
JOIN facultades f ON p.cod_escuela = f.cod_escuela
WHERE p.escuela <> f.escuela
GROUP BY p.cod_escuela, p.escuela, f.escuela
UNION ALL
SELECT '20271', p.cod_escuela, p.escuela, f.escuela
FROM postulantes_20271 p
JOIN facultades f ON p.cod_escuela = f.cod_escuela
WHERE p.escuela <> f.escuela
GROUP BY p.cod_escuela, p.escuela, f.escuela;
-- Esperado: 0 filas.

-- 8.6 Carreras por área
SELECT cod_area, area, COUNT(*) AS carreras
FROM facultades
GROUP BY cod_area, area
ORDER BY cod_area;
-- Esperado: A 15 | B 11 | C 26 | D 14 | E 21
GO


/* ============================================================
   9. ÍNDICES
   ============================================================ */
CREATE INDEX idx_codesc_20262  ON postulantes_20262(cod_escuela);
CREATE INDEX idx_escuela_20262 ON postulantes_20262(escuela);
CREATE INDEX idx_puntaje_20262 ON postulantes_20262(puntaje);
CREATE INDEX idx_ausente_20262 ON postulantes_20262(ausente);
CREATE INDEX idx_merito_20262  ON postulantes_20262(merito);

CREATE INDEX idx_codesc_20271  ON postulantes_20271(cod_escuela);
CREATE INDEX idx_escuela_20271 ON postulantes_20271(escuela);
CREATE INDEX idx_puntaje_20271 ON postulantes_20271(puntaje);
CREATE INDEX idx_ausente_20271 ON postulantes_20271(ausente);
CREATE INDEX idx_merito_20271  ON postulantes_20271(merito);
GO


/* ============================================================
   10. ELIMINACIÓN DE STAGING
   ============================================================ */
DROP TABLE IF EXISTS stg_20262;
DROP TABLE IF EXISTS stg_20271;
GO


/* ============================================================
   11. CONSULTAS DE EJEMPLO
   ============================================================ */
-- 11.1 Postulantes por área en ambos simulacros
WITH base AS (
    SELECT cod_escuela, '2026-2' AS simulacro FROM postulantes_20262
    UNION ALL
    SELECT cod_escuela, '2027-1' FROM postulantes_20271
)
SELECT
    f.cod_area,
    f.area,
    SUM(CASE WHEN b.simulacro = '2026-2' THEN 1 ELSE 0 END) AS post_20262,
    CAST(100.0 * SUM(CASE WHEN b.simulacro = '2026-2' THEN 1 ELSE 0 END)
         / SUM(SUM(CASE WHEN b.simulacro = '2026-2' THEN 1 ELSE 0 END)) OVER ()
         AS DECIMAL(5,2)) AS pct_20262,
    SUM(CASE WHEN b.simulacro = '2027-1' THEN 1 ELSE 0 END) AS post_20271,
    CAST(100.0 * SUM(CASE WHEN b.simulacro = '2027-1' THEN 1 ELSE 0 END)
         / SUM(SUM(CASE WHEN b.simulacro = '2027-1' THEN 1 ELSE 0 END)) OVER ()
         AS DECIMAL(5,2)) AS pct_20271
FROM base b
JOIN facultades f ON b.cod_escuela = f.cod_escuela
GROUP BY f.cod_area, f.area
ORDER BY f.cod_area;

-- 11.2 Postulantes por facultad (2027-1)
SELECT
    f.facultad,
    COUNT(*) AS postulantes,
    CAST(100.0 * COUNT(*) / SUM(COUNT(*)) OVER () AS DECIMAL(5,2)) AS pct
FROM postulantes_20271 p
JOIN facultades f ON p.cod_escuela = f.cod_escuela
GROUP BY f.facultad
ORDER BY postulantes DESC;
GO
