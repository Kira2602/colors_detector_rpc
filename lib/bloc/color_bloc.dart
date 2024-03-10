import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'package:permission_handler/permission_handler.dart';
import '../APIColor.dart';
import 'color_event.dart';
import 'color_state.dart';


class ColorBloc extends Bloc<ColorEvent, ColorState> {
  CameraController? _cameraController;

  ColorBloc() : super(ColorInitialState()) {
    on<InitializeCameraEvent>(_onInitializeCamera);
    on<GetColorAtPositionEvent>(_onGetColorAtPosition);
  }

  Future<void> _onInitializeCamera(InitializeCameraEvent event,
      Emitter<ColorState> emit) async {
    final permissionStatus = await Permission.camera.request();
    if (permissionStatus.isGranted) {
      final cameras = await availableCameras();
      final firstCamera = cameras.first;

      // Configuración del CameraController
      _cameraController = CameraController(
        firstCamera,
        ResolutionPreset.high,
        enableAudio: false, // Asegúrate de que el audio no esté habilitado si no es necesario
        // Otras configuraciones pueden ir aquí
      );

      await _cameraController!.initialize();

      // Aquí puedes verificar y cambiar la configuración de la linterna si es necesario
      if (_cameraController!.value.flashMode != FlashMode.off) {
        await _cameraController!.setFlashMode(FlashMode.off);
      }

      emit(CameraInitializedState(_cameraController!));
    } else {
      // Manejar el caso en que no se otorguen los permisos
    }
  }

  Future<void> _onGetColorAtPosition(GetColorAtPositionEvent event, Emitter<ColorState> emit) async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      final imageBytes = await event.imageFile.readAsBytes();
      final img.Image? decodedImage = img.decodeImage(imageBytes);
      if (decodedImage != null) {
        // Aquí asumimos que queremos el centro de la imagen
        final int centerX = decodedImage.width ~/ 2;
        final int centerY = decodedImage.height ~/ 2;

        // El radio para la detección de color ya viene dado en el evento
        Color averageColor = await getAverageColor(event.imageFile, centerX, centerY, event.radius);
        String colorName = await APIColor.getColorNameFromAPI(averageColor);
        emit(ColorDetectedState(averageColor, colorName));
      }
    }
  }


  Future<Color> getAverageColor(XFile imageFile, int centerX, int centerY, int radius) async {
    final imageBytes = await File(imageFile.path).readAsBytes();
    final img.Image? decodedImage = img.decodeImage(imageBytes);

    if (decodedImage != null) {
      int redTotal = 0, greenTotal = 0, blueTotal = 0;
      int pixelCount = 0;
      int radiusSquared = radius * radius;

      for (int x = max(centerX - radius, 0); x < min(centerX + radius, decodedImage.width); x++) {
        for (int y = max(centerY - radius, 0); y < min(centerY + radius, decodedImage.height); y++) {
          int dx = x - centerX;
          int dy = y - centerY;
          if (dx * dx + dy * dy <= radiusSquared) {
            int pixel = decodedImage.getPixel(x, y);
            redTotal += img.getRed(pixel);
            greenTotal += img.getGreen(pixel);
            blueTotal += img.getBlue(pixel);
            pixelCount++;
          }
        }
      }

      if (pixelCount == 0) return Colors.black;
      return Color.fromRGBO(
        redTotal ~/ pixelCount,
        greenTotal ~/ pixelCount,
        blueTotal ~/ pixelCount,
        1,
      );
    } else {
      return Colors.black;
    }
  }

  img.Image adjustImage(img.Image image) {
    img.adjustColor(image, brightness: 10);
    img.adjustColor(image, saturation: 0.5);
    img.adjustColor(image, contrast: 0.8);

    return image;
  }


  @override
  Future<void> close() {
    _cameraController?.dispose();
    return super.close();
  }
}