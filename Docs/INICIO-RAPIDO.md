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

### Windows (Git Bash)

```bash
# Crear estructura
mkdir -p C:/GIT/Municipio/{BaseDeDatos,Backend,Frontend,Docs}

# Clonar Base de datos
cd C:/GIT/Municipio/BaseDeDatos
git clone https://github.com/stdpacheco/gye-core-db

# Clonar Backend
cd C:/GIT/Municipio/Backend
git clone https://github.com/stdpacheco/gye-core-backend-sys
git clone https://github.com/stdpacheco/gye-core-bff

# Clonar Frontend
cd C:/GIT/Municipio/Frontend
git clone https://github.com/stdpacheco/gye-core-shell
git clone https://github.com/stdpacheco/gye-core-recaudacion
git clone https://github.com/stdpacheco/gye-core-convenio
```

### macOS (Terminal)

```bash
# Crear estructura
mkdir -p ~/GIT/Municipio/{BaseDeDatos,Backend,Frontend,Docs}

# Clonar Base de datos
cd ~/GIT/Municipio/BaseDeDatos
git clone https://github.com/stdpacheco/gye-core-db

# Clonar Backend
cd ~/GIT/Municipio/Backend
git clone https://github.com/stdpacheco/gye-core-backend-sys
git clone https://github.com/stdpacheco/gye-core-bff

# Clonar Frontend
cd ~/GIT/Municipio/Frontend
git clone https://github.com/stdpacheco/gye-core-shell
git clone https://github.com/stdpacheco/gye-core-recaudacion
git clone https://github.com/stdpacheco/gye-core-convenio
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

### Base de datos — archivo .env

```bash
# Windows (Git Bash)
echo "SA_PASSWORD=GyeCore2025!" > C:/GIT/Municipio/BaseDeDatos/gye-core-db/SQL/.env

# macOS
echo "SA_PASSWORD=GyeCore2025!" > ~/GIT/Municipio/BaseDeDatos/gye-core-db/SQL/.env
```

### BackendSys — appsettings.Development.json

**Windows:**
```bash
cd C:/GIT/Municipio/Backend/gye-core-backend-sys
cp src/GYE.Api/appsettings.Development.json.example \
   src/GYE.Api/appsettings.Development.json
```

**macOS:**
```bash
cd ~/GIT/Municipio/Backend/gye-core-backend-sys
cp src/GYE.Api/appsettings.Development.json.example \
   src/GYE.Api/appsettings.Development.json
```

Editar el archivo — cambiar `TU_PASSWORD_AQUI` por `GyeCore2025!`:

```json
{
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning",
      "Microsoft.EntityFrameworkCore.Database.Command": "Information"
    }
  },
  "ConnectionStrings": {
    "DefaultConnection": "Server=localhost,1433;Database=GYECore;User Id=sa;Password=GyeCore2025!;TrustServerCertificate=True;"
  }
}
```

### BFF — appsettings.Development.json

**Windows:**
```bash
cd C:/GIT/Municipio/Backend/gye-core-bff
cp src/GYE.Bff/appsettings.Development.json.example \
   src/GYE.Bff/appsettings.Development.json
```

**macOS:**
```bash
cd ~/GIT/Municipio/Backend/gye-core-bff
cp src/GYE.Bff/appsettings.Development.json.example \
   src/GYE.Bff/appsettings.Development.json
```

El archivo queda así (no necesita cambios):

```json
{
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning"
    }
  },
  "BackendSys": {
    "BaseUrl": "http://localhost:5001"
  }
}
```

---

## 4. Levantar el Sistema

> Abre **6 terminales** (o tabs en Windows Terminal / iTerm2).
> Orden importante: **DB → Backend → BFF → MFEs → Shell**

### Terminal 1 — Base de Datos

```bash
# Windows
cd C:/GIT/Municipio/BaseDeDatos/gye-core-db/SQL

# macOS
cd ~/GIT/Municipio/BaseDeDatos/gye-core-db/SQL

# Ambos:
docker compose up -d

# Verificar (esperar ~30 segundos)
docker compose ps
# Debe mostrar: gye-core-sqlserver → Up (healthy)
```

### Terminal 2 — BackendSys (puerto 5001)

```bash
# Windows
cd C:/GIT/Municipio/Backend/gye-core-backend-sys

# macOS
cd ~/GIT/Municipio/Backend/gye-core-backend-sys

# Ambos:
dotnet restore BackendSys.sln
dotnet run --project src/GYE.Api --launch-profile http
```

Esperar a ver:
```
Now listening on: http://localhost:5001
Application started.
```

### Terminal 3 — BFF (puerto 5000)

```bash
# Windows
cd C:/GIT/Municipio/Backend/gye-core-bff

# macOS
cd ~/GIT/Municipio/Backend/gye-core-bff

# Ambos:
dotnet restore BackendBff.sln
dotnet run --project src/GYE.Bff --launch-profile http
```

Esperar a ver:
```
Now listening on: http://localhost:5000
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
npx nx serve recaudacion
```

Esperar a ver:
```
✔ Compiled successfully.
Local: http://localhost:4201/
```

### Terminal 5 — MFE Convenio (puerto 4202)

```bash
# Windows
cd C:/GIT/Municipio/Frontend/gye-core-convenio

# macOS
cd ~/GIT/Municipio/Frontend/gye-core-convenio

# Ambos:
npm install
npx nx serve convenio
```

Esperar a ver:
```
✔ Compiled successfully.
Local: http://localhost:4202/
```

### Terminal 6 — Shell Host (puerto 4200) — ÚLTIMO

```bash
# Windows
cd C:/GIT/Municipio/Frontend/gye-core-shell

# macOS
cd ~/GIT/Municipio/Frontend/gye-core-shell

# Ambos:
npm install
npx nx serve shell
```

Esperar a ver:
```
✔ Compiled successfully.
Local: http://localhost:4200/
```

---

## 5. Verificar que Todo Funciona

### URLs del sistema

| Servicio           | URL                           | Verificar                    |
|--------------------|-------------------------------|------------------------------|
| Portal principal   | http://localhost:4200         | Debe cargar la app           |
| MFE Recaudación    | http://localhost:4201         | Debe cargar el microfrontend |
| MFE Convenio       | http://localhost:4202         | Debe cargar el microfrontend |
| Swagger BackendSys | http://localhost:5001/swagger | Lista de endpoints           |
| Swagger BFF        | http://localhost:5000/swagger | Lista de endpoints           |
| SQL Server         | localhost:1433                | Azure Data Studio / SSMS     |

### Verificar remoteEntry.mjs

```bash
# Los MFEs deben exponer su entrada para el shell:
curl http://localhost:4201/remoteEntry.mjs | head -3
curl http://localhost:4202/remoteEntry.mjs | head -3
```

---

## Troubleshooting

### SQL Server no levanta

```bash
docker compose logs sqlserver -f
# Esperar el mensaje: "SQL Server is now ready for client connections"
# Si tarda más de 60 seg, reiniciar:
docker compose restart sqlserver
```

### "Cannot connect to SQL Server" en el backend

- Verificar que Docker corre: `docker ps`
- Verificar la connection string en `appsettings.Development.json`
- Password: `GyeCore2025!` (no `TU_PASSWORD_AQUI`)

### Shell no carga los microfrontends

1. Verificar que recaudacion (4201) y convenio (4202) están corriendo
2. Abrir en el browser: `http://localhost:4201/remoteEntry.mjs`
3. Si no responde → el MFE no está levantado

### "Port already in use"

```bash
# Windows
netstat -ano | findstr :4200
taskkill /PID [PID] /F

# macOS
lsof -i :4200
kill -9 [PID]
```

### Docker no instalado

- Descarga e instala Docker Desktop: https://www.docker.com/products/docker-desktop/
- Windows: habilitar WSL 2 primero (`wsl --install` en PowerShell Admin)
- Mac: solo instalar el .dmg y abrir

### `nx: command not found`

```bash
npm install -g nx
# o usar directamente:
npx nx serve shell
```
