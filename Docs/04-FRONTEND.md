# Frontend — GYE-CORE (NX + Angular 21)

Arquitectura Microfrontend con **Module Federation** (Webpack 5).

---

## Ports por Aplicación

| App               | Puerto | Rol     |
|-------------------|--------|---------|
| portal-shell      | 4200   | Host    |
| sys-recaudacion   | 4201   | Remote  |
| sys-convenio      | 4202   | Remote  |

---

## portal-shell — Host

```bash
cd C:/GIT/Municipio/Frontend/gye-core-shell

# Instalar dependencias
npm install

# Servir en desarrollo
npx nx serve portal-shell
# o:
npx nx run portal-shell:serve

# Build producción
npx nx build portal-shell --configuration=production

# Ver todos los proyectos del workspace
npx nx show projects
```

### Estructura

```
gye-core-shell/
├── apps/
│   └── portal-shell/
│       ├── src/
│       │   ├── app/
│       │   │   ├── app.component.ts
│       │   │   ├── app.routes.ts          # Lazy loading remotos
│       │   │   └── layout/               # Shell UI
│       │   └── main.ts
│       ├── webpack.config.js              # Module Federation Host
│       └── project.json
├── libs/
│   ├── shared/ui/                         # Componentes compartidos
│   ├── shared/data-access/               # Auth service, HTTP
│   └── shared/utils/
├── nx.json
└── package.json
```

### app.routes.ts — Lazy Loading MFE

```typescript
import { Routes } from '@angular/router';
import { loadRemoteModule } from '@nx/angular/mf';

export const appRoutes: Routes = [
  {
    path: '',
    redirectTo: 'recaudacion',
    pathMatch: 'full'
  },
  {
    path: 'recaudacion',
    loadChildren: () =>
      loadRemoteModule('sys-recaudacion', './Module')
        .then(m => m.RemoteEntryModule),
  },
  {
    path: 'convenio',
    loadChildren: () =>
      loadRemoteModule('sys-convenio', './Module')
        .then(m => m.RemoteEntryModule),
  },
];
```

### webpack.config.js — Host

```javascript
const { withModuleFederationPlugin } = require('@nx/angular/module-federation');

module.exports = withModuleFederationPlugin({
  remotes: [
    ['sys-recaudacion', 'http://localhost:4201/remoteEntry.js'],
    ['sys-convenio',    'http://localhost:4202/remoteEntry.js'],
  ],
});
```

---

## sys-recaudacion — Microfrontend

```bash
cd C:/GIT/Municipio/Frontend/gye-core-recaudacion

npm install
npx nx serve sys-recaudacion
```

### Estructura

```
gye-core-recaudacion/
├── apps/
│   └── sys-recaudacion/
│       ├── src/
│       │   ├── app/
│       │   │   └── remote-entry/
│       │   │       ├── entry.module.ts    # Expuesto vía MF
│       │   │       └── entry.component.ts
│       │   └── main.ts
│       └── webpack.config.js
├── libs/
│   └── feature-recaudacion/
│       ├── consulta-deuda/
│       ├── proceso-pago/
│       └── historial/
└── nx.json
```

### webpack.config.js — Remote

```javascript
const { withModuleFederationPlugin } = require('@nx/angular/module-federation');

module.exports = withModuleFederationPlugin({
  name: 'sys-recaudacion',
  exposes: {
    './Module': 'apps/sys-recaudacion/src/app/remote-entry/entry.module.ts',
  },
});
```

---

## sys-convenio — Microfrontend

```bash
cd C:/GIT/Municipio/Frontend/gye-core-convenio

npm install
npx nx serve sys-convenio
```

---

## Comandos NX Útiles

```bash
# Ver el grafo de dependencias
npx nx graph

# Generar componente
npx nx g @nx/angular:component nombre --project=portal-shell

# Generar librería compartida
npx nx g @nx/angular:library nombre --directory=shared

# Generar remote microfrontend (si creas uno nuevo)
npx nx g @nx/angular:remote nombre --host=portal-shell

# Ejecutar tests
npx nx test portal-shell
npx nx test sys-recaudacion

# Lint
npx nx lint portal-shell

# Build todos
npx nx run-many --target=build --all
```

---

## Variables de Entorno

```typescript
// environment.ts (desarrollo)
export const environment = {
  production: false,
  bffUrl: 'http://localhost:5002',
  apiUrl: 'http://localhost:5001',
};

// environment.prod.ts (producción)
export const environment = {
  production: true,
  bffUrl: 'https://api-bff.gye-municipio.gob.ec',
  apiUrl: 'https://api.gye-municipio.gob.ec',
};
```

---

## Crear Nuevo Workspace NX desde Cero

Si necesitas recrear el workspace shell:

```bash
cd C:/GIT/Municipio/Frontend

# Crear workspace NX con Angular
npx create-nx-workspace@latest gye-core-shell \
  --preset=angular-monorepo \
  --appName=portal-shell \
  --style=scss \
  --nxCloud=skip

cd gye-core-shell

# Agregar Module Federation al host
npx nx g @nx/angular:setup-mf portal-shell --mfType=host

# Crear remote
npx create-nx-workspace@latest gye-core-recaudacion \
  --preset=angular-monorepo \
  --appName=sys-recaudacion \
  --style=scss \
  --nxCloud=skip

cd gye-core-recaudacion
npx nx g @nx/angular:setup-mf sys-recaudacion --mfType=remote --port=4201
```
