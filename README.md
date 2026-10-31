# Spec Facilito

App web colaborativa en tiempo real para escribir specs, con integración profunda con GitHub.

## Requisitos

- Docker (con Docker Compose)

No necesitas Ruby ni PostgreSQL instalados en tu máquina.

## Desarrollo

```bash
bin/docker build          # construye la imagen de desarrollo
bin/docker up             # levanta Rails (web) y PostgreSQL (db)
```

La app queda en http://localhost:3000. Si el puerto está ocupado: `WEB_PORT=3001 bin/docker up`.

Comandos dentro del contenedor:

```bash
bin/docker exec bin/rails test
bin/docker exec bin/rubocop
bin/docker rails console
bin/docker rails db:migrate
```

## Deploy (Kamal)

1. Edita `config/deploy.yml`: IP del servidor (`servers.web` y `accessories.db.host`), registry e `image`.
2. Exporta los secretos que lee `.kamal/secrets`:
   ```bash
   export KAMAL_REGISTRY_PASSWORD=...
   export POSTGRES_PASSWORD=...
   ```
3. Primer deploy (también arranca el accesorio de PostgreSQL):
   ```bash
   bin/docker exec bin/kamal setup
   ```
4. Siguientes deploys: `bin/docker exec bin/kamal deploy`.

> Para correr Kamal desde el contenedor necesitas que tu agente SSH y el socket de Docker estén disponibles en él; si no, ejecútalo desde el host con `gem install kamal`.

## Specs

Las especificaciones del producto están en español en [`docs/specs/`](docs/specs/).
