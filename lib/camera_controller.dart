// camera_controller.dart

import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraControllerManager {
  CameraController? controller;
  bool isCameraInitialized = false;

  Future<void> initializeCamera() async {
    final permissionStatus = await Permission.camera.request();

    if (permissionStatus.isGranted) {
      final cameras = await availableCameras();
      final firstCamera = cameras.first;

      controller = CameraController(
        firstCamera,
        ResolutionPreset.high,
      );

      await controller?.initialize();
      isCameraInitialized = true;
    } else {
      // El permiso de la cámara no está otorgado, puedes manejar esta situación aquí
    }
  }

  Future<void> disposeCamera() async {
    controller?.dispose();
  }
}