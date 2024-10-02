import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

late List<CameraDescription> _cameras;

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _controller;
  bool _isCameraInitialized = false;
  XFile? _capturedImage;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    _controller = CameraController(_cameras[0], ResolutionPreset.max);
    await _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isCameraInitialized = true;
      });
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  Future<void> _takePicture() async {
    if (!_controller.value.isInitialized) {
      // If the controller is not initialized, return early.
      return;
    }

    try {
      // Take the picture
      XFile image = await _controller.takePicture();

      // Get a temporary directory to save the image.
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;
      String imagePath = '$tempPath/${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Save the picture to the temporary directory.
      await image.saveTo(imagePath);

      setState(() {
        _capturedImage = image;
      });
    } catch (e) {
      // Handle errors taking the picture.
      print('Error: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized) {
      return const Center(
        child: CircularProgressIndicator(), // Show loading indicator while camera is initializing.
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: CameraPreview(_controller), // Display the camera preview.
          ),
          if (_capturedImage != null)
            Expanded(
              flex: 1,
              child: Image.file(File(_capturedImage!.path)), // Show the captured image.
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _takePicture,
        child: const Icon(Icons.camera),
      ),
    );
  }
}
