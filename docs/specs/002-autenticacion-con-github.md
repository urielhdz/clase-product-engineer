# 002 — Autenticación con GitHub

- **Estado:** Implementada
- **Fecha:** 2026-10-28

## Contexto

La app gira alrededor de GitHub: los usuarios escriben specs que viven junto a sus repositorios. Antes de cualquier funcionalidad colaborativa necesitamos saber quién es cada usuario. En lugar de gestionar contraseñas propias, delegamos la identidad en GitHub mediante OAuth.

## Objetivos

- Iniciar sesión exclusivamente con una cuenta de GitHub (OAuth).
- Crear el usuario automáticamente la primera vez que entra y actualizar sus datos (login, nombre, email, avatar) en cada inicio de sesión.
- Sesiones persistentes en base de datos, revocables individualmente.
- Cerrar sesión.
- Proteger por defecto todas las páginas; las públicas se marcan explícitamente.

## Fuera de alcance

- Registro o inicio de sesión con email y contraseña u otros proveedores.
- Guardar el token de acceso de GitHub para llamar a su API (lo necesitará una spec posterior de integración con repositorios).
- Restringir el acceso a organizaciones o usuarios concretos.
- Gestión de sesiones activas desde la UI.

## Historias de usuario

- Como visitante, quiero entrar con mi cuenta de GitHub para no crear otra contraseña.
- Como usuario, quiero que la app recuerde mi sesión para no tener que entrar cada vez.
- Como usuario, quiero cerrar sesión para proteger mi cuenta en equipos compartidos.

## Criterios de aceptación

- [x] Dado un visitante sin sesión, cuando visita `/`, entonces es redirigido a `/login`.
- [x] Dado un visitante en `/login`, cuando pulsa «Entrar con GitHub», entonces se inicia el flujo OAuth con una petición `POST /auth/github` protegida con CSRF.
- [x] Dado que GitHub autoriza a un usuario nuevo, cuando vuelve al callback, entonces se crea un `User` con su `github_id`, se crea una `Session` y se le redirige a la página que intentaba visitar (o a `/`).
- [x] Dado que GitHub autoriza a un usuario existente, cuando vuelve al callback, entonces no se duplica el usuario y se actualizan su login, nombre, email y avatar.
- [x] Dado que el usuario cancela o GitHub devuelve un error, cuando vuelve a la app, entonces ve `/login` con un mensaje de error.
- [x] Dado un usuario con sesión, cuando pulsa «Cerrar sesión», entonces su `Session` se elimina, la cookie se borra y vuelve a `/login`.
- [x] Dado un usuario con sesión, cuando visita `/login`, entonces es redirigido a `/`.

## Diseño técnico

### Gemas

- `omniauth-github`: estrategia OAuth de GitHub.
- `omniauth-rails_csrf_protection`: obliga a iniciar el flujo con `POST` + token CSRF (mitiga CVE-2015-9284).

### Modelos

| Modelo | Campos | Notas |
| --- | --- | --- |
| `User` | `github_id` (bigint, único), `login`, `name`, `email`, `avatar_url` | `User.from_omniauth(auth)` crea o actualiza por `github_id` (el login puede cambiar en GitHub, el id no). |
| `Session` | `user_id`, `ip_address`, `user_agent` | Una fila por navegador. Se identifica con una cookie firmada, permanente, `httponly` y `SameSite=Lax`. |

`Current.session` / `Current.user` exponen la sesión actual (`ActiveSupport::CurrentAttributes`).

### Rutas

| Ruta | Acción |
| --- | --- |
| `GET /login` | `sessions#new` — página con el botón «Entrar con GitHub». |
| `POST /auth/github` | Middleware de OmniAuth: redirige a GitHub. |
| `GET /auth/github/callback` | `sessions#create` — crea/actualiza el usuario y abre sesión. |
| `GET /auth/failure` | `sessions#failure` — vuelve a `/login` con error. |
| `DELETE /logout` | `sessions#destroy` — cierra la sesión. |
| `GET /` | `home#show` — requiere sesión. |

### Controladores

El concern `Authentication` (incluido en `ApplicationController`) exige sesión en todas las acciones. Las acciones públicas usan `allow_unauthenticated_access`. Al iniciar sesión se llama a `reset_session` para evitar fijación de sesión.

### Configuración

- Scopes de OAuth: `read:user,user:email`.
- Credenciales: variables de entorno `GITHUB_CLIENT_ID` y `GITHUB_CLIENT_SECRET`, o en su defecto `github.client_id` / `github.client_secret` de `rails credentials`.
- Callback de la OAuth App de GitHub:
  - Desarrollo: `http://localhost:3000/auth/github/callback`
  - Producción: `https://<dominio>/auth/github/callback`
- En producción, Kamal inyecta `GITHUB_CLIENT_ID` y `GITHUB_CLIENT_SECRET` desde `.kamal/secrets`.

### Tests

`OmniAuth.config.test_mode` con `mock_auth[:github]` para simular las respuestas de GitHub en tests de integración.

## Preguntas abiertas

- ¿Guardamos el token de GitHub (cifrado con Active Record Encryption) para la integración con repositorios, o usamos una GitHub App con tokens de instalación?
- ¿Limitamos el acceso a miembros de ciertas organizaciones?
- ¿Caducidad máxima de las sesiones?
