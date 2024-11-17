import 'dart:io';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';

abstract class CameraState {}

// Initial state before the camera is initialized
class CameraInitial extends CameraState {}

// State when the camera is successfully initialized
class CameraInitialized extends CameraState {
  final CameraController controller;
  CameraInitialized(this.controller);
}

// Unified state for image selection
class CameraImageSelected extends CameraState {
  final File image;
  final ImageSource source; // Indicates the source of the image (camera/gallery)
  CameraImageSelected(this.image, {required this.source});
}

// State when an image is successfully uploaded
class CameraUploadCompleted extends CameraState {
  final Map<String, dynamic> response;
  CameraUploadCompleted(this.response);
}

// State for errors
class CameraError extends CameraState {
  final String message;
  CameraError(this.message);
}
