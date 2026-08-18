---
name: frontend-prototype
description: "Crear prototipos y demos frontend para clientes en HTML, CSS y JavaScript puro, en español, con diseño responsive, Font Awesome, botón flotante de WhatsApp, animaciones de entrada por scroll en todas las secciones e integración lista para deploy en Render mediante render.yaml y Render CLI. Usar cuando el usuario pida una landing page, sitio web, componente demo o propuesta visual sin frameworks, especialmente si necesita una entrega rápida y presentable para clientes."
---

# Frontend Prototype

## Objetivo

Crear prototipos web convincentes y listos para mostrar a clientes usando solo HTML, CSS y JavaScript vanilla.

## Flujo

1. Entender el negocio, el tono y las secciones necesarias.
2. Elegir una dirección visual memorable, profesional y coherente.
3. Construir `index.html`, `styles.css`, `main.js` y, si aplica, `render.yaml`.
4. Si el proyecto tiene remoto Git y acceso a Render CLI, crear o desplegar el sitio en Render Free y devolver el enlace `onrender.com` en la respuesta final.
5. Revisar accesibilidad, responsividad, consistencia del copy y que todas las secciones entren con animación al hacer scroll.

## Reglas

- Mantener todo el contenido visible en español.
- Usar HTML5, CSS3 y JavaScript vanilla, sin frameworks ni build steps.
- Incluir Font Awesome 6 Free desde CDN cuando ayude al contexto visual.
- No dedicar tiempo a inventar un logo si el usuario no lo entrega.
- Si no hay logo provisto, usar un placeholder textual simple con el nombre o iniciales de la marca y aclarar que falta el logo.
- No usar `imagegen` ni ningún flujo de generación de imágenes para crear un logo ficticio.
- Diseñar mobile-first con breakpoints en `480px`, `768px` y `1024px`.
- Animar con `IntersectionObserver` todas las secciones y bloques principales que se revelan al hacer scroll, usando una clase base como `.fade-in`.
- Incluir un botón flotante de WhatsApp fijo en la esquina inferior derecha.
- Mantener el prototipo listo para deploy estático en Render.
- Asegurar que el hero inicial entre completo en el viewport en desktop y mobile; no debe desbordarse hacia abajo en la primera pantalla.
- Limitar el tamaño del `h1`, el `line-height` y el `padding` del hero para evitar que el contenido principal quede por debajo del fold.
- No usar `clamp()` para el tamaño de las fuentes del hero ni para los `h1`.
- Definir tipografía del hero con tamaños fijos por media query en lugar de escalado fluido.

## Estructura esperada

- `index.html`
- `styles.css`
- `main.js`
- `render.yaml` desde `assets/render.yaml`

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
- Ajustar el hero con altura máxima y espaciado contenido para que no exceda el alto visible, usando tamaños de fuente fijos por breakpoint.
- Si el hero incluye imagen, ilustración o bloque de confianza, priorizar una composición compacta antes que un H1 gigante.

### JavaScript

- Activar las animaciones con `IntersectionObserver`.
- Aplicar animaciones de entrada a hero, secciones intermedias, tarjetas, CTA y cualquier bloque nuevo que aparezca en el scroll.
- Reutilizar clases simples para estados visibles, menús o interacciones menores.

### Despliegue en Render

- Cuando el proyecto ya esté en un repositorio con remoto y el entorno tenga Render CLI, crear el servicio en Render Free desde el repo y no quedarse solo en el YAML.
- Para prototipos estáticos, preferir `render services create --type static_site --plan free` con el `build` y el `publish` que correspondan al proyecto.
- Si el servicio ya existe, usar `render deploys create <service_id> --wait` para disparar un redeploy y esperar el resultado.
- Después del deploy, devolver en la respuesta el enlace vivo `onrender.com` o el enlace exacto que Render muestre para el servicio.
- Si no hay remoto Git o no se puede autenticar Render CLI, dejar el `render.yaml` listo y explicarlo con claridad.

## `render.yaml`

- Copiar la plantilla desde `assets/render.yaml`.
- Reemplazar `NOMBRE-DEL-PROYECTO` por un slug corto en minúsculas.
- Mantener la configuración estática para una entrega simple en Render, pero usarla como base del despliegue libre y del URL final.

## Checklist final

- Contenido 100% en español
- Diseño responsive sin scroll horizontal
- Botón de WhatsApp funcional y visible en mobile
- Animaciones de entrada en hero, secciones clave, tarjetas y CTA a medida que se hace scroll
- Íconos de Font Awesome semánticos para el contexto
- `render.yaml` incluido y con el nombre correcto
- Deploy en Render Free realizado cuando el entorno lo permita, con URL viva devuelta al final
