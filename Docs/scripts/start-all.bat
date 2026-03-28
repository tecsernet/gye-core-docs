@echo off
title GYE-CORE Launcher
echo.
echo  ==========================================
echo   GYE-CORE - Levantando sistema completo
echo  ==========================================
echo.

REM Verificar Docker
docker ps >nul 2>&1
if errorlevel 1 (
    echo  ERROR: Docker no esta corriendo.
    echo  Abre Docker Desktop y espera el icono de la ballena verde.
    echo.
    pause
    exit /b 1
)
echo  [OK] Docker corriendo

REM ─── BASE DE DATOS ───────────────────────────────────────────
echo.
echo  [1/6] Levantando Base de Datos (PostgreSQL)...
start "GYE - Base de Datos" cmd /k "title GYE - Base de Datos && cd /d C:\GIT\Municipio\BaseDeDatos\gye-core-db && docker compose up"

echo  Esperando que PostgreSQL este listo (20 seg)...
timeout /t 20 /nobreak >nul

REM ─── BACKEND SYS ─────────────────────────────────────────────
echo  [2/6] Levantando BackendSys (puerto 5001)...
start "GYE - BackendSys" cmd /k "title GYE - BackendSys && cd /d C:\GIT\Municipio\Backend\gye-core-backend-sys && dotnet run --project src/GYE.Api"

echo  Esperando BackendSys (15 seg)...
timeout /t 15 /nobreak >nul

REM ─── BFF ─────────────────────────────────────────────────────
echo  [3/6] Levantando BFF (puerto 5002)...
start "GYE - BFF" cmd /k "title GYE - BFF && cd /d C:\GIT\Municipio\Backend\gye-core-bff && dotnet run --project src/GYE.Bff"

echo  Esperando BFF (15 seg)...
timeout /t 15 /nobreak >nul

REM ─── MFE RECAUDACION ─────────────────────────────────────────
echo  [4/6] Levantando MFE Recaudacion (puerto 4201)...
start "GYE - Recaudacion" cmd /k "title GYE - Recaudacion && cd /d C:\GIT\Municipio\Frontend\gye-core-recaudacion && npx nx serve sys-recaudacion"

REM ─── MFE CONVENIO ────────────────────────────────────────────
echo  [5/6] Levantando MFE Convenio (puerto 4202)...
start "GYE - Convenio" cmd /k "title GYE - Convenio && cd /d C:\GIT\Municipio\Frontend\gye-core-convenio && npx nx serve sys-convenio"

echo  Esperando MFEs (40 seg)...
timeout /t 40 /nobreak >nul

REM ─── SHELL ───────────────────────────────────────────────────
echo  [6/6] Levantando Shell (puerto 4200)...
start "GYE - Shell" cmd /k "title GYE - Shell && cd /d C:\GIT\Municipio\Frontend\gye-core-shell && npx nx serve portal-shell"

echo.
echo  ==========================================
echo   Sistema levantando en segundo plano...
echo.
echo   Portal:    http://localhost:4200
echo   BFF:       http://localhost:5002/swagger
echo   Backend:   http://localhost:5001/swagger
echo  ==========================================
echo.
echo  Para parar todo: ejecuta stop-all.bat
echo.
pause
