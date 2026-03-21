# Comandos Rápidos — GYE-CORE

---

## PRIMERA VEZ (instalación + clonado ya hecho)

Orden obligatorio: DB → Backend → BFF → MFEs → Shell

```bash
# Terminal 1 — Base de datos
cd C:/GIT/Municipio/BaseDeDatos/gye-core-db/SQL   # Windows
cd ~/GIT/Municipio/BaseDeDatos/gye-core-db/SQL     # Mac
docker compose up -d

# Terminal 2 — BackendSys
cd C:/GIT/Municipio/Backend/gye-core-backend-sys   # Windows
cd ~/GIT/Municipio/Backend/gye-core-backend-sys    # Mac
dotnet restore BackendSys.sln
dotnet run --project src/GYE.Api --launch-profile http

# Terminal 3 — BFF
cd C:/GIT/Municipio/Backend/gye-core-bff           # Windows
cd ~/GIT/Municipio/Backend/gye-core-bff            # Mac
dotnet restore BackendBff.sln
dotnet run --project src/GYE.Bff --launch-profile http

# Terminal 4 — MFE Recaudación
cd C:/GIT/Municipio/Frontend/gye-core-recaudacion  # Windows
cd ~/GIT/Municipio/Frontend/gye-core-recaudacion   # Mac
npm install
npx nx serve recaudacion

# Terminal 5 — MFE Convenio
cd C:/GIT/Municipio/Frontend/gye-core-convenio     # Windows
cd ~/GIT/Municipio/Frontend/gye-core-convenio      # Mac
npm install
npx nx serve convenio

# Terminal 6 — Shell (ÚLTIMO)
cd C:/GIT/Municipio/Frontend/gye-core-shell        # Windows
cd ~/GIT/Municipio/Frontend/gye-core-shell         # Mac
npm install
npx nx serve shell
```

---

## DÍA A DÍA (ya instalado, solo levantar)

> Sin `dotnet restore` ni `npm install` — ya están las dependencias.

```bash
# Terminal 1 — Base de datos
cd C:/GIT/Municipio/BaseDeDatos/gye-core-db/SQL    # Windows
cd ~/GIT/Municipio/BaseDeDatos/gye-core-db/SQL     # Mac
docker compose up -d

# Terminal 2 — BackendSys
cd C:/GIT/Municipio/Backend/gye-core-backend-sys   # Windows
cd ~/GIT/Municipio/Backend/gye-core-backend-sys    # Mac
dotnet run --project src/GYE.Api --launch-profile http

# Terminal 3 — BFF
cd C:/GIT/Municipio/Backend/gye-core-bff           # Windows
cd ~/GIT/Municipio/Backend/gye-core-bff            # Mac
dotnet run --project src/GYE.Bff --launch-profile http

# Terminal 4 — MFE Recaudación
cd C:/GIT/Municipio/Frontend/gye-core-recaudacion  # Windows
cd ~/GIT/Municipio/Frontend/gye-core-recaudacion   # Mac
npx nx serve recaudacion

# Terminal 5 — MFE Convenio
cd C:/GIT/Municipio/Frontend/gye-core-convenio     # Windows
cd ~/GIT/Municipio/Frontend/gye-core-convenio      # Mac
npx nx serve convenio

# Terminal 6 — Shell (ÚLTIMO)
cd C:/GIT/Municipio/Frontend/gye-core-shell        # Windows
cd ~/GIT/Municipio/Frontend/gye-core-shell         # Mac
npx nx serve shell
```

---

## PARAR el sistema

```bash
# Frontends y backends: Ctrl+C en cada terminal

# Parar Docker (conserva los datos de la DB)
cd C:/GIT/Municipio/BaseDeDatos/gye-core-db/SQL    # Windows
cd ~/GIT/Municipio/BaseDeDatos/gye-core-db/SQL     # Mac
docker compose stop
```

---

## URLs del sistema

| Servicio         | URL                           |
|------------------|-------------------------------|
| Portal           | http://localhost:4200         |
| MFE Recaudación  | http://localhost:4201         |
| MFE Convenio     | http://localhost:4202         |
| Swagger BFF      | http://localhost:5000/swagger |
| Swagger Backend  | http://localhost:5001/swagger |

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

O desde Git Bash:
```bash
bash Docs/scripts/start-all.bat
```

**Qué hace:**
1. Verifica que Docker esté corriendo — si no, avisa y se detiene
2. Abre una ventana `cmd` por cada servicio (6 en total), con el nombre del servicio en el título
3. Espera entre servicios para que arranquen en el orden correcto:
   - DB (30 seg) → BackendSys (15 seg) → BFF (15 seg) → MFEs (40 seg) → Shell

**Ventanas que abre:**
- `GYE - Base de Datos` → SQL Server en Docker
- `GYE - BackendSys`   → API .NET puerto 5001
- `GYE - BFF`          → BFF .NET puerto 5000
- `GYE - Recaudacion`  → MFE Angular puerto 4201
- `GYE - Convenio`     → MFE Angular puerto 4202
- `GYE - Shell`        → Host Angular puerto 4200

Cuando el script termina, abre **http://localhost:4200** en el browser.

---

### Windows — stop-all.bat

```
Doble click en: Docs/scripts/stop-all.bat
```

**Qué hace:**
1. Cierra las ventanas cmd de frontends (Shell, Recaudacion, Convenio)
2. Cierra las ventanas cmd de backends (BackendSys, BFF)
3. Para el contenedor Docker de SQL Server — **los datos de la DB se conservan**

---

### macOS — start-all.sh

```bash
bash Docs/scripts/start-all.sh
```

**Qué hace:**
1. Verifica que Docker esté corriendo — si no, avisa y se detiene
2. Abre una ventana de Terminal por cada servicio (6 en total)
3. Espera entre servicios igual que la versión Windows

> Requiere que la app **Terminal** esté permitida en Privacidad del sistema
> (System Settings → Privacy → Automation → Terminal).

---

### macOS — stop-all.sh

```bash
bash Docs/scripts/stop-all.sh
```

**Qué hace:**
1. Busca y mata los procesos que usan los puertos 4200, 4201, 4202 (frontends)
2. Busca y mata los procesos que usan los puertos 5000, 5001 (backends)
3. Para el contenedor Docker de SQL Server — **los datos de la DB se conservan**
