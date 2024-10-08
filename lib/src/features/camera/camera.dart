import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import image_picker for picking images from gallery
import 'package:gal/gal.dart'; // Import gal package for saving images to the gallery

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
  File? _galleryImage;
  final ImagePicker _picker = ImagePicker(); // Instantiate ImagePicker for gallery access

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
        // Handle camera errors
      }
    });
  }

  Future<void> _takePicture() async {
    if (!_controller.value.isInitialized) {
      return;
    }

    try {
      // Capture the image
      XFile image = await _controller.takePicture();

      // Save the image directly to the gallery using Gal
      await Gal.putImage(image.path);

      setState(() {
        _capturedImage = image;
      });

      print("Image saved to gallery: ${image.path}");
    } catch (e) {
      print('Error: $e');
    }
  }

  // Method to pick an image from the gallery
  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _galleryImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
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
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera and Gallery'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: CameraPreview(_controller),
          ),
          if (_capturedImage != null)
            Expanded(
              flex: 1,
              child: Image.file(File(_capturedImage!.path)),
            ),
          if (_galleryImage != null)
            Expanded(
              flex: 1,
              child: Image.file(_galleryImage!), // Display selected gallery image
            ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _takePicture,
            child: const Icon(Icons.camera),
            tooltip: 'Take a picture',
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _pickImageFromGallery,
            child: const Icon(Icons.photo),
            tooltip: 'Pick from gallery',
          ),
        ],
      ),
    );
  }
}
