# Declaración de uso de IA · Nivelación T3

**Actividad:** Nivelación T3 · Lista con tres estados
**Alumna:** Loreley Carrillo · 20233TN227
**Herramienta:** OpenCode (agente de IA con modelo DeepSeek V4.1 Flash)
**Fecha:** 13 de noviembre de 2026
**Nivel de IA:** Nivel 2 · IA como herramienta declarada

## Qué se le pidió

1. Traer mi `Resultado<T>` sellado de la Nivelación T1 y dejarlo en `lib/core/resultado.dart`.
2. Crear la entidad `Producto` con datos de la cafetería.
3. Escribir un repositorio falso que tardara entre 1 y 2 segundos, devolviera al menos 5 productos y fallara la primera llamada para probar el error y el reintento.
4. Construir la pantalla `StatefulWidget` con un campo `Resultado<List<Producto>>`, un `switch` exhaustivo sin `default`, el indicador de carga, la lista de tarjetas y el botón Reintentar.
5. Escribir las pruebas de los tres estados y del reintento.

## Qué acepté

- La estructura de `Resultado<T>`, que ya era mía de la T1 y solo se copió.
- El repositorio falso con seis productos de la cafetería, `Future.delayed` de 1.5 s y la falla controlada en la primera llamada.
- La pantalla con `switch` de expresión sobre el estado y el `if (!mounted) return;` después de cada `await`.
- Las tarjetas con nombre, descripción, categoría y precio formateado en centavos.
- Las pruebas de `Resultado`, del repositorio falso y de la vista.

## Qué cambié o rechacé

- Elegí un mensaje fijo en español en lugar de mostrar la excepción (`$e`), para que el estado de error se lea sin texto técnico.
- Dejé el `catch` sobre `Exception` en vez de `catch (_)`, para no esconder errores de programación.
- Ajusté el retraso del repositorio a un parámetro del constructor: en la app es de 1.5 s y en las pruebas se usa `Duration.zero` para no esperar.
- Rechacé usar `FutureBuilder` y cualquier gestor de estado: la consigna pide `StatefulWidget` con `setState`.

## Cómo lo probé

- `flutter analyze lib test` sin observaciones (`No issues found!`).
- `flutter test`: pruebas de `Resultado`, del repositorio falso y de la vista (cargando, lista, error y reintento).
- Prueba manual en el emulador Android: los tres estados y el reintento, con una captura de cada uno.

## Marcas en el código

Cada archivo generado lleva el comentario `// IA:` en la cabecera, y en el
repositorio falso se marca además la línea de la falla intencional.
