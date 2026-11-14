// IA: bloque generado con asistencia de IA (ver docs/ia-t3.md) y revisado a mano.
import 'package:flutter/material.dart';

import 'views/lista_tres_estados_view.dart';

/// Punto de entrada de la Nivelación T3.
///
/// Se corre con:
/// `flutter run -t lib/main_lista_tres_estados.dart`
///
/// La pantalla usa el repositorio falso, así que no necesita backend ni
/// Firebase.
void main() {
  runApp(const AppListaTresEstados());
}

class AppListaTresEstados extends StatelessWidget {
  const AppListaTresEstados({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Menú · tres estados',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6F4E37)),
        useMaterial3: true,
      ),
      home: const ListaTresEstadosView(),
    );
  }
}
