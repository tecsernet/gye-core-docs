# Setup en macOS — GYE-CORE

Guía completa de instalación desde **cero** en macOS (Intel y Apple Silicon / M1/M2/M3).

---

## Paso 0 — Herramientas base (Xcode CLI + Homebrew)

Abre **Terminal** y ejecuta:

```bash
# Instalar Xcode Command Line Tools (git incluido)
xcode-select --install
# → Aparece ventana, click en "Instalar", esperar ~5 min

# Verificar git
git --version
# → git version 2.x.x

# Instalar Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Apple Silicon (M1/M2/M3) — agregar brew al PATH:
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
source ~/.zshrc

# Intel Mac — ya está en /usr/local/bin, no necesita PATH

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
nvm current       # v22.x.x
```

---

## Paso 2 — .NET 10 SDK

```bash
# Instalar .NET 10 via script oficial
curl -sSL https://dot.net/v1/dotnet-install.sh | bash -s -- --channel 10.0

# Agregar al PATH
echo 'export DOTNET_ROOT="$HOME/.dotnet"' >> ~/.zshrc
echo 'export PATH="$PATH:$HOME/.dotnet:$HOME/.dotnet/tools"' >> ~/.zshrc
source ~/.zshrc

# Verificar
dotnet --version      # 10.x.x
dotnet --list-sdks
```

---

## Paso 3 — Docker Desktop

1. Descarga desde: https://www.docker.com/products/docker-desktop/
   - Apple Silicon: "Download for Mac - Apple Silicon"
   - Intel: "Download for Mac - Intel Chip"
2. Abre el `.dmg` y arrastra Docker a Applications
3. Abre Docker desde Applications
4. Espera el **icono de la ballena verde** en la barra de menú

```bash
# Verificar
docker --version
docker compose version
docker ps
```

---

## Paso 4 — Angular CLI y Nx

```bash
npm install -g @angular/cli@21 nx

# Verificar
ng version | grep "Angular CLI"    # 21.x.x
nx --version                        # 22.x.x
```

---

## Paso 5 — GitHub CLI

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

## Paso 6 — Google Cloud CLI

```bash
brew install --cask google-cloud-sdk

# Recargar
source ~/.zshrc

# Inicializar
gcloud init
gcloud auth login

# Verificar
gcloud --version | head -1
```

---

## Paso 7 — Clonar Repositorios

```bash
# Crear estructura de directorios
mkdir -p ~/GIT/Municipio/{BaseDeDatos,Backend,Frontend,Docs}

# Clonar
cd ~/GIT/Municipio/BaseDeDatos
git clone https://github.com/stdpacheco/gye-core-db

cd ~/GIT/Municipio/Backend
git clone https://github.com/stdpacheco/gye-core-backend-sys
git clone https://github.com/stdpacheco/gye-core-bff

cd ~/GIT/Municipio/Frontend
git clone https://github.com/stdpacheco/gye-core-shell
git clone https://github.com/stdpacheco/gye-core-recaudacion
git clone https://github.com/stdpacheco/gye-core-convenio
```

---

## Paso 8 — Configurar archivos de entorno

```bash
# BackendSys
cp ~/GIT/Municipio/Backend/gye-core-backend-sys/src/GYE.Api/appsettings.Development.json.example \
   ~/GIT/Municipio/Backend/gye-core-backend-sys/src/GYE.Api/appsettings.Development.json

# Editar el archivo y cambiar TU_PASSWORD_AQUI por GyeCore2025!
nano ~/GIT/Municipio/Backend/gye-core-backend-sys/src/GYE.Api/appsettings.Development.json

# BFF
cp ~/GIT/Municipio/Backend/gye-core-bff/src/GYE.Bff/appsettings.Development.json.example \
   ~/GIT/Municipio/Backend/gye-core-bff/src/GYE.Bff/appsettings.Development.json

# Base de datos — crear .env
echo "SA_PASSWORD=GyeCore2025!" > ~/GIT/Municipio/BaseDeDatos/gye-core-db/SQL/.env
```

---

## Paso 9 — Levantar el sistema

### Terminal 1 — Base de datos

```bash
cd ~/GIT/Municipio/BaseDeDatos/gye-core-db/SQL
docker compose up -d

# Verificar (esperar ~30 seg)
docker compose ps
# gye-core-sqlserver debe estar "Up (healthy)"
```

### Terminal 2 — BackendSys (puerto 5001)

```bash
cd ~/GIT/Municipio/Backend/gye-core-backend-sys
dotnet restore BackendSys.sln
dotnet run --project src/GYE.Api --launch-profile http
```

### Terminal 3 — BFF (puerto 5000)

```bash
cd ~/GIT/Municipio/Backend/gye-core-bff
dotnet restore BackendBff.sln
dotnet run --project src/GYE.Bff --launch-profile http
```

### Terminal 4 — MFE Recaudación (puerto 4201)

```bash
cd ~/GIT/Municipio/Frontend/gye-core-recaudacion
npm install
npx nx serve recaudacion
```

### Terminal 5 — MFE Convenio (puerto 4202)

```bash
cd ~/GIT/Municipio/Frontend/gye-core-convenio
npm install
npx nx serve convenio
```

### Terminal 6 — Shell (puerto 4200) — levantar ÚLTIMO

```bash
cd ~/GIT/Municipio/Frontend/gye-core-shell
npm install
npx nx serve shell
```

---

## Verificación de herramientas completa

Copia y pega en Terminal:

```bash
echo "=========================================="
echo " VERIFICACION HERRAMIENTAS GYE-CORE (Mac)"
echo "=========================================="

echo "" && echo "--- .NET ---"
dotnet --version && echo "OK: .NET" || echo "ERROR: instalar .NET 10"

echo "" && echo "--- Node / npm / nvm ---"
node --version && echo "OK: Node" || echo "ERROR: instalar Node 22"
npm --version && echo "OK: npm" || echo "ERROR"
nvm current && echo "OK: nvm" || echo "AVISO: nvm no activo"

echo "" && echo "--- Angular CLI ---"
ng version 2>/dev/null | grep "Angular CLI" && echo "OK" || \
  echo "ERROR: npm install -g @angular/cli@21"

echo "" && echo "--- Nx ---"
nx --version 2>/dev/null && echo "OK: Nx" || \
  echo "ERROR: npm install -g nx"

echo "" && echo "--- Docker ---"
docker --version && echo "OK: Docker" || echo "ERROR: instalar Docker Desktop"
docker compose version && echo "OK: Compose" || echo "ERROR"
docker ps > /dev/null 2>&1 && echo "OK: daemon corriendo" || \
  echo "AVISO: abrir Docker Desktop"

echo "" && echo "--- Git ---"
git --version && echo "OK: Git" || echo "ERROR"

echo "" && echo "--- gh CLI ---"
gh --version 2>/dev/null | head -1 && echo "OK" || \
  echo "ERROR: brew install gh"

echo "" && echo "--- gcloud ---"
gcloud --version 2>/dev/null | head -1 && echo "OK" || \
  echo "ERROR: brew install --cask google-cloud-sdk"

echo "" && echo "--- Repos clonados ---"
BASE=~/GIT/Municipio
for repo in BaseDeDatos/gye-core-db Backend/gye-core-backend-sys \
  Backend/gye-core-bff Frontend/gye-core-shell \
  Frontend/gye-core-recaudacion Frontend/gye-core-convenio; do
  [ -d "$BASE/$repo/.git" ] && echo "OK: $repo" || echo "FALTA: $repo"
done

echo "" && echo "=========================================="
echo " FIN VERIFICACION"
echo "=========================================="
```

---

## Troubleshooting Mac

### `brew: command not found` en Apple Silicon

```bash
eval "$(/opt/homebrew/bin/brew shellenv)"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
```

### `dotnet: command not found`

```bash
export DOTNET_ROOT="$HOME/.dotnet"
export PATH="$PATH:$HOME/.dotnet"
source ~/.zshrc
```

### Docker no inicia en Mac

- Verificar que está en Applications
- Ir a System Preferences → Privacy → permitir Docker
- Reiniciar Docker Desktop desde el menú de la ballena

### Puerto en uso

```bash
# Ver qué usa el puerto
lsof -i :4200
# Matar proceso
kill -9 [PID]
```

### `ng: command not found` después de instalar

```bash
# Verificar que npm global está en PATH
npm bin -g
# Agregar al .zshrc si falta
echo 'export PATH="$PATH:$(npm bin -g)"' >> ~/.zshrc
source ~/.zshrc
```
