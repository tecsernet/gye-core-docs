# GYE-CORE — Laboratorio Microfrontend Municipal

Sistema de gestión municipal basado en **Microfrontend** con arquitectura moderna:
- **Frontend**: NX Workspace + Angular 21 (Module Federation)
- **Backend**: .NET Core 10 C# (BackendSys + BFF)
- **Base de Datos**: SQL Server en Docker
- **Infraestructura**: Docker + Google Cloud

## Estructura del Repositorio

```
C:/GIT/Municipio/
├── BaseDeDatos/
│   └── gye-core-db/              # Scripts SQL, migraciones, seeds
├── Backend/
│   ├── gye-core-backend-sys/     # API principal .NET 10
│   └── gye-core-bff/             # Backend for Frontend .NET 10
├── Frontend/
│   ├── gye-core-shell/           # Host shell (portal principal)
│   ├── gye-core-recaudacion/     # Microfrontend: Recaudación
│   └── gye-core-convenio/        # Microfrontend: Convenios
└── Docs/
    ├── 00-SETUP-WINDOWS.md       # Instalación en Windows
    ├── 01-ARQUITECTURA.md        # Arquitectura del sistema
    ├── 02-BASE-DATOS.md          # Base de datos
    ├── 03-BACKEND.md             # Backend APIs
    ├── 04-FRONTEND.md            # Frontend Microfrontends
    ├── 05-DOCKER.md              # Docker y contenedores
    ├── 06-GCLOUD.md              # Google Cloud deployment
    └── 07-FLUJO-DESARROLLO.md    # Guía de desarrollo día a día
```

## Repositorios GitHub

| Componente       | Repositorio                                          |
|------------------|------------------------------------------------------|
| BaseDeDatos      | https://github.com/stdpacheco/gye-core-db            |
| BackendSys       | https://github.com/stdpacheco/gye-core-backend-sys   |
| BackendBff       | https://github.com/stdpacheco/gye-core-bff           |
| portal-shell     | https://github.com/stdpacheco/gye-core-shell         |
| sys-recaudacion  | https://github.com/stdpacheco/gye-core-recaudacion   |
| sys-convenio     | https://github.com/stdpacheco/gye-core-convenio      |

## Documentación por plataforma

| Plataforma | Guía de instalación completa        |
|------------|-------------------------------------|
| Windows    | `Docs/00-SETUP-WINDOWS.md`          |
| macOS      | `Docs/SETUP-MAC.md`                 |
| Ambos      | `Docs/INICIO-RAPIDO.md` ← empezar aquí |

## Levantamiento Rápido (resumen)

```bash
# 1. Clonar todos los repos (ver INICIO-RAPIDO.md sección 2)
cd BaseDeDatos && git clone https://github.com/stdpacheco/gye-core-db
# ... ver doc completo

# 2. Levantar DB
cd BaseDeDatos/gye-core-db/SQL && docker compose up -d

# 3. Levantar BackendSys (puerto 5001)
cd Backend/gye-core-backend-sys && dotnet run --project src/GYE.Api --launch-profile http

# 4. Levantar BFF (puerto 5000)
cd Backend/gye-core-bff && dotnet run --project src/GYE.Bff --launch-profile http

# 5. MFE Recaudacion (puerto 4201)
cd Frontend/gye-core-recaudacion && npx nx serve recaudacion

# 6. MFE Convenio (puerto 4202)
cd Frontend/gye-core-convenio && npx nx serve convenio

# 7. Shell host (puerto 4200) — levantar ÚLTIMO
cd Frontend/gye-core-shell && npx nx serve shell
```

Ver **`Docs/INICIO-RAPIDO.md`** para la guía completa con Windows y macOS.

## Stack Tecnológico

| Capa           | Tecnología              | Versión  |
|----------------|-------------------------|----------|
| Frontend Host  | Angular + NX            | 21 / 21  |
| Microfrontends | Angular Module Fed.     | 21       |
| BFF            | .NET Core C#            | 10       |
| BackendSys     | .NET Core C#            | 10       |
| Base de datos  | SQL Server              | 2022     |
| Cache          | Redis                   | 7        |
| Contenedores   | Docker Desktop          | latest   |
| Cloud          | Google Cloud Platform   | -        |
