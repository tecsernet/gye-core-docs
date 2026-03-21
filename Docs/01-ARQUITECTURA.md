# Arquitectura del Sistema GYE-CORE

## Visión General

```
┌─────────────────────────────────────────────────────────────────┐
│                    BROWSER (puerto 4200)                        │
│                                                                 │
│   ┌─────────────────────────────────────────────────────────┐   │
│   │              portal-shell (Host NX/Angular 21)          │   │
│   │                    localhost:4200                        │   │
│   │                                                         │   │
│   │   ┌──────────────────┐   ┌──────────────────────────┐   │   │
│   │   │  sys-recaudacion │   │     sys-convenio          │   │   │
│   │   │  (Remote MFE)    │   │     (Remote MFE)          │   │   │
│   │   │  localhost:4201  │   │     localhost:4202         │   │   │
│   │   └──────────────────┘   └──────────────────────────┘   │   │
│   └─────────────────────────────────────────────────────────┘   │
└───────────────────────────────┬─────────────────────────────────┘
                                │ HTTP / REST
                                ▼
┌───────────────────────────────────────────────────────────────┐
│                  BFF — gye-core-bff                           │
│               .NET 10 C# | localhost:5002                     │
│          (Swagger: localhost:5002/swagger)                     │
│                                                               │
│   • Agrega llamadas a BackendSys                              │
│   • Transforma datos para el frontend                         │
│   • Maneja autenticación/tokens                               │
│   • Rate limiting y caché                                     │
└───────────────────────────────┬───────────────────────────────┘
                                │ HTTP / REST (interno)
                                ▼
┌───────────────────────────────────────────────────────────────┐
│              BackendSys — gye-core-backend-sys                │
│               .NET 10 C# | localhost:5001                     │
│          (Swagger: localhost:5001/swagger)                     │
│                                                               │
│   • Lógica de negocio principal                               │
│   • CQRS + MediatR                                            │
│   • Repository Pattern                                        │
│   • Entity Framework Core 10                                  │
└──────────────┬─────────────────────────────┬─────────────────┘
               │ SQL                         │ Cache
               ▼                             ▼
┌──────────────────────────┐   ┌─────────────────────────────┐
│  SQL Server 2022         │   │  Redis 7                    │
│  (Docker) localhost:1433 │   │  (Docker) localhost:6379    │
└──────────────────────────┘   └─────────────────────────────┘
```

## Patrón Microfrontend (Module Federation)

```
portal-shell (Host)
├── Carga remota sys-recaudacion desde localhost:4201
├── Carga remota sys-convenio desde localhost:4202
└── Gestiona:
    ├── Routing principal
    ├── Layout/Shell UI (nav, sidebar, header)
    ├── Auth state global
    └── Shared libraries (design system, utils)
```

### webpack.config.js — Shell (Host)

```javascript
// portal-shell/webpack.config.js
module.exports = withModuleFederationPlugin({
  remotes: {
    'sys-recaudacion': 'http://localhost:4201/remoteEntry.js',
    'sys-convenio':    'http://localhost:4202/remoteEntry.js',
  },
  shared: {
    '@angular/core': { singleton: true, strictVersion: true },
    '@angular/router': { singleton: true, strictVersion: true },
  }
});
```

### webpack.config.js — Microfrontend (Remote)

```javascript
// sys-recaudacion/webpack.config.js
module.exports = withModuleFederationPlugin({
  name: 'sys-recaudacion',
  exposes: {
    './Module': './src/app/remote-entry/entry.module.ts',
  },
});
```

## Patrón BFF (Backend for Frontend)

El BFF actúa como gateway entre el frontend y los servicios backend:

```
Frontend ──► BFF ──► BackendSys ──► DB
              │
              └──► Servicios externos (futuro)
```

**Responsabilidades del BFF:**
- Agregar/combinar múltiples llamadas a BackendSys en una sola respuesta
- Transformar datos al formato exacto que necesita el frontend
- Manejar tokens JWT y renovación
- Implementar políticas de retry y circuit breaker
- Caching de respuestas frecuentes

## Estructura de Proyectos NX

```
gye-core-shell/
├── apps/
│   └── portal-shell/          # App Angular (Host)
├── libs/
│   ├── ui/                    # Componentes compartidos
│   ├── data-access/           # Servicios/state management
│   └── utils/                 # Utilidades comunes
└── nx.json

gye-core-recaudacion/
├── apps/
│   └── sys-recaudacion/       # App Angular (Remote MFE)
├── libs/
│   └── feature-recaudacion/   # Features del módulo
└── nx.json

gye-core-convenio/
├── apps/
│   └── sys-convenio/          # App Angular (Remote MFE)
├── libs/
│   └── feature-convenio/      # Features del módulo
└── nx.json
```

## Estructura Backend .NET 10

```
gye-core-backend-sys/
├── src/
│   ├── GYE.Core.Api/          # Proyecto Web API
│   ├── GYE.Core.Application/  # Casos de uso (CQRS/MediatR)
│   ├── GYE.Core.Domain/       # Entidades y reglas de negocio
│   └── GYE.Core.Infrastructure/ # EF Core, repositorios, DB
└── tests/
    ├── GYE.Core.UnitTests/
    └── GYE.Core.IntegrationTests/

gye-core-bff/
├── src/
│   ├── GYE.Bff.Api/           # Proyecto Web API
│   ├── GYE.Bff.Application/   # Servicios de agregación
│   └── GYE.Bff.Infrastructure/ # HttpClients a BackendSys
└── tests/
```

## Flujo de Datos — Ejemplo: Consultar Deuda

```
1. Usuario en sys-recaudacion llama BFF
   GET http://localhost:5002/api/recaudacion/deuda/{contribuyente}

2. BFF llama a BackendSys
   GET http://localhost:5001/api/contribuyentes/{id}
   GET http://localhost:5001/api/deudas/{contribuyente}

3. BackendSys consulta DB
   SELECT * FROM Contribuyentes WHERE Id = @id
   SELECT * FROM Deudas WHERE ContribuyenteId = @id

4. BackendSys responde a BFF (datos raw)

5. BFF agrega y transforma → responde al frontend
   { contribuyente: {...}, deudas: [...], totalDeuda: 0.00 }
```
