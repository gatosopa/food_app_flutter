import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:camera/camera.dart';
import 'camera_view.dart';
import '../viewmodel/camera_cubit.dart';
import '../../data/repositories/camera_repository.dart';
import 'editable_page.dart';
import '../viewmodel/camera_state.dart'; // Adjust path as needed
import 'dart:convert';



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

Future<void> _uploadImage() async {
  File? image = _cameraCubit.capturedImage != null
      ? File(_cameraCubit.capturedImage!.path)
      : _cameraCubit.galleryImage;

  if (image != null) {
    await _cameraCubit.uploadImage(image);
  }
}


  @override
  void dispose() {
    _cameraCubit.close();
    super.dispose();
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
        title: const Text('Camera and Gallery'),
      ),
      body: BlocProvider(
        create: (_) => _cameraCubit,
        child: BlocListener<CameraCubit, CameraState>(
  listener: (context, state) {
    if (state is CameraUploadCompleted) {
      // Print the response to verify its structure
      print('CameraUploadCompleted response: ${state.response}');
      
      // Access the ingredients list within the nested 'message' key
      final ingredients = state.response != null &&
                         state.response['message'] != null &&
                         state.response['message']['ingredients'] != null
          ? state.response['message']['ingredients']
          : []; // Default to an empty list if any key is missing

      final response = {'ingredients': ingredients}; // Structure data for EditablePage

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
    capturedImage: _cameraCubit.capturedImage != null
        ? File(_cameraCubit.capturedImage!.path)
        : null,
    galleryImage: _cameraCubit.galleryImage,
    onTakePicture: () async {
      await _cameraCubit.takePicture();
      if (mounted) setState(() {});
    },
    onPickImage: () async {
      await _cameraCubit.pickImageFromGallery();
      if (mounted) setState(() {});
    },
    onUploadImage: _uploadImage,
  ),
)
      ));
  }
}
