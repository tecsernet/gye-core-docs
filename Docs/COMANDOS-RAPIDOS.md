# Comandos Rápidos — GYE-CORE

---

## PRIMERA VEZ (instalación + clonado ya hecho)

Orden obligatorio: DB → Backend → BFF → MFEs → Shell

```bash
# Terminal 1 — Base de datos
cd C:/GIT/Municipio/BaseDeDatos/gye-core-db
docker compose up -d

# Terminal 2 — BackendSys
cd C:/GIT/Municipio/Backend/gye-core-backend-sys
dotnet restore
copy src\GYE.Api\appsettings.Development.json.example src\GYE.Api\appsettings.Development.json
dotnet run --project src/GYE.Api

# Terminal 3 — BFF
cd C:/GIT/Municipio/Backend/gye-core-bff
dotnet restore
dotnet run --project src/GYE.Bff

# Terminal 4 — MFE Recaudación
cd C:/GIT/Municipio/Frontend/gye-core-recaudacion
npm install
npx nx serve sys-recaudacion

# Terminal 5 — MFE Convenio
cd C:/GIT/Municipio/Frontend/gye-core-convenio
npm install
npx nx serve sys-convenio

# Terminal 6 — Shell (ÚLTIMO)
cd C:/GIT/Municipio/Frontend/gye-core-shell
npm install
npx nx serve portal-shell
```

---

## DÍA A DÍA (ya instalado, solo levantar)

> Sin `dotnet restore` ni `npm install` — ya están las dependencias.

```bash
# Terminal 1 — Base de datos
cd C:/GIT/Municipio/BaseDeDatos/gye-core-db
docker compose up -d

# Terminal 2 — BackendSys
cd C:/GIT/Municipio/Backend/gye-core-backend-sys
dotnet run --project src/GYE.Api

# Terminal 3 — BFF
cd C:/GIT/Municipio/Backend/gye-core-bff
dotnet run --project src/GYE.Bff

# Terminal 4 — MFE Recaudación
cd C:/GIT/Municipio/Frontend/gye-core-recaudacion
npx nx serve sys-recaudacion

# Terminal 5 — MFE Convenio
cd C:/GIT/Municipio/Frontend/gye-core-convenio
npx nx serve sys-convenio

# Terminal 6 — Shell (ÚLTIMO)
cd C:/GIT/Municipio/Frontend/gye-core-shell
npx nx serve portal-shell
```

---

## PARAR el sistema

```bash
# Frontends y backends: Ctrl+C en cada terminal

# Parar Docker (conserva los datos de la DB)
cd C:/GIT/Municipio/BaseDeDatos/gye-core-db
docker compose stop
```

---

## URLs del sistema

| Servicio         | URL                           |
|------------------|-------------------------------|
| Portal           | http://localhost:4200         |
| MFE Recaudación  | http://localhost:4201         |
| MFE Convenio     | http://localhost:4202         |
| Swagger BFF      | http://localhost:5002/swagger |
| Swagger Backend  | http://localhost:5001/swagger |
| Health Backend   | http://localhost:5001/health  |
| PostgreSQL       | localhost:5432                |
| Redis            | localhost:6379                |

---

## SCRIPTS AUTOMÁTICOS (levantar/parar con un solo comando)

En lugar de abrir 6 terminales manualmente, puedes usar los scripts que abren
todo automáticamente. Están en `Docs/scripts/`.

### Prerequisito — Docker Desktop corriendo

Antes de ejecutar cualquier script, asegúrate de que Docker Desktop esté abierto
y el icono de la ballena esté **verde** en la barra de tareas (Windows) o de menú (Mac).
Sin Docker no levanta la base de datos y el sistema falla.

---

### Windows — start-all.bat

```
Doble click en: Docs/scripts/start-all.bat
```

**Qué hace:**
1. Verifica que Docker esté corriendo — si no, avisa y se detiene
2. Abre una ventana `cmd` por cada servicio (6 en total)
3. Espera entre servicios para que arranquen en el orden correcto:
   - DB (20 seg) → BackendSys (15 seg) → BFF (15 seg) → MFEs (40 seg) → Shell

**Ventanas que abre:**
- `GYE - Base de Datos` → PostgreSQL en Docker
- `GYE - BackendSys`   → API .NET puerto 5001
- `GYE - BFF`          → BFF .NET puerto 5002
- `GYE - Recaudacion`  → MFE Angular puerto 4201
- `GYE - Convenio`     → MFE Angular puerto 4202
- `GYE - Shell`        → Host Angular puerto 4200

---

### Windows — stop-all.bat

```
Doble click en: Docs/scripts/stop-all.bat
```

---

### macOS — start-all.sh / stop-all.sh

```bash
bash Docs/scripts/start-all.sh
bash Docs/scripts/stop-all.sh
```
