import 'dart:io';
import 'package:camera/camera.dart';

abstract class CameraState {}

// Initial state before the camera is initialized
class CameraInitial extends CameraState {}

// State when the camera is successfully initialized
class CameraInitialized extends CameraState {
  final CameraController controller;
  CameraInitialized(this.controller);
}

// State when an image is captured from the camera
class CameraPictureTaken extends CameraState {
  final XFile image;
  CameraPictureTaken(this.image);
}

// State when an image is selected from the gallery
class CameraGalleryImageSelected extends CameraState {
  final File image;
  CameraGalleryImageSelected(this.image);
}

// State when an image is successfully uploaded
class CameraUploadCompleted extends CameraState {
  final Map<String, dynamic> response;
  CameraUploadCompleted(this.response);
}

// State for any error that occurs
class CameraError extends CameraState {
  final String message;
  CameraError(this.message);
}
