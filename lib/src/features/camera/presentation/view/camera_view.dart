// camera_view.dart

import 'dart:io';
import 'package:flutter/material.dart';

class CameraView extends StatelessWidget {
  final File? capturedImage;
  final File? galleryImage;
  final Widget cameraPreview;
  final VoidCallback onTakePicture;
  final VoidCallback onPickImage;
  final VoidCallback onUploadImage;

  const CameraView({
    Key? key,
    required this.cameraPreview,
    required this.onTakePicture,
    required this.onPickImage,
    required this.onUploadImage,
    this.capturedImage,
    this.galleryImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: cameraPreview,
        ),
        if (capturedImage != null)
          Expanded(
            flex: 1,
            child: Image.file(capturedImage!),
          ),
        if (galleryImage != null)
          Expanded(
            flex: 1,
            child: Image.file(galleryImage!),
          ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: onTakePicture,
              child: const Text('Take Picture'),
            ),
            ElevatedButton(
              onPressed: onPickImage,
              child: const Text('Pick from Gallery'),
            ),
            ElevatedButton(
              onPressed: onUploadImage,
              child: const Text('Upload Image'),
            ),
          ],
        ),
      ],
    );
  }
}
