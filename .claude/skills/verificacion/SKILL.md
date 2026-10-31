---
name: verificacion
description: Corre dentro de los contenedores las mismas revisiones que el CI (Brakeman, bundler-audit, importmap audit, RuboCop y tests). Úsala antes de dar una tarea por terminada, antes de hacer commit o abrir un pull request, o cuando el usuario pida verificar, validar o «correr el CI» localmente.
---

# Verificación

Reproduce localmente el workflow `.github/workflows/ci.yml`. Todo se ejecuta dentro de los contenedores con `bin/docker exec`; nunca uses Ruby, Bundler ni Rails del host.

## Comandos

Córrelos en este orden, uno por uno, y anota el resultado de cada uno. No te detengas en el primer fallo: corre todos para reportar el panorama completo.

```sh
bin/docker exec bin/brakeman --quiet --no-pager --exit-on-warn --exit-on-error
bin/docker exec bin/bundler-audit check --update
bin/docker exec bin/importmap audit
bin/docker exec bin/rubocop
bin/docker exec bin/rails test
```

- `bin/docker exec` usa `docker compose run --rm web`, que levanta `db` si hace falta. Si falla porque Docker no está corriendo, avisa al usuario en lugar de intentar otra vía.
- Si los tests fallan por esquema desactualizado, corre `bin/docker rails db:test:prepare` y vuelve a intentar.
- `bin/bundler-audit check --update` y `bin/importmap audit` necesitan red. Si fallan por conexión (no por vulnerabilidades), repórtalo como «no verificado», no como aprobado.

## Si algo falla

- **RuboCop:** puedes corregir con `bin/docker exec bin/rubocop -a` solo si los cambios son del trabajo en curso. Vuelve a correr RuboCop después.
- **Tests, Brakeman, auditorías:** no silencies advertencias, no agregues entradas a `config/brakeman.ignore` ni a `.bundler-audit.yml`, y no saltes tests sin que el usuario lo pida. Investiga la causa y corrígela, o repórtala.
- Tras cualquier corrección, vuelve a correr la revisión afectada (y `bin/rails test` si tocaste código).

## Reporte

Termina con una tabla breve:

| Revisión | Resultado |
| --- | --- |
| Brakeman | ✅ / ❌ (resumen) |
| bundler-audit | … |
| importmap audit | … |
| RuboCop | … |
| Tests | … (n pruebas, n fallos) |

Solo declara la tarea terminada si las cinco pasan. Si alguna falla o no se pudo correr, dilo explícitamente con el error relevante.
