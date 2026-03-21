# Base de Datos — GYE-CORE

SQL Server 2022 ejecutándose en Docker.

## Docker Compose — DB

Archivo: `BaseDeDatos/gye-core-db/docker-compose.yml`

```yaml
version: '3.9'

services:
  sqlserver:
    image: mcr.microsoft.com/mssql/server:2022-latest
    container_name: gye-sqlserver
    environment:
      ACCEPT_EULA: "Y"
      MSSQL_SA_PASSWORD: "GYECore@2024!"
      MSSQL_PID: "Developer"
    ports:
      - "1433:1433"
    volumes:
      - sqlserver_data:/var/opt/mssql
      - ./scripts:/scripts
    healthcheck:
      test: /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "GYECore@2024!" -Q "SELECT 1" || exit 1
      interval: 10s
      timeout: 5s
      retries: 5
    networks:
      - gye-network

  redis:
    image: redis:7-alpine
    container_name: gye-redis
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
    networks:
      - gye-network

volumes:
  sqlserver_data:
  redis_data:

networks:
  gye-network:
    driver: bridge
```

## Comandos Docker DB

```bash
cd C:/GIT/Municipio/BaseDeDatos/gye-core-db

# Levantar
docker compose up -d

# Ver estado
docker compose ps

# Ver logs SQL Server
docker compose logs sqlserver -f

# Parar
docker compose down

# Limpiar (BORRA datos)
docker compose down -v
```

## Conexión a SQL Server

| Parámetro | Valor            |
|-----------|------------------|
| Server    | localhost,1433   |
| User      | sa               |
| Password  | GYECore@2024!    |
| Database  | GYECore          |

**Connection String:**
```
Server=localhost,1433;Database=GYECore;User Id=sa;Password=GYECore@2024!;TrustServerCertificate=True;
```

## Estructura de Scripts

```
gye-core-db/
├── docker-compose.yml
├── scripts/
│   ├── 00-create-database.sql    # Crear DB y usuario
│   ├── 01-schema.sql             # Tablas y relaciones
│   ├── 02-stored-procs.sql       # Procedimientos almacenados
│   ├── 03-seed-data.sql          # Datos de prueba
│   └── migrations/               # Migraciones EF Core
└── README.md
```

## Ejecutar Scripts Manualmente

```bash
# Conectar al contenedor
docker exec -it gye-sqlserver bash

# Ejecutar script SQL
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "GYECore@2024!" \
  -i /scripts/00-create-database.sql
```

## Tablas Principales

```sql
-- Módulo Recaudación
Contribuyentes (Id, Nombre, RUC, Cedula, Direccion, ...)
Deudas (Id, ContribuyenteId, Periodo, Monto, FechaVencimiento, ...)
Pagos (Id, DeudaId, Monto, FechaPago, MetodoPago, ...)

-- Módulo Convenios
Convenios (Id, ContribuyenteId, FechaInicio, Cuotas, ...)
CuotasConvenio (Id, ConvenioId, NumeroCuota, Monto, FechaVencimiento, ...)
```

## Conexión desde Azure Data Studio / SSMS

1. Server: `localhost,1433`
2. Authentication: SQL Server Authentication
3. User: `sa`
4. Password: `GYECore@2024!`
5. Marcar: "Trust server certificate"
