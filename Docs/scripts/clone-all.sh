#!/bin/bash
# GYE-CORE — Clonar todos los repositorios
# Ejecutar desde: C:/GIT/Municipio/
# Uso: bash Docs/scripts/clone-all.sh

set -e

BASE_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
echo "========================================"
echo " GYE-CORE — Clonando repositorios"
echo " Directorio base: $BASE_DIR"
echo "========================================"

clone_or_pull() {
  local dir="$1"
  local repo="$2"
  local name="$(basename $repo .git)"

  if [ -d "$dir/$name/.git" ]; then
    echo ""
    echo ">>> Actualizando $name..."
    cd "$dir/$name"
    git pull origin main 2>/dev/null || git pull origin master 2>/dev/null || echo "  (sin cambios o rama no encontrada)"
    cd "$BASE_DIR"
  else
    echo ""
    echo ">>> Clonando $name..."
    git clone "$repo" "$dir/$name"
  fi
}

# ─── BASE DE DATOS ────────────────────────────────────────────
echo ""
echo "=== BASE DE DATOS ==="
clone_or_pull "$BASE_DIR/BaseDeDatos" "https://github.com/stdpacheco/gye-core-db"

# ─── BACKEND ──────────────────────────────────────────────────
echo ""
echo "=== BACKEND ==="
clone_or_pull "$BASE_DIR/Backend" "https://github.com/stdpacheco/gye-core-backend-sys"
clone_or_pull "$BASE_DIR/Backend" "https://github.com/stdpacheco/gye-core-bff"

# ─── FRONTEND ─────────────────────────────────────────────────
echo ""
echo "=== FRONTEND ==="
clone_or_pull "$BASE_DIR/Frontend" "https://github.com/stdpacheco/gye-core-shell"
clone_or_pull "$BASE_DIR/Frontend" "https://github.com/stdpacheco/gye-core-recaudacion"
clone_or_pull "$BASE_DIR/Frontend" "https://github.com/stdpacheco/gye-core-convenio"

echo ""
echo "========================================"
echo " Clonado completado!"
echo "========================================"
echo ""
echo "Estructura:"
ls "$BASE_DIR/BaseDeDatos/" 2>/dev/null && echo "  BaseDeDatos/ OK" || echo "  BaseDeDatos/ (vacío)"
ls "$BASE_DIR/Backend/" 2>/dev/null && echo "  Backend/ OK" || echo "  Backend/ (vacío)"
ls "$BASE_DIR/Frontend/" 2>/dev/null && echo "  Frontend/ OK" || echo "  Frontend/ (vacío)"
echo ""
echo "Siguiente paso: bash Docs/scripts/verify-tools.sh"
