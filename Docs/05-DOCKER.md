# Docker — GYE-CORE

## Instalación Docker Desktop en Windows

### Requisitos previos
- Windows 11 con WSL 2 habilitado
- Virtualización habilitada en BIOS

### Instalar WSL 2 (si no está instalado)

```powershell
# PowerShell como Administrador
wsl --install
# Reiniciar el equipo después
```

Verificar:
```bash
wsl --version
wsl --list --verbose
```

### Instalar Docker Desktop

1. Descarga: https://www.docker.com/products/docker-desktop/
2. Ejecuta el instalador `Docker Desktop Installer.exe`
3. Marcar: "Use WSL 2 instead of Hyper-V"
4. Finalizar instalación y **reiniciar**
5. Abrir Docker Desktop → esperar icono de ballena verde

Verificar:
```bash
docker --version
docker compose version
docker ps
```

---

## Docker Compose — Base de Datos

```bash
cd C:/GIT/Municipio/BaseDeDatos/gye-core-db

# Levantar (detached)
docker compose up -d

# Ver estado de contenedores
docker compose ps

# Ver logs en tiempo real
docker compose logs -f

# Ver logs solo SQL Server
docker compose logs sqlserver -f

# Parar (conserva datos)
docker compose stop

# Parar y eliminar contenedores (conserva volúmenes)
docker compose down

# Parar, eliminar contenedores Y volúmenes (BORRA DATOS)
docker compose down -v
```

---

## Docker Compose Completo (todos los servicios)

Archivo: `C:/GIT/Municipio/docker-compose.yml`

```yaml
version: '3.9'

services:
  # ─── BASE DE DATOS ───────────────────────────────────────
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

  # ─── BACKEND ─────────────────────────────────────────────
  backend-sys:
    build:
      context: ./Backend/gye-core-backend-sys
      dockerfile: Dockerfile
    container_name: gye-backend-sys
    environment:
      - ASPNETCORE_ENVIRONMENT=Development
      - ConnectionStrings__DefaultConnection=Server=sqlserver,1433;Database=GYECore;User Id=sa;Password=GYECore@2024!;TrustServerCertificate=True;
      - Redis__ConnectionString=redis:6379
    ports:
      - "5001:5001"
    depends_on:
      sqlserver:
        condition: service_healthy
    networks:
      - gye-network

  bff:
    build:
      context: ./Backend/gye-core-bff
      dockerfile: Dockerfile
    container_name: gye-bff
    environment:
      - ASPNETCORE_ENVIRONMENT=Development
      - BackendSys__BaseUrl=http://backend-sys:5001
      - Redis__ConnectionString=redis:6379
    ports:
      - "5002:5002"
    depends_on:
      - backend-sys
    networks:
      - gye-network

volumes:
  sqlserver_data:
  redis_data:

networks:
  gye-network:
    driver: bridge
```

---

## Dockerfile para .NET 10

```dockerfile
# Backend/gye-core-backend-sys/Dockerfile
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS base
WORKDIR /app
EXPOSE 5001

FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src
COPY ["src/GYE.Core.Api/GYE.Core.Api.csproj", "src/GYE.Core.Api/"]
COPY ["src/GYE.Core.Application/GYE.Core.Application.csproj", "src/GYE.Core.Application/"]
COPY ["src/GYE.Core.Domain/GYE.Core.Domain.csproj", "src/GYE.Core.Domain/"]
COPY ["src/GYE.Core.Infrastructure/GYE.Core.Infrastructure.csproj", "src/GYE.Core.Infrastructure/"]
RUN dotnet restore "src/GYE.Core.Api/GYE.Core.Api.csproj"
COPY . .
RUN dotnet build "src/GYE.Core.Api/GYE.Core.Api.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "src/GYE.Core.Api/GYE.Core.Api.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "GYE.Core.Api.dll"]
```

---

## Comandos Docker Útiles

```bash
# Ver todos los contenedores
docker ps -a

# Ver imágenes
docker images

# Ver volúmenes
docker volume ls

# Limpiar todo (cuidado en producción)
docker system prune -a

# Ejecutar comando en contenedor
docker exec -it gye-sqlserver bash

# Ver logs de un contenedor
docker logs gye-sqlserver -f

# Inspeccionar red
docker network ls
docker network inspect gye-network
```

---

## Troubleshooting Docker en Windows

### "Docker daemon not running"
- Abrir Docker Desktop y esperar el icono verde
- Si no inicia: reiniciar el servicio
  ```powershell
  # PowerShell Admin
  Restart-Service com.docker.service
  ```

### "Port already in use"
```bash
# Ver qué usa el puerto
netstat -ano | findstr :1433
# Matar proceso (reemplazar PID)
taskkill /PID 1234 /F
```

### SQL Server tarda en iniciar
- Es normal, esperar ~30 segundos
- Revisar con: `docker compose logs sqlserver -f`
- Buscar: `SQL Server is now ready for client connections`
