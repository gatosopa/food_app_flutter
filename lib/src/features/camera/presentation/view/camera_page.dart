import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:camera/camera.dart';
import 'camera_view.dart';
import '../viewmodel/camera_cubit.dart';
import '../../data/repositories/camera_repository.dart';
import 'editable_page.dart';
import '../viewmodel/camera_state.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late final CameraCubit _cameraCubit;

  @override
  void initState() {
    super.initState();
    _cameraCubit = CameraCubit(cameraRepository: CameraRepository());
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    await _cameraCubit.initializeCamera();
    setState(() {});
  }

  @override
  void dispose() {
    _cameraCubit.close();
    super.dispose();
  }

  void _showImagePopup(BuildContext parentContext, File imageFile) {
    showDialog(
      context: parentContext,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Display the image
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.file(
                  imageFile,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 10),

              // Upload Button
              ElevatedButton.icon(
                onPressed: () async {
                  Navigator.of(context).pop(); // Close the popup
                  await _cameraCubit.uploadImage(imageFile);
                  ScaffoldMessenger.of(parentContext).showSnackBar(
                    const SnackBar(content: Text('Image uploaded successfully!')),
                  );
                },
                icon: const Icon(Icons.upload, color: Colors.white),
                label: const Text('Upload Image'),
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(color: Colors.white),
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_cameraCubit.isCameraInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black, // Black background for the app bar
        elevation: 0, // Remove the app bar shadow
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 5.0), // Adjust position
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.red, size: 28), // Red back arrow
            onPressed: () {
              Navigator.pop(context); // Navigate back
            },
          ),
        ),
      ),
      body: BlocProvider(
        create: (_) => _cameraCubit,
        child: BlocListener<CameraCubit, CameraState>(
          listener: (context, state) {
            if (state is CameraImageSelected) {
              _showImagePopup(context, state.image);
            } else if (state is CameraUploadCompleted) {
              // Debugging: Log the response
              print('CameraUploadCompleted: ${state.response}');
              // Check if 'ingredients' exist in response
              final ingredients = state.response['ingredients'] ?? [];
              if (ingredients.isEmpty) {
                print('No ingredients found in response.');
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditablePage(
                    jsonData: jsonEncode(state.response),
                  ),
                ),
              );
            } else if (state is CameraError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: Column(
            children: [
              // Camera view
              Expanded(
                child: CameraView(
                  cameraPreview: CameraPreview(_cameraCubit.controller!),
                  onTakePicture: _cameraCubit.takePicture,
                  onPickImage: _cameraCubit.pickImageFromGallery,
                ),
              ),
              // Bottom black bar with camera and gallery buttons
              Container(
                color: Colors.black,
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: _cameraCubit.pickImageFromGallery,
                      icon: const Icon(Icons.image, color: Colors.white, size: 30),
                    ),
                    GestureDetector(
                      onTap: _cameraCubit.takePicture,
                      child: const CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 30,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Add functionality to switch the camera
                      },
                      icon: const Icon(Icons.switch_camera, color: Colors.white, size: 30),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
