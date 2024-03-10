import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/color_bloc.dart';
import 'camera_screen.dart'; // Importa tu CameraScreen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camera App',
      home: BlocProvider(
        create: (context) => ColorBloc(),
        child: CameraScreen(),
      ),
    );
  }
}