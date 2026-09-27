# Análisis Comparativo de Simulacros UNMSM: 2026-2 vs 2027-1

Dashboard interactivo en **Power BI** que compara los resultados de dos simulacros de admisión de la Universidad Nacional Mayor de San Marcos (UNMSM): el simulacro 2026-2 (realizado el 8 de febrero de 2026) y el simulacro 2027-1 (realizado el 20 de septiembre de 2026).

---

## 🎯 Objetivo

Analizar y visualizar las diferencias en **postulación, desempeño y ausentismo** entre dos ciclos de admisión consecutivos, diferenciando por **5 áreas de admisión** y por **87 carreras profesionales**.

---

## 📊 Hallazgos Principales

| Métrica | 2026-2 | 2027-1 | Cambio |
|---------|--------|--------|--------|
| **Postulantes** | 9,794 | 15,026 | **+53.4 %** ↑ |
| **Ausentes** | 269 | 249 | −7.4 % |
| **Tasa de ausentismo** | 2.75 % | 1.66 % | −1.09 pp |
| **Puntaje máximo** | 1,805.875 | 1,636.875 | −169 pts |
| **Puntaje mínimo** | 150.5 | 102.0 | −48.5 pts |
| **Puntaje promedio** | 755.0 | 767.8 | +12.8 pts |

### Destacados

- **Medicina Humana** sigue siendo la carrera más demandada en ambos ciclos (2,229 → 2,786 postulantes)
- **Ingenierías** superó a **Ciencias de la Salud** en 2027-1 (4,882 vs 4,785 postulantes)
- **Ciencias Básicas** mantiene la menor participación relativa (~2.9 % en ambos)
- Los **puntajes máximos bajaron**, pero los **promedios subieron**, indicando mayor competitividad en postulantes de menor rendimiento

---

## 📁 Estructura del Repositorio

```
Simulacro-San-Marcos/
│
├── README.md                          ← Este archivo
├── .gitignore                         ← Excluye archivos sensibles
│
├── sql/
│   └── ETL_SimulacroSM.sql            ← Script SQL Server para cargar y procesar datos
│
├── python/
│   ├── scraping_simulacro.py          ← Script de extracción de datos (Playwright)
│
├── powerbi/
│   └── SimulacroUNMSM.pbix       ← Dashboard Power BI (3 páginas)
│
├── data/
│   ├── simulacro_unmsm_20262.csv      ← Datos 2026-2 (9,794 registros)
│   └── simulacro_unmsm_2027I.csv      ← Datos 2027-1 (15,026 registros)
│
└── pdf/
    ├── SimulacroUNMSM.pdf            ← Resultados 2026-2 - 2027-1 (3 páginas)
    
```

---

## 🚀 Cómo Replicar

### Prerequisitos

- **SQL Server 2019+** (o Azure Data Studio con SQL Server)
- **Python 3.9+** con librerías en `python/requirements.txt`
- **Power BI Desktop** (para abrir `.pbix`)
- Los archivos CSV en la carpeta `data/`

### Paso 1: Cargar datos en SQL Server

```bash
# 1. Abre el script SQL en SQL Server Management Studio
# 2. Ajusta las rutas de los CSV en la sección BULK INSERT:
#    - Busca: C:/ruta/a/simulacro_unmsm_20262.csv
#    - Cambia por: tu_ruta_local/data/simulacro_unmsm_20262.csv

# 3. Ejecuta el script completo:
sqlcmd -S .\DESKTOP-UQKKCKS -E -i sql/ETL_SimulacroSM.sql
```

**Nota:** Reemplaza `DESKTOP-UQKKCKS` por tu servidor SQL Server local.

### Paso 2: Configurar conexión en Power BI

1. Abre `powerbi/Dashboard_Simulacro.pbix`
2. **Transformación de datos** → **Configuración del origen de datos**
3. Actualiza la conexión SQL Server:
   - Servidor: `.\DESKTOP-UQKKCKS` (o tu servidor)
   - Base de datos: `SimulacroUNMSM`
4. **Actualizar** para refrescar los datos

### Paso 3 (Opcional): Validar datos con Python

```bash
cd python
pip install -r requirements.txt
python validacion_datos.py
```

---

## 📊 Contenido del Dashboard (Power BI)

### Página 1: RESULTADOS DEL SIMULACRO 2026-2
- **KPIs:** Postulantes, Ausentes, Puntaje máx./mín.
- **Gráficos:** Postulantes y ausentes por área
- **Tabla:** Detalles por carrera (puntajes, promedio, ausentes)
- **Slicers:** Filtrar por área y carrera

### Página 2: RESULTADOS DEL SIMULACRO 2027-1
- Mismo layout que Página 1, con datos 2027-1

### Página 3: ANÁLISIS COMPARATIVO 2026-2 vs 2027-1
- **Tablas comparativas:** Puntajes máx./mín. y postulantes por área
- **Gráficos de barras agrupadas:** Ausentes y postulantes por área
- **Gráfico circular:** Distribución de postulantes 2027-1
- **Slicers jerárquicos:** Filtrar por área

---

## 🗄️ Estructura de Datos

### Tabla: `postulantes_20262` y `postulantes_20271`
```sql
CREATE TABLE postulantes_20262 (
    id INT IDENTITY(1,1) PRIMARY KEY,
    cod_escuela VARCHAR(20),
    escuela VARCHAR(200),
    codigo VARCHAR(100),           -- Código de postulante (sin PII)
    puntaje FLOAT,
    merito DECIMAL(10,3),
    observacion VARCHAR(200),
    ausente BIT
);
```

### Tabla: `facultades`
- 87 carreras profesionales
- 20 facultades
- 5 áreas de admisión (A–E)

```sql
SELECT * FROM facultades WHERE cod_area = 'C' LIMIT 5;
-- Ejemplo: Ingenierías (área C)
```

### Tabla: `areas` 
| Cód | Área | Carreras |
|-----|------|----------|
| A | Ciencias de la Salud | 15 |
| B | Ciencias Básicas | 11 |
| C | Ingenierías | 26 |
| D | Ciencias Económicas y de la Gestión | 14 |
| E | Humanidades y Ciencias Jurídicas y Sociales | 21 |

---

## ⚙️ Stack Técnico

| Componente | Tecnología |
|------------|-----------|
| **Almacenamiento** | SQL Server 2019+ |
| **ETL** | T-SQL (BULK INSERT, procedimientos) |
| **Extracción** | Python + Playwright (web scraping) |
| **Visualización** | Power BI Desktop |
| **Validación** | Python (Pandas, NumPy) |
| **Control de versión** | Git + GitHub |

---

## 📈 Validación de Datos

### Comparación con cifras oficiales UNMSM

| Concepto | Oficial UNMSM | Data extraída | Diferencia | % |
|----------|--------------|---------------|-----------|---|
| Postulantes 2026-2 | 9,851 | 9,794 | −57 | −0.58 % |
| Postulantes 2027-1 | 15,156 | 15,026 | −130 | −0.86 % |

**Notas:**
- Las diferencias son mínimas (<1%) y pueden deberse a:
  - Registros sin código de postulante
  - Datos incompletos en la fuente (OCA)
  - Cambios en la estructura de reportes
- La **distribución proporcional por área coincide al decimal** (validado)
- **Crecimiento reportado:** UNMSM +53.74 % vs Data +53.42 % (diferencia: 0.32 pp)

### Validación de Integridad

✅ Sin registros duplicados (código de postulante)  
✅ Todos los postulantes tienen área de admisión  
✅ Ausentes sin puntaje, presentes con puntaje  
✅ Rangos de puntaje coherentes (0–2000)  
✅ Conteo de ausentes por área concuerda  

---

## 🔍 Notas Importantes

### Fuente de Datos
Los datos provienen de **resultados publicados por la Oficina de Admisión (OCA) de la UNMSM**, extraídos mediante web scraping de la plataforma oficial. Se incluyen únicamente postulantes que completaron la inscripción.

### Limitaciones
- **Puntajes no comparables directamente:** Cada simulacro usa pruebas diferentes en dificultad y escalas
- **Volumen de postulantes:** No es predeterminado; depende del interés de cada ciclo
- **Ausentes:** Se consideran como tales en base a flag `ausente=1` en la fuente

### Confidencialidad
- Los códigos de postulante (`codigo`) se incluyen solo para validación interna
- No se incluyen nombres ni datos personales identificables
- Los datos son públicos (publicados por UNMSM)

---

## 📚 Recursos Utilizados

### Documentación
- [SQL Server BULK INSERT](https://learn.microsoft.com/en-us/sql/t-sql/statements/bulk-insert-transact-sql)
- [Power BI Desktop](https://learn.microsoft.com/en-us/power-bi/fundamentals/desktop-what-is-desktop)
- [Playwright Python](https://playwright.dev/python/)

### Validación externa
- Cifras publicadas por la OCA-UNMSM (fuente oficial)
- Comunicados de admisión 2026-2 y 2027-1

---

## 📝 Notas del Autor

Este proyecto fue desarrollado como **trabajo final de análisis de datos** usando tecnologías modernas de BI y data engineering. Demuestra:

- ✅ Extracción de datos en tiempo real (web scraping)
- ✅ Procesamiento ETL en SQL Server
- ✅ Modelado de datos (dimensiones y hechos)
- ✅ Visualización interactiva en Power BI
- ✅ Validación de integridad de datos
- ✅ Documentación técnica completa

---

## 📧 Contacto

- **Autores:** Jose Maquera, Sol Tasayco, Valeri Zavala
- **Email:** josemaqueramar@gmail.com
- **Estudiante de:** Estadística, UNMSM (8vo ciclo)
- **LinkedIn:** [Jose Maquera](https://linkedin.com/in/josemaqueramartinez/) , [Sol Tasayco](https://www.linkedin.com/in/tasayco-robles-sol-rosario/) , [Valeri Zavala](https://www.linkedin.com/in/valeri-yajahira-m-zavala-ipanaque-1a54872a9/)
- **GitHub:** [github.com/JoseMaqueraMartinez](https://github.com/JoseMaqueraMartinez/)

---

## 📄 Licencia

Este proyecto está bajo licencia **MIT**. Los datos provienen de fuentes públicas de UNMSM y pueden ser utilizados con fines educativos y de investigación.

---

**Última actualización:** 27 de septiembre de 2026
