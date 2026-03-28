# Inicio Rápido — GYE-CORE

Guía completa para levantar el sistema desde **cero**: clonar, configurar y ejecutar.
Cubre **Windows** y **macOS**.

---

## Índice

1. [Instalar herramientas](#1-instalar-herramientas)
2. [Clonar repositorios](#2-clonar-repositorios)
3. [Configurar archivos de entorno](#3-configurar-archivos-de-entorno)
4. [Levantar el sistema](#4-levantar-el-sistema)
5. [Verificar que todo funciona](#5-verificar-que-todo-funciona)

---

## 1. Instalar Herramientas

> Guías detalladas:
> - Windows → `Docs/00-SETUP-WINDOWS.md`
> - macOS   → `Docs/SETUP-MAC.md`

### Resumen rápido — Windows (PowerShell como Administrador)

```powershell
# .NET 10
winget install Microsoft.DotNet.SDK.10

# GitHub CLI
winget install GitHub.cli

# Google Cloud SDK
winget install Google.CloudSDK

# Node 22 via nvm-windows
# Descargar: https://github.com/coreybutler/nvm-windows/releases
# Luego:
nvm install 22
nvm use 22

# Angular CLI y Nx (en Git Bash o PowerShell)
npm install -g @angular/cli@21 nx

# dotnet-ef (migraciones)
dotnet tool install --global dotnet-ef

# Docker Desktop — descarga manual:
# https://www.docker.com/products/docker-desktop/
```

### Resumen rápido — macOS (Terminal)

```bash
# Homebrew (si no está)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# nvm + Node 22
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
source ~/.zshrc
nvm install 22 && nvm alias default 22

# .NET 10
curl -sSL https://dot.net/v1/dotnet-install.sh | bash -s -- --channel 10.0
echo 'export DOTNET_ROOT="$HOME/.dotnet"' >> ~/.zshrc
echo 'export PATH="$PATH:$HOME/.dotnet:$HOME/.dotnet/tools"' >> ~/.zshrc
source ~/.zshrc

# Herramientas
brew install gh
brew install --cask google-cloud-sdk
npm install -g @angular/cli@21 nx
dotnet tool install --global dotnet-ef

# Docker Desktop — descarga manual:
# https://www.docker.com/products/docker-desktop/
```

### Tabla de versiones objetivo

| Herramienta   | Versión    | Verificar              |
|---------------|------------|------------------------|
| Node.js       | 22.x       | `node --version`       |
| .NET SDK      | 10.x       | `dotnet --version`     |
| Angular CLI   | 21.x       | `ng version`           |
| Nx            | 22.x       | `nx --version`         |
| Docker        | latest     | `docker --version`     |
| gh CLI        | 2.x        | `gh --version`         |
| gcloud        | latest     | `gcloud --version`     |

---

## 2. Clonar Repositorios

### Opción A — Script automático (recomendado)

```bash
# Windows (Git Bash) — desde C:/GIT/Municipio/
bash Docs/scripts/clone-all.sh

# macOS — desde ~/GIT/Municipio/
bash Docs/scripts/clone-all.sh
```

### Opción B — Manual

**Windows (Git Bash):**
```bash
mkdir -p C:/GIT/Municipio/{BaseDeDatos,Backend,Frontend}

cd C:/GIT/Municipio/BaseDeDatos
git clone https://github.com/tecsernet/gye-core-db

cd C:/GIT/Municipio/Backend
git clone https://github.com/tecsernet/gye-core-backend-sys
git clone https://github.com/tecsernet/gye-core-bff

cd C:/GIT/Municipio/Frontend
git clone https://github.com/tecsernet/gye-core-shell
git clone https://github.com/tecsernet/gye-core-recaudacion
git clone https://github.com/tecsernet/gye-core-convenio
```

**macOS:**
```bash
mkdir -p ~/GIT/Municipio/{BaseDeDatos,Backend,Frontend}

cd ~/GIT/Municipio/BaseDeDatos
git clone https://github.com/tecsernet/gye-core-db

cd ~/GIT/Municipio/Backend
git clone https://github.com/tecsernet/gye-core-backend-sys
git clone https://github.com/tecsernet/gye-core-bff

cd ~/GIT/Municipio/Frontend
git clone https://github.com/tecsernet/gye-core-shell
git clone https://github.com/tecsernet/gye-core-recaudacion
git clone https://github.com/tecsernet/gye-core-convenio
```

### Resultado esperado

```
Municipio/
├── BaseDeDatos/
│   └── gye-core-db/
├── Backend/
│   ├── gye-core-backend-sys/
│   └── gye-core-bff/
├── Frontend/
│   ├── gye-core-shell/
│   ├── gye-core-recaudacion/
│   └── gye-core-convenio/
└── Docs/
```

---

## 3. Configurar Archivos de Entorno

### BackendSys — appsettings.Development.json

**Windows:**
```bash
cd C:/GIT/Municipio/Backend/gye-core-backend-sys
copy src\GYE.Api\appsettings.Development.json.example src\GYE.Api\appsettings.Development.json
```

**macOS:**
```bash
cd ~/GIT/Municipio/Backend/gye-core-backend-sys
cp src/GYE.Api/appsettings.Development.json.example src/GYE.Api/appsettings.Development.json
```

El archivo ya tiene la connection string correcta para PostgreSQL local — no requiere cambios:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Host=localhost;Port=5432;Database=gye_core;Username=postgres;Password=postgres123"
  }
}
```

> Este archivo está en `.gitignore` y nunca se sube a GitHub.

---

## 4. Levantar el Sistema

> Abre **6 terminales** (o tabs en Windows Terminal / iTerm2).
> Orden importante: **DB → BackendSys → BFF → MFEs → Shell**

### Terminal 1 — Base de Datos

```bash
# Windows
cd C:/GIT/Municipio/BaseDeDatos/gye-core-db

# macOS
cd ~/GIT/Municipio/BaseDeDatos/gye-core-db

# Ambos:
docker compose up -d

# Verificar (esperar ~20 segundos)
docker compose ps
# Debe mostrar: gye-postgres y gye-redis → Up (healthy)
```

### Terminal 2 — BackendSys (puerto 5001)

```bash
# Windows
cd C:/GIT/Municipio/Backend/gye-core-backend-sys

# macOS
cd ~/GIT/Municipio/Backend/gye-core-backend-sys

# Ambos:
dotnet restore
dotnet run --project src/GYE.Api
```

Esperar a ver:
```
Now listening on: http://localhost:5001
Application started.
```

> Las migraciones se aplican automáticamente al arrancar. La primera vez tarda unos segundos más.

### Terminal 3 — BFF (puerto 5002)

```bash
# Windows
cd C:/GIT/Municipio/Backend/gye-core-bff

# macOS
cd ~/GIT/Municipio/Backend/gye-core-bff

# Ambos:
dotnet restore
dotnet run --project src/GYE.Bff
```

Esperar a ver:
```
Now listening on: http://localhost:5002
Application started.
```

### Terminal 4 — MFE Recaudación (puerto 4201)

```bash
# Windows
cd C:/GIT/Municipio/Frontend/gye-core-recaudacion

# macOS
cd ~/GIT/Municipio/Frontend/gye-core-recaudacion

# Ambos:
npm install
npx nx serve sys-recaudacion
```

### Terminal 5 — MFE Convenio (puerto 4202)

```bash
# Windows
cd C:/GIT/Municipio/Frontend/gye-core-convenio

# macOS
cd ~/GIT/Municipio/Frontend/gye-core-convenio

# Ambos:
npm install
npx nx serve sys-convenio
```

### Terminal 6 — Shell Host (puerto 4200) — ÚLTIMO

```bash
# Windows
cd C:/GIT/Municipio/Frontend/gye-core-shell

# macOS
cd ~/GIT/Municipio/Frontend/gye-core-shell

# Ambos:
npm install
npx nx serve portal-shell
```

---

## 5. Verificar que Todo Funciona

### URLs del sistema

| Servicio           | URL                           |
|--------------------|-------------------------------|
| Portal principal   | http://localhost:4200         |
| MFE Recaudación    | http://localhost:4201         |
| MFE Convenio       | http://localhost:4202         |
| Swagger BackendSys | http://localhost:5001/swagger |
| Health BackendSys  | http://localhost:5001/health  |
| Swagger BFF        | http://localhost:5002/swagger |
| PostgreSQL         | localhost:5432                |
| Redis              | localhost:6379                |

### Verificar remoteEntry.mjs

```bash
# Los MFEs deben exponer su entrada para el shell:
curl http://localhost:4201/remoteEntry.mjs | head -3
curl http://localhost:4202/remoteEntry.mjs | head -3
```

---

## Troubleshooting

### PostgreSQL no levanta

```bash
docker compose logs postgres -f
# Reiniciar si es necesario:
docker compose restart postgres
```

### "Cannot connect to database" en el backend

- Verificar que Docker corre: `docker ps`
- Verificar la connection string en `src/GYE.Api/appsettings.Development.json`
- Confirmar que PostgreSQL está healthy: `docker compose ps`

### Shell no carga los microfrontends

1. Verificar que recaudacion (4201) y convenio (4202) están corriendo
2. Abrir en el browser: `http://localhost:4201/remoteEntry.mjs`
3. Si no responde → el MFE no está levantado, arrancarlo primero

### "Port already in use"

```bash
# Windows
netstat -ano | findstr :4200
taskkill /PID [PID] /F

# macOS
lsof -i :4200
kill -9 [PID]
```

### `nx: command not found`

```bash
npm install -g nx
# o usar directamente:
npx nx serve portal-shell
```

### Docker no instalado

- Descarga e instala Docker Desktop: https://www.docker.com/products/docker-desktop/
- Windows: habilitar WSL 2 primero (`wsl --install` en PowerShell Admin)
- Mac: solo instalar el .dmg y abrir
