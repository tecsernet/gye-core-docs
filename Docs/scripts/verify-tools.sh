#!/bin/bash
# GYE-CORE — Verificación de herramientas en Windows
# Ejecutar desde cualquier directorio
# Uso: bash Docs/scripts/verify-tools.sh

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

check() {
  local name="$1"
  local cmd="$2"
  local expected="$3"

  result=$($cmd 2>/dev/null | head -1)
  if [ -n "$result" ]; then
    echo -e "  ${GREEN}OK${NC}  $name: $result"
  else
    if [ -n "$expected" ]; then
      echo -e "  ${RED}ERR${NC} $name: No encontrado — instalar: $expected"
    else
      echo -e "  ${RED}ERR${NC} $name: No encontrado"
    fi
  fi
}

echo ""
echo "=========================================="
echo "  VERIFICACION HERRAMIENTAS GYE-CORE"
echo "  $(date)"
echo "=========================================="

echo ""
echo "--- Runtime ---"
check ".NET SDK"      "dotnet --version"    "winget install Microsoft.DotNet.SDK.10"
check "Node.js"       "node --version"      "nvm install 22"
check "npm"           "npm --version"       ""
check "Git"           "git --version"       "winget install Git.Git"

echo ""
echo "--- Angular / NX ---"
check "Angular CLI"   "ng version --skip-confirmation 2>/dev/null | grep 'Angular CLI'" \
                                            "npm install -g @angular/cli@21"
check "Nx"            "nx --version"        "npm install -g nx"

echo ""
echo "--- Docker ---"
check "Docker"        "docker --version"    "Descargar desde docker.com/products/docker-desktop"
check "Docker Compose" "docker compose version" ""

# Verificar si Docker daemon corre
if docker ps > /dev/null 2>&1; then
  echo -e "  ${GREEN}OK${NC}  Docker daemon: corriendo"
else
  echo -e "  ${YELLOW}AVS${NC} Docker daemon: no está corriendo — abrir Docker Desktop"
fi

echo ""
echo "--- Cloud Tools ---"
check "gh CLI"        "gh --version"        "winget install GitHub.cli"
check "gcloud"        "gcloud --version"    "winget install Google.CloudSDK"

echo ""
echo "--- Repositorios Clonados ---"
BASE_DIR="$(cd "$(dirname "$0")/../.." && pwd)"

check_repo() {
  local path="$1"
  local name="$(basename $path)"
  if [ -d "$path/.git" ]; then
    branch=$(cd "$path" && git branch --show-current 2>/dev/null)
    echo -e "  ${GREEN}OK${NC}  $name (rama: $branch)"
  else
    echo -e "  ${RED}ERR${NC} $name: No clonado — ejecutar clone-all.sh"
  fi
}

check_repo "$BASE_DIR/BaseDeDatos/gye-core-db"
check_repo "$BASE_DIR/Backend/gye-core-backend-sys"
check_repo "$BASE_DIR/Backend/gye-core-bff"
check_repo "$BASE_DIR/Frontend/gye-core-shell"
check_repo "$BASE_DIR/Frontend/gye-core-recaudacion"
check_repo "$BASE_DIR/Frontend/gye-core-convenio"

echo ""
echo "=========================================="
echo "  FIN VERIFICACION"
echo "=========================================="
echo ""
