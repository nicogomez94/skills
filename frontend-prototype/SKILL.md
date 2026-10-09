---
name: frontend-prototype
description: "Crear prototipos y demos frontend para clientes en HTML, CSS y JavaScript puro, en español, con diseño responsive, Font Awesome, botón flotante de WhatsApp, animaciones de entrada por scroll en todas las secciones y publicación directa en Render Free mediante Render CLI. Usar cuando el usuario pida una landing page, sitio web, componente demo o propuesta visual sin frameworks, especialmente si necesita una entrega rápida y presentable para clientes."
---

# Frontend Prototype

## Objetivo

Crear prototipos web convincentes y listos para mostrar a clientes usando solo HTML, CSS y JavaScript vanilla.

## Flujo

1. Entender el negocio, el tono y las secciones necesarias.
2. Elegir una dirección visual memorable, profesional y coherente.
3. Construir `index.html`, `styles.css` y `main.js`.
4. Publicar directamente el sitio terminado en Render Free mediante Render CLI y devolver el enlace `onrender.com` en la respuesta final.
5. Revisar accesibilidad, responsividad, consistencia del copy y que todas las secciones entren con animación al hacer scroll.

## Reglas

- Mantener todo el contenido visible en español.
- Usar HTML5, CSS3 y JavaScript vanilla, sin frameworks ni build steps.
- Incluir Font Awesome 6 Free desde CDN cuando ayude al contexto visual.
- Se pueden usar eyebrows como etiquetas textuales breves, pero nunca agregar numeritos decorativos ni formatos de número y barra como `01 / Nuestra esencia`, `02 / Servicios` o similares.
- No dedicar tiempo a inventar un logo si el usuario no lo entrega.
- Si no hay logo provisto, usar un placeholder textual simple con el nombre o iniciales de la marca y aclarar que falta el logo.
- No usar `imagegen` ni ningún flujo de generación de imágenes para crear un logo ficticio.
- Diseñar mobile-first con breakpoints en `480px`, `768px` y `1024px`.
- Animar con `IntersectionObserver` todas las secciones y bloques principales que se revelan al hacer scroll, usando una clase base como `.fade-in`.
- Incluir un botón flotante de WhatsApp fijo en la esquina inferior derecha.
- Incluir siempre en el footer el crédito `Hecho por [zigodev](https://zigodev.com.ar)`, con el enlace en una pestaña nueva mediante `target="_blank" rel="noopener noreferrer"`.
- El crédito de ZigoDev debe quedar centrado horizontalmente en el medio del footer, en una fila propia de ancho completo y nunca dentro de la misma fila o esquina que el botón flotante de WhatsApp.
- Reservar espacio inferior seguro, incluyendo `env(safe-area-inset-bottom)` cuando corresponda, para que el botón de WhatsApp fijo abajo a la derecha nunca tape ni se superponga visualmente con el crédito. Mantener el crédito en el flujo normal del documento, no con `position: fixed` o `position: absolute`.
- Mantener el prototipo listo para deploy estático directo en Render Free.
- Asegurar que el hero inicial entre completo en el viewport en desktop y mobile; no debe desbordarse hacia abajo en la primera pantalla.
- Si el hero incluye una marquesina, ticker, franja de anuncios o texto horizontal en movimiento, la marquesina cuenta dentro del alto total del hero y debe quedar visible al abrir la página junto con el resto del hero, sin exigir scroll vertical. Contabilizar header, marquesina, título, copy, CTAs, imagen y el espacio reducido de los navegadores móviles al definir la altura.
- Limitar el tamaño del `h1`, el `line-height` y el `padding` del hero para evitar que el contenido principal quede por debajo del fold.
- No usar `clamp()` para el tamaño de las fuentes del hero ni para los `h1`.
- Definir tipografía del hero con tamaños fijos por media query en lugar de escalado fluido.

### Marquesinas y tickers

- Cuando haya una marquesina, debe ser un loop continuo con texto siempre visible. Renderizar como mínimo dos copias idénticas consecutivas del contenido (o un track repetido equivalente) y animar exactamente el ancho de una copia para que el reinicio sea imperceptible.
- Nunca permitir que el track se desplace hacia un estado vacío, termine en un hueco blanco o deje visible un lateral sin texto. Repetir el contenido lo suficiente para cubrir el viewport en desktop ancho y mobile angosto.
- No usar desvanecimientos laterales, máscaras de opacidad, gradientes que oculten los extremos ni una traslación de una sola pasada que haga desaparecer el texto. Se permite `overflow: hidden` únicamente en el contenedor de la marquesina para recortar el loop, nunca para generar scroll horizontal en toda la página.
- La marquesina debe verse desde la carga inicial dentro del hero: no ubicarla debajo del fold, no ocultarla hasta que comience la animación y no dejar que un H1 o una imagen demasiado grande la empuje hacia abajo. Si falta espacio, compactar el hero o enviar contenido secundario debajo del fold.
- Respetar `prefers-reduced-motion`: mantener el texto repetido visible y legible con una versión estática de ancho completo o el track pausado, sin ocultar la marquesina.

## Estructura esperada

- `index.html`
- `styles.css`
- `main.js`

## Implementación

### HTML

- Definir `charset`, `viewport`, `description` y `og:title`.
- Organizar el contenido en hero, beneficios, servicios, prueba social y CTA.
- Usar texto realista y específico, nunca lorem ipsum.

### CSS

- Definir variables CSS para colores, espaciado y tipografía.
- Evitar paletas genéricas y elegir una combinación con personalidad.
- Crear layouts fluidos, sin scroll horizontal y con buen contraste.
- Mantener el botón de WhatsApp visible por encima del resto del contenido.
- Mantener el footer de ancho completo y el crédito de ZigoDev centrado con `text-align: center`, dejando suficiente `padding-bottom` y área segura para el botón flotante de WhatsApp.
- Ajustar el hero con altura máxima y espaciado contenido para que no exceda el alto visible, usando tamaños de fuente fijos por breakpoint.
- Si el hero incluye imagen, ilustración o bloque de confianza, priorizar una composición compacta antes que un H1 gigante.
- Si el hero incluye marquesina, probar la composición completa en alturas representativas de desktop y mobile: al abrir debe verse el hero entero y la marquesina debe mostrar texto de forma continua, sin huecos ni desapariciones laterales.

### Formato y editabilidad del código

- Mantener siempre `index.html` y `styles.css` bien formateados, legibles y fáciles de editar directamente. Usar indentación consistente de dos espacios en todo el proyecto.
- Nunca minificar, comprimir, ofuscar ni convertir el HTML o CSS en bloques gigantes de una sola línea. Dejar cada elemento lógico en líneas claras, anidar con sangría y alinear correctamente las etiquetas de cierre.
- En `index.html`, conservar una jerarquía semántica visible; separar las secciones con saltos de línea y comentarios breves cuando ayuden a ubicar cada bloque.
- En `styles.css`, escribir un selector por bloque, una declaración por línea, separar visualmente cada sección y ordenar de forma clara variables, reset, layout, componentes, estados y media queries.
- Usar nombres de clases descriptivos y reglas simples, evitando estilos inline extensos o código generado difícil de mantener. Si ya existe un formateador en el proyecto, ejecutarlo antes de entregar; si no, aplicar estas convenciones manualmente sin agregar dependencias solo para formatear.

### JavaScript

- Activar las animaciones con `IntersectionObserver`.
- Aplicar animaciones de entrada a hero, secciones intermedias, tarjetas, CTA y cualquier bloque nuevo que aparezca en el scroll.
- Reutilizar clases simples para estados visibles, menús o interacciones menores.
- Para la marquesina, usar un track duplicado y una animación lineal infinita cuyo desplazamiento sea exactamente el ancho de una copia. Evitar animar el contenedor completo hacia fuera de pantalla o depender de una única cadena de texto.

### Despliegue en Render

- Para cada prototipo web terminado, crear o configurar directamente el servicio en Render Free usando Render CLI; no generar un YAML intermedio.
- Si el resultado es una página estática o un frontend estático, es obligatorio publicarlo como Render Free Static Site mediante la CLI y devolver el enlace vivo cuando termine el deploy.
- Si se crea un repositorio GitHub u otro repositorio Git para conectarlo con Render, crearlo siempre como repositorio público desde el inicio; nunca crear uno privado para este flujo. No cambiar la visibilidad de un repositorio privado existente sin autorización explícita.
- Usar únicamente Render CLI para crear, configurar, desplegar o actualizar el servicio. Nunca usar Playwright, automatización del navegador ni el dashboard de Render para hacer el deploy; el navegador solo puede usarse, si hace falta, para verificar visualmente el resultado ya publicado.
- Para prototipos estáticos, preferir `render services create --type static_site --plan free` con el `build` y el `publish` que correspondan al proyecto.
- Si el servicio ya existe, usar `render deploys create <service_id> --wait` para disparar un redeploy y esperar el resultado.
- Después del deploy, devolver en la respuesta el enlace vivo `onrender.com` o el enlace exacto que Render muestre para el servicio.
- Si no hay remoto Git, Render CLI no está disponible o falta autenticación, explicar el bloqueo exacto y no inventar una URL. No crear como alternativa un `render.yaml`.

### Commit y entrega

- En cada llamado de esta skill que modifique archivos, terminar revisando `git status` y el diff, agregar únicamente los archivos correspondientes a ese llamado y crear un commit descriptivo y conciso.
- Preservar los cambios ajenos del usuario; no usar `reset`, `checkout` ni staging amplio para limpiar el árbol de trabajo.
- Verificar que el commit exista y que el repositorio quede listo para hacer `push`. No ejecutar `git push` salvo que el usuario lo pida explícitamente.
- Si no hubo cambios, no crear un commit vacío. Si la carpeta no es un repositorio Git o no se puede crear el commit, informar el bloqueo exacto.

## Checklist final

- Contenido 100% en español
- Diseño responsive sin scroll horizontal
- Botón de WhatsApp funcional y visible en mobile
- Crédito de ZigoDev centrado en el footer, sin quedar tapado por WhatsApp
- Animaciones de entrada en hero, secciones clave, tarjetas y CTA a medida que se hace scroll
- Íconos de Font Awesome semánticos para el contexto
- Deploy directo en Render Free realizado, con URL viva devuelta al final
