import 'dart:io';
import 'package:flutter/material.dart';

class ImagePopup {
  static void show(BuildContext context, File imageFile, VoidCallback onUpload) {
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
                onPressed: () {
                  Navigator.of(context).pop(); // Close the popup
                  onUpload();
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
            ],
          ),
        );
      },
    );
  }
}
