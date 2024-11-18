import 'package:flutter/material.dart';

class CameraView extends StatelessWidget {
  const CameraView({
    Key? key,
    required this.cameraPreview,
    required this.onTakePicture,
    required this.onPickImage,
  }) : super(key: key);

  final Widget cameraPreview;
  final Future<void> Function() onTakePicture;
  final Future<void> Function() onPickImage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Camera Preview
        Positioned.fill(child: cameraPreview),
      ],
    );
  }
}
