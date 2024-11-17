import 'dart:io';
import 'package:flutter/material.dart';
import 'package:food_app_flutter/src/core/shapes/circular_container.dart';

class CameraView extends StatefulWidget {
  const CameraView({
    Key? key,
    required this.cameraPreview,
    required this.onTakePicture,
    required this.onPickImage,
  }) : super(key: key);

  final Widget cameraPreview;
  final Future<File?> Function() onTakePicture;
  final Future<File?> Function() onPickImage;

  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  File? capturedImage;
  File? galleryImage;

  void _handleTakePicture() async {
    final image = await widget.onTakePicture();
    if (image != null) {
      setState(() {
        capturedImage = image;
      });
      _showImagePopup(context, image);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to capture image.")),
      );
    }
  }

  void _handlePickImage() async {
    final image = await widget.onPickImage();
    if (image != null) {
      setState(() {
        galleryImage = image;
      });
      _showImagePopup(context, image);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to pick image.")),
      );
    }
  }

  void _showImagePopup(BuildContext context, File imageFile) {
    showDialog(
      context: context,
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
                  ScaffoldMessenger.of(context).showSnackBar(
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
    return Stack(
      alignment: Alignment.center,
      children: [
        // Show camera preview
        widget.cameraPreview,

        // Gallery Access Button
        Positioned(
          bottom: 50,
          left: 20,
          child: GestureDetector(
            onTap: _handlePickImage,
            child: CircularContainer(
              width: 60,
              height: 60,
              radius: 30,
              backgroundColor: Colors.white,
              child: galleryImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.file(
                        galleryImage!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Icon(Icons.photo_library, size: 30, color: Colors.grey),
            ),
          ),
        ),

        // Take Picture Button
        Positioned(
          bottom: 50,
          child: CircularContainer(
            width: 80,
            height: 80,
            radius: 40,
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(
                Icons.camera_alt,
                size: 40,
                color: Colors.black,
              ),
              onPressed: _handleTakePicture,
            ),
          ),
        ),
      ],
    );
  }
}
