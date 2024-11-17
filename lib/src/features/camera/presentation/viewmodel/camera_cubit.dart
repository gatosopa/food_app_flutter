import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import '../../data/repositories/camera_repository.dart';
import 'camera_state.dart';
import 'package:gal/gal.dart';

class CameraCubit extends Cubit<CameraState> {
  final CameraRepository cameraRepository;
  CameraController? _controller;
  XFile? capturedImage;
  File? galleryImage;

  CameraCubit({required this.cameraRepository}) : super(CameraInitial());

  CameraController? get controller => _controller;

  // Initialize the camera
  Future<void> initializeCamera() async {
    try {
      final cameras = await availableCameras();
      _controller = CameraController(cameras[0], ResolutionPreset.max);
      await _controller!.initialize();
      emit(CameraInitialized(_controller!));
    } catch (e) {
      emit(CameraError('Failed to initialize camera: $e'));
    }
  }

  bool get isCameraInitialized => _controller?.value.isInitialized ?? false;


  // Capture a picture from the camera
Future<void> takePicture() async {
  if (_controller?.value.isInitialized != true) {
    emit(CameraError('Camera is not initialized.'));
    return;
  }

  try {
    final XFile image = await _controller!.takePicture();
    capturedImage = image;

    // Save the image to the gallery using Gal
    await Gal.putImage(image.path);

    emit(CameraPictureTaken(image));
  } catch (e) {
    emit(CameraError('Failed to capture or save image: $e'));
  }
}


  // Select an image from the gallery
  Future<void> pickImageFromGallery() async {
    try {
      final File? pickedFile = await (cameraRepository.pickImageFromGallery());
      if (pickedFile != null) {
        galleryImage = File(pickedFile.path);
        emit(CameraGalleryImageSelected(galleryImage!));
      } else {
        emit(CameraError('No image selected from gallery.'));
      }
    } catch (e) {
      emit(CameraError('Failed to pick image from gallery: $e'));
    }
  }

  // Upload the image to the server
  Future<void> uploadImage(File image) async {
    try {
      final response = await cameraRepository.uploadImage(image);
      emit(CameraUploadCompleted(response));
    } catch (e) {
      emit(CameraError('Failed to upload image: $e'));
    }
  }

  @override
  Future<void> close() {
    _controller?.dispose();
    return super.close();
  }
}
