---
name: replegar-web-existente
description: Duplicar y rebrandear un sitio full-stack existente para otro cliente en una carpeta, repositorio, base de datos y despliegue independientes, conservando autenticación, panel administrador, CRUD, imágenes, filtros y backend. Usar cuando el usuario pida replicar, replegar, clonar o adaptar una web existente sin afectar el proyecto original, especialmente con React/Vite, Express, Prisma, PostgreSQL y Render.
---

# Replegar una web existente

Crear una réplica aislada, cambiar solamente identidad y contenido, y demostrar que las funciones existentes siguen funcionando. Proteger siempre el origen, los datos y los despliegues anteriores.

## 1. Fijar el alcance y proteger el origen

- Inspeccionar todos los candidatos y confirmar qué carpeta contiene el estado actual correcto.
- Ejecutar `git status --short --branch`, revisar remotos y detectar cambios sin commit.
- Tratar el working tree actual como fuente si el usuario dice “igual como está ahora”.
- Crear una carpeta hermana nueva. Copiar sin `.git`, `node_modules`, builds, variables privadas, uploads ni archivos del sistema.
- No editar, limpiar, restaurar, commitear, pushear ni desplegar el repositorio fuente.
- No tocar el servicio, base de datos, dominio ni variables de producción del cliente anterior.
- No ejecutar `git commit` o `git push` sin autorización explícita del usuario. Una solicitud de “preparar” no autoriza publicar; una solicitud explícita de crear repositorio y desplegar sí autoriza solamente el repositorio nuevo. Ante una instrucción previa de no commitear sin permiso, pedir confirmación antes del primer commit.

## 2. Inventariar antes de cambiar

- Registrar stack, scripts, rutas, API, modelo Prisma, migraciones, seeds, autenticación, roles, CRUD, filtros, carga de imágenes y formularios.
- Buscar todo el branding anterior con `rg`: nombre, responsable, matrícula, teléfonos, WhatsApp, email, dirección, ciudad, slogans, metadatos, logo, favicon, datos demo y nombres de servicios Render.
- Identificar qué datos entregó el nuevo cliente y cuáles faltan.
- No inventar responsables, matrículas, domicilios legales, años de experiencia ni certificaciones. Reemplazar ese bloque por lenguaje institucional cuando falten datos.
- Mantener todas las funciones existentes salvo que un ajuste mínimo sea necesario para aislar o desplegar la copia.

## 3. Centralizar identidad y activos

- Crear una única configuración de marca para nombre, slogan, logo, dirección, teléfono, WhatsApp, email y ciudad.
- Importar esa configuración en navegación, footer, home, contacto y botones flotantes; evitar repetir literales.
- Usar un único archivo final de logo en `client/public` y apuntar menú, footer y favicon a ese archivo.
- Eliminar de la copia solamente los logos y activos viejos que estén sin uso. Conservar el origen como respaldo.
- Verificar todos los `alt`, títulos HTML, metadescripciones, destinatarios de formularios y mensajes prearmados de WhatsApp.

## 4. Mantener una sola fuente CSS sin romper la cascada

- Importar una sola hoja de estilos desde el entrypoint.
- Si el proyecto tiene varias hojas solapadas, consolidarlas primero de forma literal y en el mismo orden de importación.
- Comparar hash y tamaño del CSS compilado antes y después de consolidar. Deben coincidir antes de refactorizar reglas.
- No “deduplicar” selectores por nombre sin entender orden, especificidad, media queries y herencia: dos reglas iguales en archivos distintos pueden depender de la cascada.
- Después de lograr equivalencia visual, reorganizar selectores gradualmente y volver a validar cada breakpoint.
- Realizar el rebranding en esa única hoja. No crear parches paralelos como `theme.css`, `fix.css` o estilos duplicados por página.
- Validar hero, header, buscador, botón completo, tarjetas, formularios, panel y footer en escritorio y móvil.

## 5. Aislar desarrollo local

- Elegir puertos distintos de los usados por el proyecto fuente.
- Configurar Vite con `strictPort: true` para evitar que cambie silenciosamente a otro puerto.
- Usar una base PostgreSQL nueva con nombre específico del cliente.
- Crear variables locales ignoradas por Git; mantener solo ejemplos públicos versionados.
- Mantener llamadas frontend same-origin (`/api`, `/health`, `/uploads`) y un proxy Vite hacia el backend local.
- No compilar una URL `localhost` dentro del frontend de producción.
- Permitir orígenes loopback en desarrollo y mantener CORS restringido en producción.
- No dejar varias instancias del mismo proyecto ocupando puertos ambiguos.

## 6. Rebrandear datos demo sin afectar producción

- Cambiar defaults del panel, debug prefill y seeds al nuevo mercado o ciudad.
- Marcar direcciones ficticias como “Ubicación reservada” en vez de presentarlas como datos reales.
- Evitar seeds destructivos en cada inicio o deploy.
- En Render, no combinar `RUN_SEED_ON_DEPLOY=true` con un seed que hace `deleteMany` sobre propiedades.
- Preferir un bootstrap idempotente: crear admin y datos demo únicamente si la base está vacía.
- Mantener migraciones Prisma como única fuente del esquema de producción.

## 7. Validar funciones, no solamente la compilación

Ejecutar como mínimo:

1. `npm ci`.
2. Prisma generate y validate.
3. Migración sobre la base nueva.
4. Build y lint.
5. Levantar frontend y backend juntos.
6. Confirmar home 200 y health 200.
7. Probar login admin.
8. Probar listado público y filtros.
9. Probar carga real de una imagen.
10. Crear, leer, editar y borrar una propiedad temporal.
11. Eliminar el archivo y registro temporales de prueba.
12. Revisar visualmente escritorio y móvil.

Si la revisión visual automatizada no está disponible, informarlo con claridad y entregar el enlace local para revisión humana; no afirmar que el diseño fue inspeccionado.

## 8. Preparar Render sin mezclar clientes

- Usar un solo Render Web Service para React/Vite + Express cuando Express sirve `client/dist`.
- Crear un servicio y PostgreSQL nuevos con nombres únicos.
- Usar:

```yaml
buildCommand: npm ci --include=dev && npx prisma generate && npx prisma migrate deploy && npm run build
startCommand: npm start
healthCheckPath: /api/health
```

- Mantener API en `/api` y assets subidos en `/uploads`.
- Configurar `DATABASE_URL` desde la base nueva, `JWT_SECRET` generado y credenciales admin fuera del repositorio.
- Configurar destinatario y nombre del formulario durante el build de Vite.
- Deshabilitar seeds destructivos recurrentes.
- Validar `render.yaml`, build local y Prisma antes de publicar.
- Tras desplegar, comprobar home, health, assets, login, CRUD y carga de imágenes en la URL pública.

## 9. Handoff y Git

- Mostrar `git diff --check`, `git status` y un resumen de archivos cambiados.
- Informar carpeta local, URL local, ruta admin, credenciales locales de desarrollo y datos faltantes.
- Antes de commit/push, confirmar exactamente qué repositorio nuevo se modificará cuando exista una restricción previa del usuario.
- No incluir `.env`, bases locales, uploads, builds ni secretos en Git.
- Entregar por separado URL del repositorio y URL de Render cuando la publicación esté autorizada.

## Criterio de finalización

Considerar terminado solo cuando la copia sea independiente, no contenga branding visible del cliente anterior, use una sola fuente CSS, compile, pase lint, tenga base propia, conserve las funciones verificadas y no haya alterado el repositorio ni el despliegue original.
