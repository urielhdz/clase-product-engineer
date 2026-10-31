# Integración continua (CI)

El pipeline vive en `.github/workflows/ci.yml` y se ejecuta en GitHub Actions en cada pull request, en cada push a `main` y de forma manual desde la pestaña «Actions» (`workflow_dispatch`). Corre con permisos de solo lectura sobre el repositorio y, si llega un nuevo commit a un pull request mientras otra ejecución sigue en curso, la anterior se cancela para no gastar minutos. Los cuatro jobs corren en paralelo y cada uno tiene un tiempo máximo para que un proceso colgado no bloquee el pipeline. Dependabot (`.github/dependabot.yml`) revisa cada semana las gemas y las versiones de las acciones para mantenerlas al día.

## Security (Ruby)

Este job revisa la seguridad del código Ruby y de sus dependencias. Primero ejecuta Brakeman (`bin/brakeman`), un análisis estático que busca vulnerabilidades típicas de Rails, como inyección SQL, XSS o redirecciones abiertas. El binstub agrega `--ensure-latest`, así que el paso falla si no usamos la versión más reciente de Brakeman, y en CI se ejecuta con `--exit-on-warn --exit-on-error` para que cualquier advertencia rompa el build. Después corre bundler-audit con `check --update`: descarga la versión más reciente de [ruby-advisory-db](https://github.com/rubysec/ruby-advisory-db) y compara cada gema de `Gemfile.lock` contra los avisos de seguridad publicados. Las CVE que no aplican al proyecto se pueden ignorar en `config/bundler-audit.yml`.

## Security (JavaScript)

Como el proyecto usa importmap en lugar de un bundler de Node, las dependencias de JavaScript están fijadas en `config/importmap.rb`. Este job ejecuta `bin/importmap audit`, que consulta la base de datos de vulnerabilidades de npm para cada paquete fijado y falla si alguno tiene un aviso de seguridad conocido.

## Lint

Este job ejecuta RuboCop con las reglas de `rubocop-rails-omakase` (y lo que agregue `.rubocop.yml`) para mantener un estilo de código uniforme. Usa el formato `github`, que muestra cada ofensa como anotación directamente sobre la línea del pull request. La caché de RuboCop se guarda con `actions/cache` usando como llave la versión de Ruby, la configuración de RuboCop y `Gemfile.lock`, así que solo se vuelven a analizar los archivos que cambiaron.

## Tests

Este job levanta un servicio de PostgreSQL 18 (la misma versión que usamos en desarrollo y producción) y espera a que responda a `pg_isready` antes de continuar. Instala `libpq-dev` y `libvips`, configura Ruby según `.ruby-version` con la caché de Bundler activada y pasa la conexión a la base de datos mediante `DB_HOST`, `DB_PORT`, `DB_USERNAME` y `DB_PASSWORD`, las mismas variables que lee `config/database.yml`. Luego ejecuta `bin/rails db:test:prepare test` para crear el esquema y correr toda la suite de Minitest y, al final, `bin/rails db:seed:replant` para comprobar que los seeds siguen funcionando con el esquema actual.

## Ejecutar lo mismo en local

Antes de abrir un pull request se pueden correr las mismas revisiones dentro de los contenedores:

```sh
bin/docker exec bin/brakeman --quiet --no-pager --exit-on-warn --exit-on-error
bin/docker exec bin/bundler-audit check --update
bin/docker exec bin/importmap audit
bin/docker exec bin/rubocop
bin/docker exec bin/rails test
```
