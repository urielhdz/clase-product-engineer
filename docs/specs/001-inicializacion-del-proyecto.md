# 001 — Inicialización del proyecto

- **Estado:** Implementada
- **Fecha:** 2026-10-28

## Contexto

Vamos a construir una app web colaborativa en tiempo real para escribir specs, con integración profunda con GitHub. Antes de cualquier funcionalidad necesitamos un proyecto base listo para desarrollar y desplegar.

## Objetivos

- Proyecto Rails en su última versión estable con PostgreSQL y Tailwind.
- Rails y PostgreSQL en contenedores Docker separados, tanto en desarrollo como en producción.
- Deploy con Kamal, con PostgreSQL como accesorio.
- Todos los comandos de desarrollo (incluidos los de agentes) se ejecutan en los contenedores.
- Specs en español.

## Fuera de alcance

- Autenticación, integración con GitHub y edición colaborativa (specs posteriores).
- Elegir el servidor real y el registry de producción.

## Criterios de aceptación

- [x] `bin/docker up` levanta los servicios `web` y `db`, y `GET /up` responde 200.
- [x] `bin/docker exec bin/rails test` pasa.
- [x] `bin/rubocop`, `bin/brakeman` y `bin/bundler-audit` pasan sin advertencias.
- [x] La imagen de producción (`Dockerfile`) se construye correctamente.
- [x] `config/deploy.yml` define PostgreSQL como accesorio y la app se conecta a él por la red de Kamal (`DB_HOST=proyecto_claude-db`).
- [x] `CLAUDE.md` indica a los agentes que ejecuten todo en contenedores y escriban las specs en español.

## Diseño técnico

| Pieza | Decisión |
| --- | --- |
| Ruby / Rails | 4.0.9 / 8.1.4 |
| Base de datos | PostgreSQL 18 (imagen oficial `postgres:18`) |
| CSS | Tailwind v4 vía `tailwindcss-rails` |
| Frontend | Hotwire (Turbo + Stimulus) con importmap |
| Tiempo real / jobs / caché | Solid Cable, Solid Queue y Solid Cache sobre PostgreSQL, sin Redis |
| Desarrollo | `Dockerfile.dev` + `compose.yaml` (servicios `web` y `db`), gemas en un volumen, código montado |
| Producción | `Dockerfile` multi-stage, usuario sin privilegios, jemalloc, Thruster |
| Deploy | Kamal; `accessories.db` con `postgres:18` y volumen persistente |
| Configuración de BD | `config/database.yml` lee `DB_HOST`, `DB_PORT`, `DB_USERNAME`, `DB_PASSWORD` |
| Calidad | RuboCop (rails-omakase), Brakeman, bundler-audit, GitHub Actions CI |

En producción, `bin/docker-entrypoint` ejecuta `db:prepare`, que crea las bases `primary`, `cache`, `queue` y `cable` en el accesorio.

## Preguntas abiertas

- ¿Qué proveedor de servidor y qué registry (GHCR, Docker Hub) usaremos?
- ¿Dominio y SSL (`proxy.ssl` en Kamal)?
- ¿Respaldos automáticos de PostgreSQL?
