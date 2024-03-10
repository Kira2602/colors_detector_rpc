// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:colors_detector_rpc/main.dart';

void main() {
  testWidgets('Camera screen loads and shows camera preview', (WidgetTester tester) async {
    // Inicializa las cámaras aquí si es necesario

    // Construye la aplicación y dispara un frame
    await tester.pumpWidget(MyApp());

    // Verifica si el widget de vista previa de la cámara está presente
    expect(find.byType(CameraPreview), findsOneWidget);

    // Aquí puedes agregar más verificaciones, como revisar si los elementos de UI están presentes
  });
}
