# Flujo de Desarrollo — GYE-CORE

Guía día a día para trabajar con el sistema.

---

## Inicio del Día (Checklist)

```bash
# 1. Levantar Docker (si no está corriendo)
#    → Abrir Docker Desktop y esperar icono verde

# 2. Levantar Base de Datos
cd C:/GIT/Municipio/BaseDeDatos/gye-core-db
docker compose up -d

# 3. Verificar DB
docker compose ps
# sqlserver y redis deben estar "Up (healthy)"

# 4. Abrir terminales para cada servicio
```

---

## Levantar Todo el Stack

Abre **6 terminales** (o usa Windows Terminal con tabs):

### Terminal 1 — BackendSys
```bash
cd C:/GIT/Municipio/Backend/gye-core-backend-sys
dotnet watch --project src/GYE.Core.Api run
```

### Terminal 2 — BFF
```bash
cd C:/GIT/Municipio/Backend/gye-core-bff
dotnet watch --project src/GYE.Bff.Api run
```

### Terminal 3 — MFE Recaudación
```bash
cd C:/GIT/Municipio/Frontend/gye-core-recaudacion
npx nx serve sys-recaudacion
```

### Terminal 4 — MFE Convenio
```bash
cd C:/GIT/Municipio/Frontend/gye-core-convenio
npx nx serve sys-convenio
```

### Terminal 5 — Shell (levantar último)
```bash
cd C:/GIT/Municipio/Frontend/gye-core-shell
npx nx serve portal-shell
```

### Terminal 6 — Libre (git, comandos, etc.)

---

## URLs del Sistema en Desarrollo

| Servicio          | URL                           |
|-------------------|-------------------------------|
| Portal principal  | http://localhost:4200         |
| MFE Recaudación   | http://localhost:4201         |
| MFE Convenio      | http://localhost:4202         |
| BFF API           | http://localhost:5002         |
| Swagger BFF       | http://localhost:5002/swagger |
| BackendSys API    | http://localhost:5001         |
| Swagger Backend   | http://localhost:5001/swagger |
| SQL Server        | localhost:1433                |
| Redis             | localhost:6379                |

---

## Flujo de Git — Feature Branch

```bash
# 1. Asegúrate de estar en main y actualizado
git checkout main
git pull origin main

# 2. Crear rama de feature
git checkout -b feature/nombre-de-la-funcionalidad

# 3. Desarrollar...

# 4. Commit
git add src/archivo-modificado.ts
git commit -m "feat: descripción de la funcionalidad"

# 5. Push y crear PR
git push origin feature/nombre-de-la-funcionalidad
gh pr create --title "feat: nombre" --body "Descripción del cambio"
```

### Convención de commits
```
feat:     nueva funcionalidad
fix:      corrección de bug
docs:     documentación
style:    formato (no cambia lógica)
refactor: refactoring
test:     tests
chore:    tareas de mantenimiento
```

---

## Actualizar un Repositorio

```bash
# Ejemplo: actualizar recaudacion
cd C:/GIT/Municipio/Frontend/gye-core-recaudacion
git pull origin main
npm install  # si hay cambios en package.json
npx nx serve sys-recaudacion
```

---

## Agregar una Nueva Feature al Microfrontend

```bash
cd C:/GIT/Municipio/Frontend/gye-core-recaudacion

# Generar componente en la librería de features
npx nx g @nx/angular:component consulta-deuda \
  --project=feature-recaudacion \
  --standalone

# Generar servicio
npx nx g @nx/angular:service deuda \
  --project=feature-recaudacion
```

---

## Agregar Endpoint al Backend

1. **Domain**: crear/modificar entidad en `GYE.Core.Domain/Entities/`
2. **Application**: crear query/command en `GYE.Core.Application/Features/`
3. **Infrastructure**: agregar repositorio si necesario
4. **Api**: agregar endpoint en el controller
5. **Migración**: `dotnet ef migrations add NombreCambio`

---

## Ejecutar Tests

```bash
# Tests backend
cd C:/GIT/Municipio/Backend/gye-core-backend-sys
dotnet test

# Tests frontend (todos)
cd C:/GIT/Municipio/Frontend/gye-core-shell
npx nx run-many --target=test --all

# Tests específico
npx nx test portal-shell --watch
```

---

## Troubleshooting Rápido

### MFE no carga en el shell
```bash
# Verificar que el remote está corriendo
curl http://localhost:4201/remoteEntry.js

# Si no responde, levantar el remote primero
cd C:/GIT/Municipio/Frontend/gye-core-recaudacion
npx nx serve sys-recaudacion
```

### Error de conexión a SQL Server
```bash
# Verificar contenedor
docker ps | grep sqlserver
docker logs gye-sqlserver | tail -20

# Reiniciar si es necesario
docker compose restart sqlserver
```

### Error "Could not load remoteEntry.js"
- Asegúrate de levantar los MFEs ANTES que el shell
- El orden correcto: recaudacion → convenio → shell

### Hot reload no funciona en Angular
```bash
# Limpiar caché NX
npx nx reset
# Volver a servir
npx nx serve portal-shell
```

### Error CORS en peticiones al BFF
- Verificar `appsettings.Development.json` en BFF
- `AllowedOrigins` debe incluir `http://localhost:4200`

---

## Script de Parada del Sistema

```bash
# Parar todos los procesos Node/dotnet:
# Ctrl+C en cada terminal

# Parar Docker
cd C:/GIT/Municipio/BaseDeDatos/gye-core-db
docker compose stop
```
