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

    // Use FormData with a 'file' key, similar to the requests library
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        image.path,
        filename: fileName,
      ),
    });

    final response = await dio.post(
      '${Constants.serverIP}/upload', // Upload image url route
      data: formData,
    );

    if (response.statusCode == 200) {
      try {
        return jsonDecode(response.data);
      } catch (e) {
        return {'message': response.data};
      }
    } else {
      print('Upload failed: ${response.statusCode}');
    }
  } catch (e) {
    print('Error uploading image: $e');
  }
  return {};
}


  void dispose() {
    _controller?.dispose();
  }
}
