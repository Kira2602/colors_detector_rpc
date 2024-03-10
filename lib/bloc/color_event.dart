import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

abstract class ColorEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class InitializeCameraEvent extends ColorEvent {}

class TakePictureEvent extends ColorEvent {}

class GetColorAtPositionEvent extends ColorEvent {
  final int centerX;
  final int centerY;
  final int radius;
  final XFile imageFile; // Aquí añadimos el XFile
  GetColorAtPositionEvent(this.centerX, this.centerY, this.radius, this.imageFile);
  @override
  List<Object> get props => [centerX, centerY, radius, imageFile];
}

class GetColorNameFromAPIEvent extends ColorEvent {
  final Color color;

  GetColorNameFromAPIEvent(this.color);

  @override
  List<Object> get props => [color];
}