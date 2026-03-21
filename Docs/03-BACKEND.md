# Backend — GYE-CORE (.NET 10 C#)

Dos proyectos backend:
- **BackendSys**: API principal con lógica de negocio
- **BFF**: Backend for Frontend (agrega y transforma datos)

---

## BackendSys — gye-core-backend-sys

### Levantar

```bash
cd C:/GIT/Municipio/Backend/gye-core-backend-sys

# Restaurar paquetes
dotnet restore

# Levantar en modo desarrollo
dotnet run --project src/GYE.Core.Api --launch-profile Development

# Con hot reload
dotnet watch --project src/GYE.Core.Api run
```

**URLs:**
- API: http://localhost:5001
- Swagger: http://localhost:5001/swagger

### appsettings.Development.json

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=localhost,1433;Database=GYECore;User Id=sa;Password=GYECore@2024!;TrustServerCertificate=True;"
  },
  "Redis": {
    "ConnectionString": "localhost:6379"
  },
  "Jwt": {
    "Key": "GYE-CORE-SECRET-KEY-DEVELOPMENT-2024",
    "Issuer": "GYECore",
    "Audience": "GYECoreClient",
    "ExpirationMinutes": 60
  },
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.EntityFrameworkCore": "Warning"
    }
  }
}
```

### Estructura del Proyecto

```
gye-core-backend-sys/
├── src/
│   ├── GYE.Core.Api/
│   │   ├── Controllers/
│   │   │   ├── ContribuyentesController.cs
│   │   │   ├── DeudasController.cs
│   │   │   └── PagosController.cs
│   │   ├── Program.cs
│   │   └── appsettings.json
│   ├── GYE.Core.Application/
│   │   ├── Features/
│   │   │   ├── Contribuyentes/
│   │   │   │   ├── Queries/GetContribuyenteQuery.cs
│   │   │   │   └── Commands/CreateContribuyenteCommand.cs
│   │   │   └── Deudas/
│   │   └── Interfaces/
│   ├── GYE.Core.Domain/
│   │   ├── Entities/
│   │   │   ├── Contribuyente.cs
│   │   │   ├── Deuda.cs
│   │   │   └── Pago.cs
│   │   └── Interfaces/
│   └── GYE.Core.Infrastructure/
│       ├── Data/
│       │   └── GYECoreDbContext.cs
│       ├── Repositories/
│       └── Migrations/
└── tests/
```

### Paquetes NuGet Principales

```xml
<PackageReference Include="MediatR" Version="12.*" />
<PackageReference Include="Microsoft.EntityFrameworkCore.SqlServer" Version="10.*" />
<PackageReference Include="Microsoft.EntityFrameworkCore.Tools" Version="10.*" />
<PackageReference Include="StackExchange.Redis" Version="2.*" />
<PackageReference Include="Microsoft.AspNetCore.Authentication.JwtBearer" Version="10.*" />
<PackageReference Include="Swashbuckle.AspNetCore" Version="7.*" />
<PackageReference Include="FluentValidation.AspNetCore" Version="11.*" />
```

### Migraciones EF Core

```bash
cd C:/GIT/Municipio/Backend/gye-core-backend-sys

# Crear migración
dotnet ef migrations add InitialCreate \
  --project src/GYE.Core.Infrastructure \
  --startup-project src/GYE.Core.Api

# Aplicar migraciones
dotnet ef database update \
  --project src/GYE.Core.Infrastructure \
  --startup-project src/GYE.Core.Api
```

---

## BFF — gye-core-bff

### Levantar

```bash
cd C:/GIT/Municipio/Backend/gye-core-bff

dotnet restore
dotnet run --project src/GYE.Bff.Api --launch-profile Development
# o con hot reload:
dotnet watch --project src/GYE.Bff.Api run
```

**URLs:**
- BFF: http://localhost:5002
- Swagger: http://localhost:5002/swagger

### appsettings.Development.json

```json
{
  "BackendSys": {
    "BaseUrl": "http://localhost:5001"
  },
  "Redis": {
    "ConnectionString": "localhost:6379"
  },
  "Cors": {
    "AllowedOrigins": [
      "http://localhost:4200",
      "http://localhost:4201",
      "http://localhost:4202"
    ]
  },
  "Jwt": {
    "Key": "GYE-CORE-SECRET-KEY-DEVELOPMENT-2024",
    "Issuer": "GYECore",
    "Audience": "GYECoreClient"
  }
}
```

### Estructura del Proyecto

```
gye-core-bff/
├── src/
│   ├── GYE.Bff.Api/
│   │   ├── Controllers/
│   │   │   ├── RecaudacionController.cs
│   │   │   └── ConvenioController.cs
│   │   ├── Program.cs
│   │   └── appsettings.json
│   ├── GYE.Bff.Application/
│   │   └── Services/
│   │       ├── RecaudacionService.cs
│   │       └── ConvenioService.cs
│   └── GYE.Bff.Infrastructure/
│       └── HttpClients/
│           └── BackendSysClient.cs
└── tests/
```

---

## Endpoints Principales

### BackendSys (localhost:5001)

```
GET    /api/contribuyentes              # Listar
GET    /api/contribuyentes/{id}         # Obtener por ID
POST   /api/contribuyentes              # Crear
PUT    /api/contribuyentes/{id}         # Actualizar
GET    /api/deudas/{contribuyenteId}    # Deudas por contribuyente
POST   /api/pagos                       # Registrar pago
```

### BFF (localhost:5002)

```
GET    /api/recaudacion/deuda/{ruc}     # Resumen de deuda
POST   /api/recaudacion/pagar           # Proceso de pago
GET    /api/convenio/opciones/{ruc}     # Opciones de convenio
POST   /api/convenio/crear              # Crear convenio
POST   /api/auth/login                  # Login
POST   /api/auth/refresh                # Refresh token
```
