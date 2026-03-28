@echo off
title GYE-CORE Stop
echo.
echo  ==========================================
echo   GYE-CORE - Parando sistema
echo  ==========================================
echo.

REM ─── PARAR FRONTENDS (Node) ──────────────────────────────────
echo  Parando frontends (Node)...
taskkill /FI "WINDOWTITLE eq GYE - Shell" /F >nul 2>&1
taskkill /FI "WINDOWTITLE eq GYE - Recaudacion" /F >nul 2>&1
taskkill /FI "WINDOWTITLE eq GYE - Convenio" /F >nul 2>&1
echo  [OK] Frontends parados

REM ─── PARAR BACKEND (.NET) ────────────────────────────────────
echo  Parando backends (.NET)...
taskkill /FI "WINDOWTITLE eq GYE - BackendSys" /F >nul 2>&1
taskkill /FI "WINDOWTITLE eq GYE - BFF" /F >nul 2>&1
echo  [OK] Backends parados

REM ─── PARAR BASE DE DATOS (Docker) ────────────────────────────
echo  Parando Base de Datos (Docker)...
taskkill /FI "WINDOWTITLE eq GYE - Base de Datos" /F >nul 2>&1
cd /d C:\GIT\Municipio\BaseDeDatos\gye-core-db
docker compose stop >nul 2>&1
echo  [OK] Base de datos parada (datos conservados)

echo.
echo  ==========================================
echo   Sistema parado correctamente.
echo   Los datos de la DB estan conservados.
echo  ==========================================
echo.
pause
