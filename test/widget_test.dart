// Prueba de humo (smoke test) de TV Anto.
// Verifica que la app arranca y monta su pantalla principal sin errores.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tv_anto/main.dart';

void main() {
  testWidgets('TV Anto inicia y muestra la pantalla principal',
      (WidgetTester tester) async {
    await tester.pumpWidget(const TvAntoApp());
    await tester.pump(const Duration(milliseconds: 100));

    // La app debe montar el MaterialApp de TV Anto.
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
