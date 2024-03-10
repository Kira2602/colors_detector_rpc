import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/color_bloc.dart';
import 'bloc/color_event.dart';
import 'bloc/color_state.dart';
import 'package:camera/camera.dart';

import 'bloc/color_state.dart';
import 'help_guide.dart';

class CameraScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Color Detector Blindness',
            style: TextStyle(color: Colors.white), // Título blanco
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/wallpaperFondo.jpeg'), // Asegúrate de que esta imagen existe
                fit: BoxFit.cover,
              ),
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.help_outline),
              color: Colors.white,
              onPressed: () {
                showHelpDialog(context);
              },
            ),
          ],
        ),
        body: CameraScreenContent(

        ),
      ),
    );
  }
}

class CameraScreenContent extends StatefulWidget {
  @override
  _CameraScreenContentState createState() => _CameraScreenContentState();
}

class _CameraScreenContentState extends State<CameraScreenContent> {
  CameraController? controller;
  bool isCameraInitialized = false;
  Color? detectedColor;
  String colorName = 'Color Desconocido';
  String hexColorCode = '';

  @override
  void initState() {
    super.initState();
    context.read<ColorBloc>().add(InitializeCameraEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/wallpaperFondo.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
    child: BlocConsumer<ColorBloc, ColorState>(
      listener: (context, state) {
        if (state is CameraInitializedState) {
          controller = state.cameraController;
          setState(() {
            isCameraInitialized = true;
          });
        } else if (state is ColorDetectedState) {
          setState(() {
            detectedColor = state.color;
            colorName = state.colorName;
            hexColorCode = state.color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase();
          });
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            Expanded(
              child: controller == null || !isCameraInitialized
                  ? Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (controller == null) {
                      context.read<ColorBloc>().add(InitializeCameraEvent());
                    }
                  },
                  child: Icon(Icons.camera),
                ),
              )
                  :GestureDetector(
                onTapDown: (TapDownDetails details) async {
                  // Asegúrate de que el controlador de la cámara está inicializado y la cámara está disponible.
                  if (controller != null && isCameraInitialized) {
                    try {
                      // Toma la imagen y guarda el archivo temporal.
                      final XFile image = await controller!.takePicture();

                      // Calcula el centro de la pantalla.
                      // Estas coordenadas deben ser ajustadas si el círculo no está en el centro de la vista de la cámara.
                      final Size screenSize = MediaQuery.of(context).size;
                      final double centerX = screenSize.width / 2;
                      final double centerY = screenSize.height / 2;

                      // Emite el evento para procesar la imagen y detectar el color.
                      // El radio debe ser ajustado de acuerdo al tamaño del círculo que se muestra en la UI.
                      context.read<ColorBloc>().add(
                        GetColorAtPositionEvent(centerX.toInt(), centerY.toInt(), 10, image), // Asumiendo un radio de 10
                      );
                    } catch (e) {
                      // Si hay un error al tomar la foto, puedes manejarlo aquí.
                      print(e);
                    }
                  }
                },
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: CameraPreview(controller!),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 80.0,
                        height: 80.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.red,
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (detectedColor != null)
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 100.0,
                      height: 30.0,
                      color: detectedColor,
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'Color Detectado: $colorName',
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    ),
                    Text(
                      'Código Hex: #$hexColorCode',
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    ),
    );
  }
}