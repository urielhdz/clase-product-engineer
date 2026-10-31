---
name: brand-guidelines
description: Guía de marca de Spec Facilito (diseño visual, tipografía, colores y tono del copy). Úsala siempre que crees o modifiques vistas, layouts, componentes, estilos Tailwind, dashboards o cualquier texto visible para el usuario (botones, etiquetas, mensajes flash, errores, emails, estados vacíos).
---

# Guía de marca

Spec Facilito es una herramienta de trabajo: el contenido (las specs) es el protagonista y la interfaz se aparta. La referencia visual es la mezcla de **Netflix** (fondo negro, imagen y contenido a pantalla completa, navegación mínima) y **Notion** (tipografía cuidada, mucho espacio en blanco, controles que aparecen cuando se necesitan).

## Diseño visual

### Tema

- **Solo modo oscuro.** No hay tema claro ni variantes `dark:`.
- **Monocromo.** No hay color de acento. La jerarquía se construye con tamaño, peso, espacio y contraste de grises.
- Rojo (`danger`) y verde (`success`) solo comunican estado. Nunca decoran.

### Tokens

Los valores viven en `app/assets/tailwind/application.css` (`@theme`). Usa siempre los tokens; nunca escribas hex ni grises de Tailwind (`gray-700`, `neutral-800`) en las vistas.

| Token | Uso |
|---|---|
| `bg-canvas` | Fondo de la página |
| `bg-surface` | Zonas que necesitan separarse del fondo (paneles, menús) |
| `bg-raised` | Hover de filas, inputs, elementos encima de `surface` |
| `border-line` | Separadores, solo cuando el espacio no basta |
| `text-ink` | Texto principal |
| `text-ink-muted` | Texto secundario, descripciones |
| `text-ink-subtle` | Metadatos, placeholders, texto deshabilitado |
| `bg-primary text-on-primary hover:bg-primary-hover` | Botón de acción principal (uno por pantalla) |
| `text-danger`, `text-success` | Estados de error y éxito |

### Tipografía

- **Playfair Display** (`font-display`): solo `h1`, `h2` y titulares grandes. Ya se aplica por defecto a `h1` y `h2`.
- **Lato** (`font-sans`, por defecto): todo lo demás. Cuerpo, etiquetas, botones, tablas, navegación.
- Nunca uses Playfair en botones, etiquetas, tablas ni texto pequeño.
- Pocos tamaños: elige entre `text-sm`, `text-base`, `text-lg` para UI y `text-3xl`–`text-5xl` para titulares.

### Qué evitar

Estos patrones hacen que la interfaz parezca generada por IA. No los uses:

- **Tarjetas con borde** (`border rounded-lg p-6` envolviendo cada bloque). Separa con espacio o con un cambio sutil de superficie.
- **Badges o pills encima de los títulos** ("Nuevo", "Beta", "✨ Destacado").
- Gradientes, glassmorphism, sombras de colores, brillos.
- Emojis o iconos decorativos junto a cada título.
- Rejillas de tres tarjetas con icono + título + descripción.
- Texto centrado en bloques largos.

### Qué hacer

- Mucho espacio negativo. Ante la duda, más margen y menos elementos.
- Listas y filas planas con hover en `bg-raised` (estilo Notion) en lugar de tarjetas.
- Controles secundarios discretos: aparecen en hover o en un menú, no siempre visibles.
- Esquinas suaves y consistentes (`rounded-md`).
- Foco visible siempre (ya definido en `:focus-visible`).

## Dashboards y pantallas

- Cada pantalla tiene **una acción principal reconocible** y **una información clara que presentar**. Si no puedes nombrar ambas en una frase, la pantalla está mal planteada.
- Un solo botón `primary` por pantalla. El resto son secundarios (texto o `bg-raised`).
- Nada de métricas de relleno ni widgets "por si acaso".
- **Secciones «Avanzado»:** si una pantalla acumula demasiados botones o configuraciones, **pregunta al desarrollador** qué opciones deberían esconderse en una sección «Avanzado» y propón cuáles. No las escondas sin su confirmación.

## Copy

Todo el texto visible está en **español**.

### Tono

- Directo y conciso, sin sonar corporativo. Habla como una persona competente, en tuteo.
- Afirma con claridad. Nada de "podría", "quizás", "intentaremos" cuando sabes lo que pasa.
- Nada de copy confuso, ambiguo o que genere inseguridad.
- Frases cortas. Una idea por frase.

### Reglas

- **Etiquetas son sustantivos:** «Título», «Repositorio», «Miembros».
- **Botones son verbos:** «Crear spec», «Guardar», «Invitar», «Entrar con GitHub».
- **No uses raya (—)**. Usa punto, coma o dos puntos.
- **No uses construcciones «no X, sino Y»** ni «no es solo X, es Y». Di directamente lo que es.
- Sin signos de exclamación en mensajes del sistema.
- Sin jerga técnica en mensajes al usuario (nada de "error 500", "token inválido").

### Errores

Un mensaje de error dice **qué pasó** y **qué hacer ahora**. Nunca culpa al usuario.

| Mal | Bien |
|---|---|
| «Ingresaste un título inválido.» | «El título está vacío. Escribe uno para guardar la spec.» |
| «Error al guardar.» | «No se pudo guardar la spec. Vuelve a intentarlo en unos segundos.» |
| «Oops! Algo salió mal 😕» | «No se pudo conectar con GitHub. Inténtalo de nuevo.» |

### Ejemplos

| Contexto | Texto |
|---|---|
| Estado vacío | «Aún no tienes specs. Crea la primera para empezar.» + botón «Crear spec» |
| Éxito | «Spec guardada.» |
| Confirmación destructiva | «¿Eliminar esta spec? No se puede deshacer.» + botones «Eliminar» / «Cancelar» |

## Checklist antes de terminar

- [ ] Solo tokens de marca, sin hex ni grises de Tailwind.
- [ ] Sin tarjetas con borde ni badges sobre títulos.
- [ ] Una acción principal por pantalla.
- [ ] Etiquetas sustantivos, botones verbos.
- [ ] Sin raya (—) ni «no X, sino Y».
- [ ] Cada error dice qué pasó y qué hacer.
