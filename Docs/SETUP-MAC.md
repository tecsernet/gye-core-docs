# Setup en macOS — GYE-CORE

Guía completa de instalación desde **cero** en macOS (Intel y Apple Silicon M1/M2/M3).

---

## Herramientas Requeridas

| Herramienta       | Versión       | Para qué sirve                         |
|-------------------|---------------|----------------------------------------|
| Xcode CLI + Git   | 2.x           | Compiladores base + control versiones  |
| Homebrew          | latest        | Gestor de paquetes macOS               |
| Node.js (nvm)     | 22.x          | Frontend Angular / Nx                  |
| .NET SDK          | 10.x          | Backend C#                             |
| dotnet-ef         | 10.x          | Migraciones de base de datos EF Core   |
| Docker Desktop    | latest        | PostgreSQL + Redis en contenedores     |
| Angular CLI       | 21.x          | Comandos Angular                       |
| Nx                | 22.x          | Monorepo frontend                      |
| Firebase CLI      | latest        | Deploy frontend a Firebase Hosting     |
| gh CLI            | 2.x           | GitHub desde terminal                  |
| gcloud CLI        | latest        | Google Cloud / despliegue              |

---

## Paso 0 — Xcode CLI + Homebrew

Abre **Terminal** y ejecuta:

```bash
# Xcode Command Line Tools (incluye git y compiladores base)
xcode-select --install
# → Aparece ventana, clic en "Instalar", esperar ~5 min

# Verificar git
git --version   # git version 2.x.x

# Instalar Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Apple Silicon (M1/M2/M3) — agregar brew al PATH:
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
source ~/.zshrc

# Intel Mac — ya está en /usr/local/bin, no necesita PATH extra

# Verificar
brew --version
```

---

## Paso 1 — Node.js con nvm

```bash
# Instalar nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# Recargar shell
source ~/.zshrc

# Instalar Node 22
nvm install 22
nvm use 22
nvm alias default 22

# Verificar
node --version    # v22.x.x
npm --version     # 10.x.x
```

---

## Paso 2 — .NET 10 SDK

```bash
# Instalar via script oficial
curl -sSL https://dot.net/v1/dotnet-install.sh | bash -s -- --channel 10.0

# Agregar al PATH
echo 'export DOTNET_ROOT="$HOME/.dotnet"' >> ~/.zshrc
echo 'export PATH="$PATH:$HOME/.dotnet:$HOME/.dotnet/tools"' >> ~/.zshrc
source ~/.zshrc

# Verificar
dotnet --version      # 10.0.x
```

---

## Paso 3 — dotnet-ef (migraciones)

```bash
dotnet tool install --global dotnet-ef
```

Verifica:

```bash
dotnet ef --version   # Entity Framework Core .NET Command-line Tools 10.x.x
```

> **Importante:** Sin esta herramienta no se pueden crear ni aplicar migraciones manualmente.

---

## Paso 4 — Docker Desktop

1. Descarga desde: https://www.docker.com/products/docker-desktop/
   - Apple Silicon: "Download for Mac — Apple Silicon"
   - Intel: "Download for Mac — Intel Chip"
2. Abre el `.dmg` y arrastra Docker a Applications
3. Abre Docker desde Applications
4. Espera el **icono de la ballena verde** en la barra de menú

> Docker en macOS usa virtualización nativa — no requiere configuración extra como WSL.

Verifica:

```bash
docker --version
docker compose version
docker ps   # debe responder sin error
```

---

## Paso 5 — Angular CLI y Nx

```bash
npm install -g @angular/cli@21 nx firebase-tools

# Verificar
ng version | grep "Angular CLI"   # 21.x.x
nx --version                       # 22.x.x
firebase --version
```

---

## Paso 6 — GitHub CLI

```bash
brew install gh

# Autenticar
gh auth login
# Seleccionar: GitHub.com → HTTPS → Login with browser

# Verificar
gh --version
gh auth status
```

---

## Paso 7 — Google Cloud CLI

```bash
brew install --cask google-cloud-sdk

# Recargar
source ~/.zshrc

# Inicializar
gcloud init
gcloud auth login
gcloud config set project gye-core

# Verificar
gcloud --version | head -1
```

---

## Paso 8 — Verificar Todo

```bash
echo "=========================================="
echo " VERIFICACION HERRAMIENTAS GYE-CORE (Mac)"
echo "=========================================="

echo "" && echo "--- Git ---"
git --version || echo "ERROR: xcode-select --install"

echo "" && echo "--- Node / npm ---"
node --version || echo "ERROR: nvm install 22"
npm --version

echo "" && echo "--- .NET ---"
dotnet --version || echo "ERROR: instalar .NET 10"

echo "" && echo "--- dotnet-ef ---"
dotnet ef --version 2>/dev/null || echo "ERROR: dotnet tool install --global dotnet-ef"

echo "" && echo "--- Angular CLI ---"
ng version 2>/dev/null | grep "Angular CLI" || echo "ERROR: npm install -g @angular/cli@21"

echo "" && echo "--- Nx ---"
nx --version 2>/dev/null || echo "ERROR: npm install -g nx"

echo "" && echo "--- Firebase CLI ---"
firebase --version 2>/dev/null || echo "ERROR: npm install -g firebase-tools"

echo "" && echo "--- Docker ---"
docker --version || echo "ERROR: instalar Docker Desktop"
docker compose version || echo "ERROR"
docker ps > /dev/null 2>&1 && echo "OK: daemon corriendo" || echo "AVISO: abrir Docker Desktop"

echo "" && echo "--- gh CLI ---"
gh --version 2>/dev/null | head -1 || echo "ERROR: brew install gh"

echo "" && echo "--- gcloud ---"
gcloud --version 2>/dev/null | head -1 || echo "ERROR: brew install --cask google-cloud-sdk"

echo "" && echo "=========================================="
echo " FIN VERIFICACION"
echo "=========================================="
```

---

## Paso 9 — Clonar Repositorios

```bash
mkdir -p ~/GIT/Municipio/{BaseDeDatos,Backend,Frontend}
cd ~/GIT/Municipio
bash Docs/scripts/clone-all.sh
```

O manualmente:

```bash
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

---

## Paso 10 — Configurar Archivo de Entorno del Backend

```bash
cd ~/GIT/Municipio/Backend/gye-core-backend-sys
cp src/GYE.Api/appsettings.Development.json.example \
   src/GYE.Api/appsettings.Development.json
```

El archivo ya tiene la connection string correcta para PostgreSQL local — **no requiere edición**.

---

## Paso 11 — Levantar el Sistema

Ver guía completa en `Docs/INICIO-RAPIDO.md` o usar el script automático:

```bash
bash Docs/scripts/start-all.sh
```

O manualmente siguiendo `Docs/COMANDOS-RAPIDOS.md`.

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

### `brew: command not found` en Apple Silicon
```bash
eval "$(/opt/homebrew/bin/brew shellenv)"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
```

### `dotnet: command not found`
```bash
export DOTNET_ROOT="$HOME/.dotnet"
export PATH="$PATH:$HOME/.dotnet:$HOME/.dotnet/tools"
source ~/.zshrc
```

### `dotnet ef: command not found`
```bash
dotnet tool install --global dotnet-ef
source ~/.zshrc
```

### Docker no inicia en Mac
- Ir a System Settings → Privacy & Security → permitir Docker
- Reiniciar Docker Desktop desde el menú de la ballena

### Puerto en uso
```bash
lsof -i :4200
kill -9 [PID]
```

### `ng: command not found` después de instalar
```bash
# Verificar que npm global está en PATH
npm bin -g
echo 'export PATH="$PATH:$(npm bin -g 2>/dev/null)"' >> ~/.zshrc
source ~/.zshrc
```

### PostgreSQL no conecta
```bash
cd ~/GIT/Municipio/BaseDeDatos/gye-core-db
docker compose ps
docker compose logs postgres | tail -20
docker compose restart postgres
```
