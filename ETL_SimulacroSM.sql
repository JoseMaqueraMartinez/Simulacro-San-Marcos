/* ============================================================
   SIMULACRO UNMSM - CARGA Y PREPARACIÓN DE DATOS

   Compara los simulacros presenciales de admisión 2026-2 y
   2027-1 (sede Lima).

   Fuente : Resultados publicados por la OCA-UNMSM, extraídos
            con Playwright

   Salida : BD SimulacroUNMSM, lista para consumo en Power BI.

   Volumen:
     2026-2 -> 9 794 registros (86 carreras)
     2027-1 -> 15 026 registros (87 carreras)

  
/ ============================================================
   0. BASE DE DATOS
   ============================================================ */
IF DB_ID('SimulacroUNMSM') IS NULL
    CREATE DATABASE SimulacroUNMSM;
GO

USE SimulacroUNMSM;
GO


/* ============================================================
   1. TABLAS DESTINO
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
   2. STAGING
   ------------------------------------------------------------
   Se carga todo como texto para que ningún valor rompa el
   BULK INSERT (ausentes sin puntaje, booleanos como texto,
   tildes). La conversión de tipos se hace después, controlada.

   FORMAT = 'CSV' es obligatorio: la carrera
   "LENGUAS, TRADUCCIÓN E INTERPRETACIÓN" lleva una coma en el
   nombre. Sin esa opción el parser la parte en dos campos y
   corre todas las columnas siguientes un lugar, metiendo el
   código del postulante dentro de la columna puntaje.

   CODEPAGE = '65001' preserva tildes y Ñ (UTF-8). El wizard
   de importación de SSMS no maneja bien esta codificación.
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
   3. CARGA A TABLAS FINALES
   ------------------------------------------------------------
   NULLIF() convierte los vacíos en NULL (los ausentes no
   tienen puntaje ni mérito). El CASE normaliza la columna
   ausente, que viene como texto.
   ============================================================ */
TRUNCATE TABLE postulantes_20262;

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

TRUNCATE TABLE postulantes_20271;

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
   4. LIMPIEZA
   ============================================================ */
UPDATE postulantes_20271
SET cod_escuela = '133'
WHERE cod_escuela = '13.3';
GO


/* ============================================================
   5. VALIDACIONES
   ============================================================ */
-- 5.1 Conteos y rango de puntajes
SELECT 'postulantes_20262' AS tabla,
       COUNT(*)  AS total,
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
-- El máximo debe estar en el orden de 1 600-1 800. Un valor de
-- seis dígitos indica que las columnas se corrieron al cargar.

-- 5.2 Duplicados por código de postulante
SELECT '20262' AS tabla, codigo, COUNT(*) AS veces
FROM postulantes_20262
GROUP BY codigo HAVING COUNT(*) > 1
UNION ALL
SELECT '20271', codigo, COUNT(*)
FROM postulantes_20271
GROUP BY codigo HAVING COUNT(*) > 1;
-- Esperado: 0 filas.

-- 5.3 Coherencia del orden de mérito dentro de una carrera
SELECT TOP 5 escuela, codigo, puntaje, merito
FROM postulantes_20271
WHERE escuela = 'ADMINISTRACIÓN'
ORDER BY puntaje DESC;
-- El mérito debe crecer conforme baja el puntaje.
GO


/* ============================================================
   6. ÍNDICES
   ============================================================ */
CREATE INDEX idx_escuela_20262 ON postulantes_20262(escuela);
CREATE INDEX idx_puntaje_20262 ON postulantes_20262(puntaje);
CREATE INDEX idx_ausente_20262 ON postulantes_20262(ausente);
CREATE INDEX idx_merito_20262  ON postulantes_20262(merito);

CREATE INDEX idx_escuela_20271 ON postulantes_20271(escuela);
CREATE INDEX idx_puntaje_20271 ON postulantes_20271(puntaje);
CREATE INDEX idx_ausente_20271 ON postulantes_20271(ausente);
CREATE INDEX idx_merito_20271  ON postulantes_20271(merito);
GO


/* ============================================================ 
   7. DIMENSIÓN FACULTADES */

DROP TABLE IF EXISTS facultades;
CREATE TABLE facultades (
    cod_escuela VARCHAR(20) PRIMARY KEY,
    escuela     VARCHAR(200) NOT NULL,
    facultad    VARCHAR(100) NOT NULL
);

INSERT INTO facultades (cod_escuela, escuela, facultad) VALUES
--01 Medicina
('011','MEDICINA HUMANA','Medicina'),
('012','OBSTETRICIA','Medicina'),
('013','ENFERMERÍA','Medicina'),
('0141','TEC. MED. LAB. CLÍNICO Y ANATOMÍA PATOLÓGICA','Medicina'),
('0142','TEC. MED. TERAPIA FÍSICA Y REHABILITACIÓN','Medicina'),
('0143','TEC. MED. RADIOLOGÍA','Medicina'),
('0144','TEC. MED. TERAPIA OCUPACIONAL','Medicina'),
('015','NUTRICIÓN','Medicina'),
-- 02 Derecho y Ciencia Política
('022','DERECHO','Derecho y Ciencia Política'),
('023','CIENCIA POLÍTICA','Derecho y Ciencia Política'),
-- 03 Letras y Ciencias Humanas
('031','LITERATURA','Letras y Ciencias Humanas'),
('0310','LENGUAS, TRADUCCIÓN E INTERPRETACIÓN','Letras y Ciencias Humanas'),
('033','FILOSOFÍA','Letras y Ciencias Humanas'),
('034','LINGÜÍSTICA','Letras y Ciencias Humanas'),
('035','COMUNICACIÓN SOCIAL','Letras y Ciencias Humanas'),
('036','ARTE','Letras y Ciencias Humanas'),
('037','BIBLIOTECOLOGÍA Y CIENCIAS DE LA INFORMACIÓN','Letras y Ciencias Humanas'),
('038','DANZA','Letras y Ciencias Humanas'),
('039','CONSERVACIÓN Y RESTAURACIÓN','Letras y Ciencias Humanas'),
-- 04 Farmacia y Bioquímica
('041','FARMACIA Y BIOQUÍMICA','Farmacia y Bioquímica'),
('042','CIENCIAS DE LOS ALIMENTOS','Farmacia y Bioquímica'),
('043','TOXICOLOGÍA','Farmacia y Bioquímica'),
-- 05 Odontología
('051','ODONTOLOGÍA','Odontología'),
-- 06 Educación
('0611','EDUCACIÓN INICIAL','Educación'),
('0612','EDUCACIÓN PRIMARIA','Educación'),
('0613','EDUCACIÓN SECUNDARIA','Educación'),
('062','EDUCACIÓN FÍSICA','Educación'),
-- 07 Química e Ing. Química
('071','QUÍMICA','Química e Ing. Química'),
('072','INGENIERÍA QUÍMICA','Química e Ing. Química'),
('073','INGENIERÍA AGROINDUSTRIAL','Química e Ing. Química'),
('074','INGENIERÍA DEL AGUA Y TECNOLOGÍAS DE TRATAMIENTO','Química e Ing. Química'),
-- 08 Medicina Veterinaria
('081','MEDICINA VETERINARIA','Medicina Veterinaria'),
-- 09 Ciencias Administrativas
('091','ADMINISTRACIÓN','Ciencias Administrativas'),
('092','ADMINISTRACIÓN DE TURISMO','Ciencias Administrativas'),
('093','ADMINISTRACIÓN DE NEGOCIOS INTERNACIONALES','Ciencias Administrativas'),
('094','ADMINISTRACIÓN DE LA GASTRONOMÍA','Ciencias Administrativas'),
('095','ADMINISTRACIÓN MARÍTIMA Y PORTUARIA','Ciencias Administrativas'),
('096','MARKETING','Ciencias Administrativas'),
-- 10 Ciencias Biológicas
('101','CIENCIAS BIOLÓGICAS','Ciencias Biológicas'),
('102','GENÉTICA Y BIOTECNOLOGÍA','Ciencias Biológicas'),
('103','MICROBIOLOGÍA Y PARASITOLOGÍA','Ciencias Biológicas'),
-- 11 Ciencias Contables
('111','CONTABILIDAD','Ciencias Contables'),
('112','GESTIÓN TRIBUTARIA','Ciencias Contables'),
('113','AUDITORÍA EMPRESARIAL Y DEL SECTOR PÚBLICO','Ciencias Contables'),
('114','PRESUPUESTO Y FINANZAS PÚBLICAS','Ciencias Contables'),
('115','CRIMINALÍSTICA FINANCIERA FORENSE','Ciencias Contables'),
-- 12 Ciencias Económicas
('121','ECONOMÍA','Ciencias Económicas'),
('122','ECONOMÍA PÚBLICA','Ciencias Económicas'),
('123','ECONOMÍA INTERNACIONAL','Ciencias Económicas'),
-- 13 Ciencias Físicas
('131','FÍSICA','Ciencias Físicas'),
('132','INGENIERÍA MECÁNICA DE FLUIDOS','Ciencias Físicas'),
('133','GEOFÍSICA','Ciencias Físicas'),
('134','CIENCIA DE MATERIALES Y NANOTECNOLOGÍA','Ciencias Físicas'),
-- 14 Ciencias Matemáticas
('141','MATEMÁTICA','Ciencias Matemáticas'),
('142','ESTADÍSTICA','Ciencias Matemáticas'),
('144','INVESTIGACIÓN OPERATIVA','Ciencias Matemáticas'),
('145','COMPUTACIÓN CIENTÍFICA','Ciencias Matemáticas'),
-- 15 Ciencias Sociales
('151','HISTORIA','Ciencias Sociales'),
('152','SOCIOLOGÍA','Ciencias Sociales'),
('153','ANTROPOLOGÍA','Ciencias Sociales'),
('154','ARQUEOLOGÍA','Ciencias Sociales'),
('155','TRABAJO SOCIAL','Ciencias Sociales'),
('157','GEOGRAFÍA','Ciencias Sociales'),
-- 16 FIGMMG
('162','INGENIERÍA GEOLÓGICA','FIGMMG'),
('163','INGENIERÍA GEOGRÁFICA','FIGMMG'),
('165','INGENIERÍA DE MINAS','FIGMMG'),
('166','INGENIERÍA METALÚRGICA','FIGMMG'),
('167','INGENIERÍA CIVIL','FIGMMG'),
('168','INGENIERÍA AMBIENTAL','FIGMMG'),
('169','ARQUITECTURA Y URBANISMO','FIGMMG'),
-- 17 Ingeniería Industrial
('171','INGENIERÍA INDUSTRIAL','Ingeniería Industrial'),
('172','INGENIERÍA TEXTIL Y CONFECCIONES','Ingeniería Industrial'),
('173','INGENIERÍA DE SEGURIDAD Y SALUD EN EL TRABAJO','Ingeniería Industrial'),
('174','INGENIERÍA LOGÍSTICA Y CADENA DE SUMINISTRO DIGITAL','Ingeniería Industrial'),
('175','INGENIERÍA DE TRANSPORTE Y SISTEMAS FERROVIARIOS','Ingeniería Industrial'),
-- 18 Psicología
('181','PSICOLOGÍA','Psicología'),
('182','PSICOLOGÍA ORGANIZACIONAL Y DE LA GESTIÓN HUMANA','Psicología'),
-- 19 Ing. Electrónica y Eléctrica
('191','INGENIERÍA ELECTRÓNICA','Ing. Electrónica y Eléctrica'),
('192','INGENIERÍA ELÉCTRICA','Ing. Electrónica y Eléctrica'),
('193','INGENIERÍA DE TELECOMUNICACIONES','Ing. Electrónica y Eléctrica'),
('194','INGENIERÍA BIOMÉDICA','Ing. Electrónica y Eléctrica'),
('195','INGENIERÍA NUCLEAR','Ing. Electrónica y Eléctrica'),
('196','INGENIERÍA MECATRÓNICA','Ing. Electrónica y Eléctrica'),
-- 20 Ing. de Sistemas e Informática
('201','INGENIERÍA DE SISTEMAS','Ing. de Sistemas e Informática'),
('202','INGENIERÍA DE SOFTWARE','Ing. de Sistemas e Informática'),
('203','CIENCIAS DE LA COMPUTACIÓN','Ing. de Sistemas e Informática'),
('204','INGENIERÍA DE INTELIGENCIA ARTIFICIAL','Ing. de Sistemas e Informática');
GO


/* ============================================================
   8. VALIDACIÓN DE COBERTURA
   ============================================================ */
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
GO


/* ============================================================
   9. LIMPIEZA DE STAGING
   ============================================================ */
DROP TABLE IF EXISTS stg_20262;
DROP TABLE IF EXISTS stg_20271;
GO


/* ============================================================
   10. CONSULTA DE EJEMPLO
   ------------------------------------------------------------
   Demanda por facultad. Se incluye la participación
   porcentual porque los volúmenes absolutos no son
   comparables entre simulacros 
   ============================================================ */
SELECT
    f.facultad,
    COUNT(*) AS postulantes,
    CAST(100.0 * COUNT(*) / SUM(COUNT(*)) OVER () AS DECIMAL(5,2)) AS pct
FROM postulantes_20271 p
INNER JOIN facultades f ON p.cod_escuela = f.cod_escuela
GROUP BY f.facultad
ORDER BY postulantes DESC;
GO
