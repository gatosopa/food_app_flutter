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
    if (!mounted) return;
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
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Close Button
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.close, color: Colors.black),
                iconSize: 30,
              ),
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
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(85, 0, 0, 0),
      ),
      body: BlocProvider(
        create: (_) => _cameraCubit,
        child: BlocListener<CameraCubit, CameraState>(
          listener: (context, state) {
            if (state is CameraUploadCompleted) {
              final ingredients = state.response != null &&
                      state.response['message'] != null &&
                      state.response['message']['ingredients'] != null
                  ? state.response['message']['ingredients']
                  : []; // Default to empty list if missing

              final response = {'ingredients': ingredients};

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditablePage(
                    jsonData: jsonEncode(response),
                  ),
                ),
              );
            } else if (state is CameraError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: CameraView(
            cameraPreview: _cameraCubit.controller != null
                ? CameraPreview(_cameraCubit.controller!)
                : const SizedBox(),
            onTakePicture: () async {
              await _cameraCubit.takePicture();
              if (_cameraCubit.capturedImage != null) {
                _showImagePopup(context, File(_cameraCubit.capturedImage!.path));
              }
            },
            onPickImage: () async {
              await _cameraCubit.pickImageFromGallery();
              if (_cameraCubit.galleryImage != null) {
                _showImagePopup(context, _cameraCubit.galleryImage!);
              }
            },
          ),
        ),
      ),
    );
  }
}
