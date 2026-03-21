# Google Cloud — GYE-CORE

Despliegue del sistema en Google Cloud Platform (GCP).

---

## Instalación gcloud CLI en Windows

```powershell
# PowerShell como Administrador
winget install Google.CloudSDK
```

O descarga el instalador: https://cloud.google.com/sdk/docs/install-sdk#windows

Verificar:
```bash
gcloud --version
```

## Configuración Inicial

```bash
# Inicializar y autenticar
gcloud init

# Login con browser
gcloud auth login

# Configurar proyecto
gcloud config set project [TU-PROJECT-ID]

# Ver configuración actual
gcloud config list
```

---

## Arquitectura Cloud

```
Internet
    │
    ▼
┌─────────────────────────────────────────────┐
│  Cloud Load Balancer + Cloud Armor          │
└─────────────────────────────────────────────┘
    │
    ▼
┌─────────────────────────────────────────────┐
│  Cloud Run (Frontend estático via CDN)       │
│  Cloud Storage + Cloud CDN                   │
│  portal-shell, sys-recaudacion, sys-convenio │
└─────────────────────────────────────────────┘
    │
    ▼
┌─────────────────────────────────────────────┐
│  Cloud Run — BFF                            │
│  gye-core-bff (contenedor)                  │
└─────────────────────────────────────────────┘
    │
    ▼
┌─────────────────────────────────────────────┐
│  Cloud Run — BackendSys                     │
│  gye-core-backend-sys (contenedor)           │
└─────────────────────────────────────────────┘
    │              │
    ▼              ▼
┌──────────┐  ┌──────────────────────────────┐
│ Cloud    │  │  Cloud SQL (SQL Server)       │
│ Memstore │  │  o Cloud SQL for PostgreSQL   │
│ (Redis)  │  └──────────────────────────────┘
└──────────┘
```

---

## Artifact Registry — Docker Images

```bash
# Crear repositorio
gcloud artifacts repositories create gye-core \
  --repository-format=docker \
  --location=us-central1

# Autenticar Docker con GCloud
gcloud auth configure-docker us-central1-docker.pkg.dev

# Build y push imagen BackendSys
docker build -t us-central1-docker.pkg.dev/[PROJECT]/gye-core/backend-sys:latest \
  Backend/gye-core-backend-sys/

docker push us-central1-docker.pkg.dev/[PROJECT]/gye-core/backend-sys:latest

# Build y push imagen BFF
docker build -t us-central1-docker.pkg.dev/[PROJECT]/gye-core/bff:latest \
  Backend/gye-core-bff/

docker push us-central1-docker.pkg.dev/[PROJECT]/gye-core/bff:latest
```

---

## Cloud Run — Deploy Backend

```bash
# Deploy BackendSys
gcloud run deploy gye-backend-sys \
  --image=us-central1-docker.pkg.dev/[PROJECT]/gye-core/backend-sys:latest \
  --region=us-central1 \
  --platform=managed \
  --allow-unauthenticated \
  --port=5001 \
  --set-env-vars="ASPNETCORE_ENVIRONMENT=Production"

# Deploy BFF
gcloud run deploy gye-bff \
  --image=us-central1-docker.pkg.dev/[PROJECT]/gye-core/bff:latest \
  --region=us-central1 \
  --platform=managed \
  --allow-unauthenticated \
  --port=5002 \
  --set-env-vars="ASPNETCORE_ENVIRONMENT=Production,BackendSys__BaseUrl=https://gye-backend-sys-xxx-uc.a.run.app"
```

---

## Cloud Storage — Frontend Estático

```bash
# Crear bucket
gsutil mb -l us-central1 gs://gye-core-frontend

# Build del shell para producción
cd Frontend/gye-core-shell
npx nx build portal-shell --configuration=production

# Build microfrontends
cd Frontend/gye-core-recaudacion
npx nx build sys-recaudacion --configuration=production

cd Frontend/gye-core-convenio
npx nx build sys-convenio --configuration=production

# Upload al bucket
gsutil -m rsync -r Frontend/gye-core-shell/dist/apps/portal-shell gs://gye-core-frontend/shell
gsutil -m rsync -r Frontend/gye-core-recaudacion/dist/apps/sys-recaudacion gs://gye-core-frontend/recaudacion
gsutil -m rsync -r Frontend/gye-core-convenio/dist/apps/sys-convenio gs://gye-core-frontend/convenio

# Hacer públicos
gsutil iam ch allUsers:objectViewer gs://gye-core-frontend
```

---

## CI/CD con Cloud Build

Archivo: `cloudbuild.yaml`

```yaml
steps:
  # Build y push backend
  - name: 'gcr.io/cloud-builders/docker'
    args: ['build', '-t', 'us-central1-docker.pkg.dev/$PROJECT_ID/gye-core/backend-sys:$COMMIT_SHA', 'Backend/gye-core-backend-sys/']

  - name: 'gcr.io/cloud-builders/docker'
    args: ['push', 'us-central1-docker.pkg.dev/$PROJECT_ID/gye-core/backend-sys:$COMMIT_SHA']

  # Deploy a Cloud Run
  - name: 'gcr.io/cloud-builders/gcloud'
    args:
      - 'run'
      - 'deploy'
      - 'gye-backend-sys'
      - '--image=us-central1-docker.pkg.dev/$PROJECT_ID/gye-core/backend-sys:$COMMIT_SHA'
      - '--region=us-central1'
      - '--platform=managed'

options:
  logging: CLOUD_LOGGING_ONLY
```
