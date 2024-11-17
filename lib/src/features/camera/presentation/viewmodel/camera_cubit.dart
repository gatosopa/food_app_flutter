import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import '../../data/repositories/camera_repository.dart';
import 'camera_state.dart';
import 'package:gal/gal.dart';
import 'package:image_picker/image_picker.dart';

class CameraCubit extends Cubit<CameraState> {
  final CameraRepository cameraRepository;
  CameraController? _controller;

  CameraCubit({required this.cameraRepository}) : super(CameraInitial());

  CameraController? get controller => _controller;

  // Initialize the camera
  Future<void> initializeCamera() async {
    try {
      final cameras = await availableCameras();
      _controller = CameraController(cameras.first, ResolutionPreset.max);
      await _controller!.initialize();
      emit(CameraInitialized(_controller!));
    } catch (e) {
      emit(CameraError('Failed to initialize camera: $e'));
    }
  }

  bool get isCameraInitialized => _controller?.value.isInitialized ?? false;

  // Capture an image from the camera
  Future<void> takePicture() async {
    if (!isCameraInitialized) {
      emit(CameraError('Camera is not initialized.'));
      return;
    }

    try {
      final XFile image = await _controller!.takePicture();
      final file = File(image.path);

      // Save the image to the gallery
      await Gal.putImage(image.path);

      emit(CameraImageSelected(file, source: ImageSource.camera));
    } catch (e) {
      emit(CameraError('Failed to capture image: $e'));
    }
  }

  // Select an image from the gallery
  Future<void> pickImageFromGallery() async {
    try {
      final File? pickedFile = await cameraRepository.pickImageFromGallery();
      if (pickedFile != null) {
        emit(CameraImageSelected(pickedFile, source: ImageSource.gallery));
      } else {
        emit(CameraError('No image selected.'));
      }
    } catch (e) {
      emit(CameraError('Failed to pick image: $e'));
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
