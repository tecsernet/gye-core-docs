#!/bin/bash
# GYE-CORE — Levanta el sistema completo en macOS
# Uso: bash Docs/scripts/start-all.sh

# Detectar directorio base (funciona desde cualquier ubicacion)
BASE_DIR="$(cd "$(dirname "$0")/../.." && pwd)"

echo ""
echo " =========================================="
echo "  GYE-CORE - Levantando sistema completo"
echo "  Base: $BASE_DIR"
echo " =========================================="
echo ""

# ─── Verificar Docker ─────────────────────────────────────────
if ! docker ps > /dev/null 2>&1; then
  echo " ERROR: Docker no está corriendo."
  echo " Abre Docker Desktop y espera el icono de la ballena verde."
  echo ""
  exit 1
fi
echo " [OK] Docker corriendo"

# ─── Función: abrir nueva ventana de Terminal en Mac ──────────
open_terminal() {
  local title="$1"
  local cmd="$2"
  osascript <<EOF
tell application "Terminal"
  activate
  set newTab to do script "$cmd"
  set custom title of front window to "$title"
end tell
EOF
}

# ─── BASE DE DATOS ─────────────────────────────────────────────
echo " [1/6] Levantando Base de Datos..."
open_terminal "GYE - Base de Datos" \
  "cd $BASE_DIR/BaseDeDatos/gye-core-db/SQL && docker compose up"

echo " Esperando SQL Server (30 seg)..."
sleep 30

# ─── BACKEND SYS ───────────────────────────────────────────────
echo " [2/6] Levantando BackendSys (puerto 5001)..."
open_terminal "GYE - BackendSys" \
  "cd $BASE_DIR/Backend/gye-core-backend-sys && dotnet run --project src/GYE.Api --launch-profile http"

echo " Esperando BackendSys (15 seg)..."
sleep 15

# ─── BFF ───────────────────────────────────────────────────────
echo " [3/6] Levantando BFF (puerto 5000)..."
open_terminal "GYE - BFF" \
  "cd $BASE_DIR/Backend/gye-core-bff && dotnet run --project src/GYE.Bff --launch-profile http"

echo " Esperando BFF (15 seg)..."
sleep 15

# ─── MFE RECAUDACION ───────────────────────────────────────────
echo " [4/6] Levantando MFE Recaudacion (puerto 4201)..."
open_terminal "GYE - Recaudacion" \
  "cd $BASE_DIR/Frontend/gye-core-recaudacion && npx nx serve recaudacion"

# ─── MFE CONVENIO ──────────────────────────────────────────────
echo " [5/6] Levantando MFE Convenio (puerto 4202)..."
open_terminal "GYE - Convenio" \
  "cd $BASE_DIR/Frontend/gye-core-convenio && npx nx serve convenio"

echo " Esperando MFEs (40 seg)..."
sleep 40

# ─── SHELL ─────────────────────────────────────────────────────
echo " [6/6] Levantando Shell (puerto 4200)..."
open_terminal "GYE - Shell" \
  "cd $BASE_DIR/Frontend/gye-core-shell && npx nx serve shell"

echo ""
echo " =========================================="
echo "  Sistema levantando en segundo plano..."
echo ""
echo "  Portal:    http://localhost:4200"
echo "  BFF:       http://localhost:5000/swagger"
echo "  Backend:   http://localhost:5001/swagger"
echo " =========================================="
echo ""
echo " Para parar todo: bash Docs/scripts/stop-all.sh"
echo ""
