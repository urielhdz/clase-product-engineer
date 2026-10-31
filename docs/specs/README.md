# Specs

Cada funcionalidad se describe en un documento en español antes de implementarla.

## Convenciones

- Un archivo por funcionalidad: `NNN-nombre-en-kebab-case.md` (ej. `002-autenticacion-con-github.md`).
- Escrito en español.
- Usa la plantilla de abajo.

## Plantilla

```markdown
# NNN — Título de la funcionalidad

- **Estado:** Borrador | En revisión | Aprobada | Implementada
- **Fecha:** AAAA-MM-DD

## Contexto
¿Qué problema resolvemos y para quién?

## Objetivos
- ...

## Fuera de alcance
- ...

## Historias de usuario
- Como <rol>, quiero <acción> para <beneficio>.

## Criterios de aceptación
- [ ] Dado ..., cuando ..., entonces ...

## Diseño técnico
Modelos, rutas, jobs, integraciones (GitHub, Action Cable, etc.).

## Preguntas abiertas
- ...
```
