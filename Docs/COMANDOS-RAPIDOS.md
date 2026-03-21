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
