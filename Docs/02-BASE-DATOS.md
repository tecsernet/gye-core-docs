# Base de Datos — GYE-CORE

PostgreSQL 16 ejecutándose en Docker.

## Docker Compose — DB

Archivo: `BaseDeDatos/gye-core-db/docker-compose.yml`

```yaml
services:
  postgres:
    image: postgres:16-alpine
    container_name: gye-postgres
    environment:
      POSTGRES_DB: gye_core
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres123
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      timeout: 5s
      retries: 5

  redis:
    image: redis:7-alpine
    container_name: gye-redis
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data

volumes:
  postgres_data:
  redis_data:
```

## Comandos Docker DB

```bash
cd C:/GIT/Municipio/BaseDeDatos/gye-core-db

# Levantar
docker compose up -d

# Ver estado
docker compose ps

# Ver logs PostgreSQL
docker compose logs postgres -f

# Parar (conserva datos)
docker compose stop

# Limpiar (BORRA datos)
docker compose down -v
```

## Conexión a PostgreSQL

| Parámetro | Valor        |
|-----------|--------------|
| Host      | localhost    |
| Port      | 5432         |
| User      | postgres     |
| Password  | postgres123  |
| Database  | gye_core     |

**Connection String (Npgsql):**
```
Host=localhost;Port=5432;Database=gye_core;Username=postgres;Password=postgres123
```

## Conectar con DBeaver / pgAdmin

1. Host: `localhost`
2. Port: `5432`
3. Database: `gye_core`
4. User: `postgres`
5. Password: `postgres123`

## Migraciones EF Core

Las migraciones se aplican automáticamente al arrancar el BackendSys.
Para crearlas o actualizarlas manualmente:

```bash
cd C:/GIT/Municipio/Backend/gye-core-backend-sys

# Crear nueva migración
dotnet ef migrations add NombreCambio \
  --project src/GYE.Infrastructure \
  --startup-project src/GYE.Api

# Aplicar manualmente
dotnet ef database update \
  --project src/GYE.Infrastructure \
  --startup-project src/GYE.Api
```

## Tablas Principales

```sql
-- Módulo Recaudación
Contribuyentes (Id, Nombres, Apellidos, Cedula, Email, Telefono, Direccion, Estado, FechaRegistro)
Predios        (Id, ContribuyenteId, Direccion, Parroquia, ValorCatastral, Tipo, FechaRegistro)
```
