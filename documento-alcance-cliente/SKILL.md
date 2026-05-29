---
name: documento-alcance-cliente
description: Genera documentos basicos de alcance en Google Docs para entregar a clientes antes de empezar un proyecto, dejando tambien una version local en Markdown (.md). Usar cuando el usuario describa un sistema, app, sitio web, MVP, automatizacion o funcionalidad y necesite un alcance breve, comercial y no tecnico para alinear expectativas, aclarar inclusiones, exclusiones, supuestos y funcionalidades principales, recibir el link del documento en Google Drive y conservar una copia editable en el directorio de trabajo.
---

# Documento De Alcance Para Cliente

## Objetivo

Crear un documento breve, claro y listo para enviar al cliente como Google Docs en Google Drive antes de iniciar un proyecto. El documento debe alinear expectativas, reducir malentendidos y dejar claro que incluye y que no incluye el alcance acordado. Ademas, dejar una version local en Markdown (`.md`) dentro del directorio de trabajo. Al terminar, entregar el link directo para abrir el Google Docs y la ruta del `.md`.

## Flujo

1. Leer la descripcion del usuario e identificar el tipo de proyecto, objetivo, publico, funcionalidades pedidas, roles y restricciones.
2. Si falta informacion, asumir lo minimo razonable y marcarlo como supuesto. No frenar el trabajo salvo que falte un dato imprescindible para no inventar el proyecto.
3. Separar claramente que incluye y que no incluye el alcance acordado.
4. Redactar para un cliente no tecnico, con lenguaje simple, profesional y comercial.
5. Evitar terminos de programacion como API, endpoints, base de datos, deploy, stack, servidor o framework, salvo que el cliente los haya pedido o sean necesarios para aclarar el alcance.
6. Crear un Google Docs como entrega principal usando el conector de Google Drive/Google Docs cuando este disponible.
7. Crear tambien una version `.md` con el mismo contenido en el directorio de trabajo actual, usando un nombre claro como `alcance-[cliente-o-proyecto].md`.
8. Si el flujo disponible requiere un archivo intermedio, generar un `.docx` temporal con `scripts/create_scope_docx.py` y subir/importar ese contenido a Google Docs, pero no tratar el `.docx` como entrega final.
9. En la respuesta final, indicar el link del Google Docs en Google Drive, la ruta del `.md` local y resumir brevemente que contiene. No pegar todo el documento salvo que el usuario tambien lo pida.

## Formato De Salida

Usar esta estructura como base para el contenido del Google Docs y de la copia `.md`. Omitir secciones que no apliquen:

```markdown
# [Titulo del proyecto]

## Resumen general
[Breve descripcion del proyecto en lenguaje simple.]

## Objetivo del sistema
[Que busca resolver o facilitar.]

## Alcance incluido
[Lista clara de lo que entra en el alcance acordado.]

## Funcionalidades principales
[Funciones concretas pedidas por el cliente.]

## Roles de usuario
[Roles si aplica: cliente, usuario final, administrador, vendedor, etc.]

## Panel administrador
[Solo si aplica. Explicar que se podra gestionar desde ahi sin detalle tecnico.]

## Flujo basico de uso
[Paso a paso simple de como se usaria el sistema.]

## Que no incluye
[Limites explicitos del alcance acordado.]

## Posibles mejoras futuras
[Solo si el usuario lo pidio explicitamente.]

## Supuestos importantes
[Aclaraciones asumidas para poder avanzar.]
```

## Reglas De Redaccion

- Mantenerlo corto y entendible; preferir claridad sobre detalle tecnico.
- No inventar funcionalidades que el cliente no pidio.
- Convertir terminos tecnicos del usuario a lenguaje de negocio cuando sea posible.
- Usar bullets breves para alcance, funcionalidades, exclusiones y supuestos.
- No mencionar "Etapa 1", "Etapa 2", "primera etapa", "segunda etapa" ni organizar el documento por etapas salvo que el usuario lo pida explicitamente.
- No incluir secciones de mejoras futuras, siguientes etapas o funcionalidades para despues salvo que el usuario lo pida explicitamente.
- Hacer que las exclusiones sean concretas y cuidadosas, sin sonar defensivo.
- No incluir presupuestos, tiempos ni condiciones legales salvo que el usuario lo pida.
- Redactar con tildes y ortografia cuidada en español para evitar que el Google Docs quede con subrayados innecesarios.

## Presentacion Del Google Docs

- El Google Docs debe quedar presentable para enviar al cliente, no solo como texto pegado.
- Usar una fuente moderna y legible, buen interlineado y separacion clara entre titulo, secciones, parrafos y bullets.
- Evitar que todo quede pegado: cada seccion debe respirar visualmente.
- Usar bullets reales del documento, no guiones escritos como texto.
- Mantener una estetica sobria y profesional, con titulos diferenciados y margenes comodos.
- Verificar que el documento se haya creado correctamente en Google Drive y que exista un link para abrirlo.
- Si se modifica el generador `.docx` usado como respaldo, conservar que funcione solo con librerias estandar de Python salvo que el usuario pida otra cosa.

## Generacion Del Google Docs

Preferir crear o importar el documento directamente en Google Docs mediante el conector de Google Drive/Google Docs. Usar un titulo claro, por ejemplo `Alcance - [cliente o proyecto]`.

Crear siempre una copia local en Markdown (`.md`) con el mismo contenido que el Google Docs, en el directorio de trabajo actual. Preferir nombres claros, por ejemplo `alcance-[cliente-o-proyecto].md`. Esta copia sirve como respaldo editable interno; el documento para mostrar al cliente sigue siendo el Google Docs.

Cuando sea mas practico generar primero un documento intermedio, crear un JSON temporal con esta forma:


```json
{
  "title": "Titulo del proyecto",
  "sections": [
    {
      "heading": "Resumen general",
      "paragraphs": ["Texto breve."]
    },
    {
      "heading": "Alcance incluido",
      "bullets": ["Item 1", "Item 2"]
    }
  ],
  "closing": "Este alcance sirve como base inicial para validar expectativas antes de avanzar con el desarrollo."
}
```

Ejecutar el generador solo como paso intermedio:

```bash
python3 /Users/nicogomez/.codex/skills/documento-alcance-cliente/scripts/create_scope_docx.py input.json output.docx
```

Luego importar o recrear ese contenido en un Google Docs y usar el Google Docs como entrega final.

La respuesta final debe incluir:

- El link directo del Google Docs en Google Drive.
- La ruta del archivo `.md` local.
- Un resumen breve del contenido creado.
- Cualquier supuesto importante que se haya usado.

## Cierre Opcional

Si ayuda, cerrar con una frase breve tipo:

> Este alcance sirve como base inicial para validar expectativas antes de avanzar con el desarrollo.
