import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';

abstract class ColorState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ColorInitialState extends ColorState {}

class CameraInitializedState extends ColorState {
  final CameraController cameraController;

  CameraInitializedState(this.cameraController);

  @override
  List<Object?> get props => [cameraController];
}

class PictureTakenState extends ColorState {
  final XFile image;

  PictureTakenState(this.image);

  @override
  List<Object?> get props => [image];
}

class ColorDetectedState extends ColorState {
  final Color color;
  final String colorName;

  ColorDetectedState(this.color, this.colorName);

  @override
  List<Object?> get props => [color, colorName];
}