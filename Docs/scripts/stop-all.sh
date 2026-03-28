#!/bin/bash
# GYE-CORE — Para el sistema completo en macOS
# Uso: bash Docs/scripts/stop-all.sh

BASE_DIR="$(cd "$(dirname "$0")/../.." && pwd)"

echo ""
echo " =========================================="
echo "  GYE-CORE - Parando sistema"
echo " =========================================="
echo ""

# ─── PARAR FRONTENDS (Node / nx) ──────────────────────────────
echo " Parando frontends (Node)..."
for port in 4200 4201 4202; do
  pid=$(lsof -ti :$port 2>/dev/null)
  if [ -n "$pid" ]; then
    kill -9 $pid 2>/dev/null
    echo "  [OK] Puerto $port liberado (PID $pid)"
  else
    echo "  [-] Puerto $port ya estaba libre"
  fi
done

# ─── PARAR BACKEND (.NET) ──────────────────────────────────────
echo " Parando backends (.NET)..."
for port in 5001 5002; do
  pid=$(lsof -ti :$port 2>/dev/null)
  if [ -n "$pid" ]; then
    kill -9 $pid 2>/dev/null
    echo "  [OK] Puerto $port liberado (PID $pid)"
  else
    echo "  [-] Puerto $port ya estaba libre"
  fi
done

# ─── PARAR BASE DE DATOS (Docker) ─────────────────────────────
echo " Parando Base de Datos (Docker)..."
cd "$BASE_DIR/BaseDeDatos/gye-core-db"
docker compose stop > /dev/null 2>&1
echo "  [OK] Base de datos parada (datos conservados)"

echo ""
echo " =========================================="
echo "  Sistema parado correctamente."
echo "  Los datos de la DB están conservados."
echo " =========================================="
echo ""
