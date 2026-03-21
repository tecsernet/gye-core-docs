# Setup en Windows — GYE-CORE

Guía completa de instalación y configuración en **Windows 11**.

---

## Estado de Herramientas

| Herramienta     | Versión Requerida | Instalación          |
|-----------------|-------------------|----------------------|
| Node.js         | 22.x (nvm)        | nvm-windows          |
| .NET SDK        | 10.x              | winget / descarga    |
| Git             | 2.x               | winget               |
| Docker Desktop  | latest            | Descarga manual      |
| Angular CLI     | 21.x              | npm global           |
| Nx              | 21.x              | npm global           |
| gh CLI          | latest            | winget               |
| gcloud CLI      | latest            | winget / descarga    |

---

## Paso 1 — Verificar Herramientas Actuales

Abre **Git Bash** o **PowerShell** y ejecuta:

```bash
echo "=== .NET ===" && dotnet --version
echo "=== Node ===" && node --version
echo "=== npm ===" && npm --version
echo "=== Git ===" && git --version
echo "=== Docker ===" && docker --version 2>/dev/null || echo "NO instalado"
echo "=== Angular ===" && ng version 2>/dev/null | grep "Angular CLI" || echo "NO instalado"
echo "=== Nx ===" && nx --version 2>/dev/null || echo "NO instalado"
echo "=== gh ===" && gh --version 2>/dev/null | head -1 || echo "NO instalado"
echo "=== gcloud ===" && gcloud --version 2>/dev/null | head -1 || echo "NO instalado"
```

---

## Paso 2 — .NET 10 SDK

> **Verificar primero:** `dotnet --version` → debe mostrar `10.x.x`

Si no está instalado:

```powershell
# Opción A: winget (PowerShell como Administrador)
winget install Microsoft.DotNet.SDK.10

# Opción B: Descarga manual
# https://dotnet.microsoft.com/download/dotnet/10.0
```

Verificar:
```bash
dotnet --version        # 10.0.x
dotnet --list-sdks      # muestra todos los SDKs
```

---

## Paso 3 — Docker Desktop

1. Descarga desde: https://www.docker.com/products/docker-desktop/
2. Instalar (requiere reinicio)
3. Abrir Docker Desktop y esperar el icono de la ballena verde
4. En Settings > General: habilitar **"Use WSL 2 based engine"**

Verificar:
```bash
docker --version
docker compose version
docker ps
```

---

## Paso 4 — Angular CLI y Nx

```bash
# Instalar globales
npm install -g @angular/cli@21 nx

# Verificar
ng version | grep "Angular CLI"
nx --version
```

---

## Paso 5 — GitHub CLI (gh)

```powershell
# PowerShell como Administrador
winget install GitHub.cli
```

```bash
# Autenticar
gh auth login
# Seguir pasos: GitHub.com > HTTPS > Login with browser
```

Verificar:
```bash
gh --version
gh auth status
```

---

## Paso 6 — Google Cloud CLI (gcloud)

```powershell
# PowerShell como Administrador
winget install Google.CloudSDK
```

O descarga el instalador desde: https://cloud.google.com/sdk/docs/install-sdk#windows

```bash
# Inicializar y autenticar
gcloud init
gcloud auth login
gcloud config set project [TU-PROJECT-ID]
```

Verificar:
```bash
gcloud --version | head -1
gcloud config list
```

---

## Paso 7 — Clonar Repositorios

```bash
# Ir al directorio del proyecto
cd C:/GIT/Municipio

# Ejecutar script de clonado
bash Docs/scripts/clone-all.sh
```

O manualmente:

```bash
cd C:/GIT/Municipio/BaseDeDatos
git clone https://github.com/stdpacheco/gye-core-db

cd C:/GIT/Municipio/Backend
git clone https://github.com/stdpacheco/gye-core-backend-sys
git clone https://github.com/stdpacheco/gye-core-bff

cd C:/GIT/Municipio/Frontend
git clone https://github.com/stdpacheco/gye-core-shell
git clone https://github.com/stdpacheco/gye-core-recaudacion
git clone https://github.com/stdpacheco/gye-core-convenio
```

---

## Paso 8 — Variables de Entorno

Copia los archivos de ejemplo:

```bash
# Backend Sys
cp Backend/gye-core-backend-sys/appsettings.example.json \
   Backend/gye-core-backend-sys/appsettings.Development.json

# BFF
cp Backend/gye-core-bff/appsettings.example.json \
   Backend/gye-core-bff/appsettings.Development.json

# Frontend Shell
cp Frontend/gye-core-shell/.env.example \
   Frontend/gye-core-shell/.env.local
```

---

## Paso 9 — Levantar el Sistema Completo

```bash
# Terminal 1 — Base de datos (SQL Server + Redis)
cd C:/GIT/Municipio/BaseDeDatos/gye-core-db
docker compose up -d
docker compose logs -f   # ver logs

# Terminal 2 — Backend Sys (puerto 5001)
cd C:/GIT/Municipio/Backend/gye-core-backend-sys
dotnet restore
dotnet run --launch-profile Development

# Terminal 3 — BFF (puerto 5002)
cd C:/GIT/Municipio/Backend/gye-core-bff
dotnet restore
dotnet run --launch-profile Development

# Terminal 4 — Frontend: Microfrontend recaudacion (puerto 4201)
cd C:/GIT/Municipio/Frontend/gye-core-recaudacion
npm install
npx nx serve sys-recaudacion

# Terminal 5 — Frontend: Microfrontend convenio (puerto 4202)
cd C:/GIT/Municipio/Frontend/gye-core-convenio
npm install
npx nx serve sys-convenio

# Terminal 6 — Frontend: Shell host (puerto 4200)
cd C:/GIT/Municipio/Frontend/gye-core-shell
npm install
npx nx serve portal-shell
```

---

## Verificación Final

| Servicio          | URL                     |
|-------------------|-------------------------|
| Portal Shell      | http://localhost:4200   |
| Recaudación MFE   | http://localhost:4201   |
| Convenio MFE      | http://localhost:4202   |
| BFF API           | http://localhost:5002   |
| BackendSys API    | http://localhost:5001   |
| SQL Server        | localhost:1433          |
| Redis             | localhost:6379          |
| Swagger BFF       | http://localhost:5002/swagger |
| Swagger Backend   | http://localhost:5001/swagger |

---

## Troubleshooting

### Docker no inicia en Windows
- Verificar que WSL 2 está instalado: `wsl --version`
- Instalar WSL 2: `wsl --install` (PowerShell Admin)
- Reiniciar después de instalar Docker Desktop

### Puerto en uso
```bash
# Ver qué usa el puerto (ej: 5001)
netstat -ano | findstr :5001
# Matar proceso por PID
taskkill /PID [PID] /F
```

### Error CORS en Frontend
- Verificar que BFF corre en puerto 5002
- Revisar `appsettings.Development.json` → `AllowedOrigins`

### nx: command not found
```bash
npm install -g nx
# o usar:
npx nx serve [app]
```
