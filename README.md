# gestor_cafeteria

Cliente Flutter de ejemplo para consultar y modificar pedidos de una cafetería. El proyecto incluye un `ApiClient` que convierte respuestas HTTP en tipos de error (`Failure`) y pruebas automatizadas con `MockClient`, sin depender de la red.

## Requisitos

- Flutter estable 3.47.x y Dart 3.13.x, de acuerdo con el entorno previsto en las consignas.
- Node.js 22.13 o superior para ejecutar el servidor de ejemplo.
- Git para el flujo de ramas y versionamiento.

## Servidor de pedidos

El backend se mantiene en un repositorio independiente; no se copia dentro de este proyecto Flutter:

- Repositorio: https://github.com/DMI-2026/mini_backend
- Versión de referencia del archivo ZIP recibido: commit `94d2533034134e4904dd38df8f2c60d56c2d1d6f` (prefijo `94d2533`).
- Entorno de backend verificado durante la preparación: Node.js `v22.16.0`; `npm test` terminó con 5 pruebas aprobadas y 0 fallidas.

Para descargarlo y levantarlo en otra terminal:

```bash
git clone https://github.com/DMI-2026/mini_backend.git
cd mini_backend
git checkout 94d2533034134e4904dd38df8f2c60d56c2d1d6f
node server.js
```

Comprueba el servidor en `http://localhost:8000/health`; debe devolver `{"status":"ok"}`.

## Ejecutar la app

Desde la carpeta `gestor_cafeteria`:

```bash
flutter pub get
flutter run -d chrome --dart-define=API_URL=http://localhost:8000
```

Para el emulador de Android:

```bash
flutter run --dart-define=API_URL=http://10.0.2.2:8000
```

En un teléfono físico, sustituye la dirección por la IP local de la computadora que ejecuta `mini_backend`:

```bash
flutter run --dart-define=API_URL=http://IP_DE_LA_COMPUTADORA:8000
```

Usa `http://` únicamente en el entorno local de desarrollo. Para un servidor remoto, configura una URL `https://`.

## Pruebas y análisis

```bash
flutter test
flutter analyze
```

En este equipo se ejecutaron los dos comandos con Flutter 3.47.7 y Dart 3.13.5: `flutter test` terminó con **14 pruebas aprobadas** y `flutter analyze` con **No issues found!**. El `pubspec.yaml` fija `sdk: 3.13.2`; si tu SDK es 3.13.5 o posterior, cambia esa línea a `sdk: ^3.13.2` en una copia antes de ejecutar `flutter pub get`.

## Estructura principal

```text
lib/
  core/
    failure.dart       # Tipos de error de la aplicación
    http_client.dart   # Cliente HTTP y mapeo de respuestas
    token_storage.dart # Almacenamiento del token
  main.dart            # Pantalla mínima de prueba
 test/core/
  failure_test.dart    # Pruebas de la jerarquía Failure
  http_client_test.dart  # Pruebas del cliente HTTP con MockClient
```

`android/local.properties`, `build/`, `.dart_tool/` y `.idea/` se excluyen del versionamiento. No agregues credenciales, tokens ni archivos locales del SDK al repositorio.
