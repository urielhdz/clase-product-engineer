# Spec Facilito

App web colaborativa en tiempo real para escribir specs, con integración profunda con GitHub.

## Stack

- Ruby 4.0.9 / Rails 8.1.4 (Hotwire: Turbo + Stimulus, importmap)
- PostgreSQL 18
- Tailwind CSS v4 (`tailwindcss-rails`)
- Solid Queue / Solid Cache / Solid Cable (sin Redis)
- Docker (Rails y PostgreSQL en contenedores separados)
- Kamal para deploy (PostgreSQL como accesorio)

## Reglas para agentes

- **Todos los comandos se ejecutan dentro de los contenedores.** No uses Ruby, Bundler ni Rails del host.
  - Levantar el entorno: `bin/docker up` (o `bin/docker up -d`)
  - Ejecutar cualquier comando: `bin/docker exec <comando>`
  - Atajo para Rails: `bin/docker rails <args>`
  - Ejemplos:
    - `bin/docker exec bin/rails test`
    - `bin/docker exec bin/rubocop`
    - `bin/docker exec bin/brakeman --no-pager`
    - `bin/docker exec bundle add <gema>` (luego `bin/docker build web` si cambió el Gemfile)
    - `bin/docker rails generate model Spec title:string`
    - `bin/docker rails db:migrate`
- Si el puerto 3000 está ocupado: `WEB_PORT=3001 bin/docker up`.
- **Todas las specs (documentos de especificación) se escriben en español**, en `docs/specs/`, siguiendo `docs/specs/README.md`.
- **Las tareas basadas en spec requieren confirmación antes de implementarse.** Escribe (o actualiza) la spec con estado «En revisión», preséntala y **detente hasta que el usuario la confirme explícitamente**. Solo entonces cámbiala a «Aprobada» e implementa. No escribas código, migraciones ni instales gemas antes de esa confirmación.
  - Excepción: si la tarea indica explícitamente que no requiere spec, impleméntala directamente sin validación de spec.
- Para vistas, estilos o cualquier texto visible al usuario, sigue la skill `brand-guidelines` (`.claude/skills/brand-guidelines/SKILL.md`). Los tokens de diseño viven en `app/assets/tailwind/application.css`.
- Los nombres de los tests (`test "..."`) también se escriben en español. El código (clases, métodos, variables) va en inglés.
- Antes de dar algo por terminado, corre la skill `verificacion` (`.claude/skills/verificacion/SKILL.md`): Brakeman, bundler-audit, importmap audit, RuboCop y tests deben pasar, igual que en el CI.

## Estructura relevante

- `Dockerfile`: imagen de producción (la usa Kamal).
- `Dockerfile.dev` + `compose.yaml`: entorno de desarrollo (servicios `web` y `db`).
- `config/deploy.yml` + `.kamal/secrets`: configuración de Kamal.
- `config/database.yml`: lee `DB_HOST`, `DB_PORT`, `DB_USERNAME`, `DB_PASSWORD` del entorno.
