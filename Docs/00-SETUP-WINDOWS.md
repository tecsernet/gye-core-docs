# Setup en Windows — GYE-CORE

Guía completa de instalación y configuración en **Windows 11** desde cero.

---

## Herramientas Requeridas

| Herramienta       | Versión       | Para qué sirve                         |
|-------------------|---------------|----------------------------------------|
| Git               | 2.x           | Control de versiones                   |
| Node.js (nvm)     | 22.x          | Frontend Angular / Nx                  |
| .NET SDK          | 10.x          | Backend C#                             |
| dotnet-ef         | 10.x          | Migraciones de base de datos EF Core   |
| Docker Desktop    | latest        | PostgreSQL + Redis en contenedores     |
| WSL 2             | (requerido)   | Motor de virtualización para Docker    |
| Angular CLI       | 21.x          | Comandos Angular                       |
| Nx                | 22.x          | Monorepo frontend                      |
| Firebase CLI      | latest        | Deploy frontend a Firebase Hosting     |
| gh CLI            | 2.x           | GitHub desde terminal                  |
| gcloud CLI        | latest        | Google Cloud / despliegue              |

---

## Paso 1 — WSL 2 (requerido para Docker)

Abre **PowerShell como Administrador**:

```powershell
wsl --install
```

Reinicia el equipo cuando termine. Luego verifica:

```powershell
wsl --version
wsl --list --verbose
```

> Si ya tienes WSL pero es versión 1, actualiza: `wsl --set-default-version 2`

---

## Paso 2 — Git

```powershell
# PowerShell como Administrador
winget install Git.Git
```

Cierra y vuelve a abrir la terminal. Verifica:

```bash
git --version   # git version 2.x.x
```

Configura tu identidad:

```bash
git config --global user.name "Tu Nombre"
git config --global user.email "tu@email.com"
```

---

## Paso 3 — Node.js con nvm-windows

1. Descarga el instalador `nvm-setup.exe` desde:
   https://github.com/coreybutler/nvm-windows/releases/latest

2. Instala y cierra la terminal completamente.

3. Abre **Git Bash** o **PowerShell** nuevo y ejecuta:

```bash
nvm install 22
nvm use 22
```

Verifica:

```bash
node --version   # v22.x.x
npm --version    # 10.x.x
```

---

## Paso 4 — .NET 10 SDK

```powershell
# PowerShell como Administrador
winget install Microsoft.DotNet.SDK.10
```

Cierra y vuelve a abrir la terminal. Verifica:

```bash
dotnet --version      # 10.0.x
dotnet --list-sdks
```

---

## Paso 5 — dotnet-ef (migraciones)

```bash
dotnet tool install --global dotnet-ef
```

Verifica:

```bash
dotnet ef --version   # Entity Framework Core .NET Command-line Tools 10.x.x
```

> **Importante:** Sin esta herramienta no se pueden crear ni aplicar migraciones manualmente.

---

## Paso 6 — Docker Desktop

1. Descarga desde: https://www.docker.com/products/docker-desktop/
2. Instala (requiere reinicio)
3. Abre **Docker Desktop** y espera el icono de la ballena verde en la barra de tareas
4. Ve a Settings → General → asegúrate de que **"Use WSL 2 based engine"** esté activado

Verifica:

```bash
docker --version
docker compose version
docker ps   # debe responder sin error
```

---

## Paso 7 — Angular CLI, Nx y Firebase CLI

```bash
npm install -g @angular/cli@21 nx firebase-tools
```

Verifica:

```bash
ng version        # Angular CLI: 21.x.x
nx --version      # 22.x.x
firebase --version
```

---

## Paso 8 — GitHub CLI (gh)

```powershell
# PowerShell como Administrador
winget install GitHub.cli
```

Autenticar:

```bash
gh auth login
# Seleccionar: GitHub.com → HTTPS → Login with browser
```

Verifica:

```bash
gh --version
gh auth status
```

---

## Paso 9 — Google Cloud CLI (gcloud)

```powershell
# PowerShell como Administrador
winget install Google.CloudSDK
```

Cierra y vuelve a abrir la terminal. Inicializa:

```bash
gcloud init
gcloud auth login
gcloud config set project gye-core
```

Verifica:

```bash
gcloud --version | head -1
```

---

## Paso 10 — Verificar Todo

Ejecuta este script en **Git Bash**:

```bash
bash Docs/scripts/verify-tools.sh
```

O manualmente:

```bash
echo "=== Git ===" && git --version
echo "=== .NET ===" && dotnet --version
echo "=== dotnet-ef ===" && dotnet ef --version 2>/dev/null || echo "NO instalado"
echo "=== Node ===" && node --version
echo "=== npm ===" && npm --version
echo "=== Angular ===" && ng version 2>/dev/null | grep "Angular CLI" || echo "NO instalado"
echo "=== Nx ===" && nx --version 2>/dev/null || echo "NO instalado"
echo "=== Firebase ===" && firebase --version 2>/dev/null || echo "NO instalado"
echo "=== Docker ===" && docker --version
echo "=== Docker daemon ===" && docker ps > /dev/null 2>&1 && echo "OK corriendo" || echo "Abrir Docker Desktop"
echo "=== gh ===" && gh --version 2>/dev/null | head -1 || echo "NO instalado"
echo "=== gcloud ===" && gcloud --version 2>/dev/null | head -1 || echo "NO instalado"
```

---

## Paso 11 — Clonar Repositorios

```bash
cd C:/GIT/Municipio
bash Docs/scripts/clone-all.sh
```

O manualmente (Git Bash):

```bash
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

---

## Paso 12 — Configurar Archivo de Entorno del Backend

```bash
cd C:/GIT/Municipio/Backend/gye-core-backend-sys
copy src\GYE.Api\appsettings.Development.json.example src\GYE.Api\appsettings.Development.json
```

El archivo ya tiene la connection string correcta para PostgreSQL local — **no requiere edición**.

---

## Paso 13 — Levantar el Sistema

> Ver guía completa en `Docs/INICIO-RAPIDO.md` o usar el script automático:

```bash
# Doble click en:
Docs/scripts/start-all.bat
```

O manualmente abrir 6 terminales siguiendo `Docs/COMANDOS-RAPIDOS.md`.

---

## URLs del Sistema

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

---

## Troubleshooting

### Docker no inicia
- Verificar que WSL 2 está instalado: `wsl --version`
- Si no: `wsl --install` en PowerShell Admin y reiniciar

### Puerto en uso
```bash
netstat -ano | findstr :5001
taskkill /PID [PID] /F
```

### `nx: command not found`
```bash
npm install -g nx
# o usar: npx nx serve portal-shell
```

### `dotnet ef: command not found`
```bash
dotnet tool install --global dotnet-ef
# Cerrar y reabrir la terminal
```

### PostgreSQL no conecta
```bash
docker compose ps                        # verificar que está healthy
docker compose logs postgres | tail -20  # ver errores
docker compose restart postgres          # reiniciar si es necesario
```
