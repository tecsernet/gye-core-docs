# Backend — GYE-CORE (.NET 10 C#)

Dos proyectos backend:
- **BackendSys**: API principal con lógica de negocio (Clean Architecture)
- **BFF**: Backend for Frontend (agrega y transforma datos para el frontend)

---

## BackendSys — gye-core-backend-sys

### Levantar

```bash
cd C:/GIT/Municipio/Backend/gye-core-backend-sys

# Restaurar paquetes
dotnet restore

# Levantar en modo desarrollo
dotnet run --project src/GYE.Api

# Con hot reload
dotnet watch --project src/GYE.Api run
```

**URLs:**
- API: http://localhost:5001
- Swagger: http://localhost:5001/swagger
- Health: http://localhost:5001/health

### appsettings.Development.json

> Este archivo está en `.gitignore`. Copiarlo desde el ejemplo:
> ```bash
> copy src\GYE.Api\appsettings.Development.json.example src\GYE.Api\appsettings.Development.json
> ```

```json
{
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning",
      "Microsoft.EntityFrameworkCore.Database.Command": "Information"
    }
  },
  "ConnectionStrings": {
    "DefaultConnection": "Host=localhost;Port=5432;Database=gye_core;Username=postgres;Password=postgres123"
  }
}
```

### Estructura del Proyecto

```
gye-core-backend-sys/
├── src/
│   ├── GYE.Api/                    ← Capa de presentación
│   │   ├── Controllers/
│   │   ├── Program.cs
│   │   ├── appsettings.json
│   │   ├── appsettings.Development.json.example
│   │   └── appsettings.Certification.json
│   ├── GYE.Application/            ← Lógica de aplicación
│   ├── GYE.Domain/                 ← Entidades y abstracciones
│   └── GYE.Infrastructure/         ← EF Core, repositorios, migraciones
│       ├── DependencyInjection.cs
│       ├── Migrations/
│       └── Persistence/
└── BackendSys.sln
```

### Paquetes NuGet Principales

```xml
<PackageReference Include="Microsoft.EntityFrameworkCore" Version="10.0.0" />
<PackageReference Include="Npgsql.EntityFrameworkCore.PostgreSQL" Version="10.0.0" />
<PackageReference Include="Microsoft.EntityFrameworkCore.Design" Version="10.0.0" />
```

### Migraciones EF Core

```bash
cd C:/GIT/Municipio/Backend/gye-core-backend-sys

# Crear migración
dotnet ef migrations add NombreCambio \
  --project src/GYE.Infrastructure \
  --startup-project src/GYE.Api

# Aplicar manualmente
dotnet ef database update \
  --project src/GYE.Infrastructure \
  --startup-project src/GYE.Api

# Revertir última migración
dotnet ef migrations remove \
  --project src/GYE.Infrastructure \
  --startup-project src/GYE.Api
```

> **IMPORTANTE:** `db.Database.Migrate()` en Program.cs aplica migraciones automáticamente al arrancar.
> Nunca borra data — solo aplica cambios pendientes.

---

## BFF — gye-core-bff

### Levantar

```bash
cd C:/GIT/Municipio/Backend/gye-core-bff

dotnet restore
dotnet run --project src/GYE.Bff

# Con hot reload
dotnet watch --project src/GYE.Bff run
```

**URLs:**
- BFF: http://localhost:5002
- Swagger: http://localhost:5002/swagger

### appsettings.Development.json

```json
{
  "BackendSys": {
    "BaseUrl": "http://localhost:5001"
  }
}
```

### Estructura del Proyecto

```
gye-core-bff/
├── src/
│   └── GYE.Bff/
│       ├── Program.cs
│       └── appsettings.json
└── BackendBff.sln
```

---

## Endpoints Principales

### BackendSys (localhost:5001)

```
GET    /health                           # Health check
GET    /api/contribuyentes               # Listar contribuyentes
GET    /api/contribuyentes/{id}          # Obtener por ID
POST   /api/contribuyentes               # Crear
GET    /api/predios                      # Listar predios
GET    /api/predios/{id}                 # Obtener por ID
```

### BFF (localhost:5002)

```
GET    /health                           # Health check
```
