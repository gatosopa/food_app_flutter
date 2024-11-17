import 'dart:io';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import '../../../../core/constants.dart';

class CameraRepository {
  final ImagePicker _picker = ImagePicker();
  CameraController? _controller;
  
  Future<CameraController?> initializeCamera() async {
    final cameras = await availableCameras();
    _controller = CameraController(cameras[0], ResolutionPreset.max);
    await _controller!.initialize();
    return _controller;
  }

  Future<XFile?> takePicture() async {
    if (_controller?.value.isInitialized == true) {
      try {
        return await _controller!.takePicture();
      } catch (e) {
        print('Error taking picture: $e');
      }
    }
    return null;
  }

  Future<File?> pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      return pickedFile != null ? File(pickedFile.path) : null;
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }

Future<Map<String, dynamic>> uploadImage(File image) async {
  try {
    final dio = Dio();
    final fileName = image.path.split('/').last;

    // Ensure the image is being added correctly
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        image.path,
        filename: fileName,
      ),
    });

    print('Uploading image: ${image.path}'); // Log image path for debugging

    final response = await dio.post(
      '${Constants.serverIP}/upload', // Update this with the correct server endpoint
      data: formData,
    );

    print('Server response status: ${response.statusCode}'); // Log server response status

    if (response.statusCode == 200) {
      print('Server response data: ${response.data}'); // Log response data
      if (response.data is String) {
        return jsonDecode(response.data);
      } else if (response.data is Map<String, dynamic>) {
        return response.data;
      } else {
        throw Exception('Unexpected server response format.');
      }
    } else {
      throw Exception('Server responded with status: ${response.statusCode}');
    }
  } catch (e) {
    print('Error during upload: $e');
    throw Exception('Failed to upload image: $e');
  }
}

  void dispose() {
    _controller?.dispose();
  }
}
