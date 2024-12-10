import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_app_flutter/src/core/utils/profile_notifier.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class EditProfilePage extends StatefulWidget {
  final String username;
  final String email;
  final String birthday;
  final String country;

  const EditProfilePage({
    Key? key,
    required this.username,
    required this.email,
    required this.birthday,
    required this.country,
  }) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController birthdayController;
  late TextEditingController countryController;
  late TextEditingController passwordController;
  bool isPasswordVisible = false;

  File? _profileImage;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController(text: widget.username);
    emailController = TextEditingController(text: widget.email);
    birthdayController = TextEditingController(text: widget.birthday);
    countryController = TextEditingController(text: widget.country);
    passwordController = TextEditingController();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final profileImagePath = path.join(directory.path, 'profile_image.png');
      final file = File(profileImagePath);

      if (await file.exists()) {
        if (mounted) {
          setState(() {
            _profileImage = file;
          });
        }
      }
    } catch (e) {
      print('Error loading profile image: $e');
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      try {
        final directory = await getApplicationDocumentsDirectory();
        final profileImagePath = path.join(directory.path, 'profile_image.png');

        final newImage = File(pickedFile.path);
        
        await newImage.copy(profileImagePath);

        if (mounted) {
          setState(() {
            _profileImage = newImage;
          });
        }
      } catch (e) {
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Error'),
              content: const Text('Failed to update the profile picture. Please try again.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      }
    }
  }

  Future<void> _saveChanges() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // Save profile image locally if it exists
        if (_profileImage != null) {
          final directory = await getApplicationDocumentsDirectory();
          final profileImagePath = path.join(directory.path, 'profile_image.png');
          
          // Create a copy of the image
          final savedImage = await _profileImage!.copy(profileImagePath);
          
          // Update the state with the saved image
          if (mounted) {
            setState(() {
              _profileImage = savedImage;
            });
          }
        }


        if (emailController.text.trim() != widget.email) {
          await currentUser.updateEmail(emailController.text.trim());
        }

        if (passwordController.text.trim().isNotEmpty) {
          await currentUser.updatePassword(passwordController.text.trim());
        }

        await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).update({
          'first_name': usernameController.text.trim().split(' ').first,
          'last_name': usernameController.text.trim().split(' ').length > 1
              ? usernameController.text.trim().split(' ').sublist(1).join(' ')
              : '',
          'email': emailController.text.trim(),
          'password': passwordController.text.trim(),
          'date_of_birth': birthdayController.text.trim(),
          'country': countryController.text.trim(),
        });
      }
      profileNotifier.refresh();
      Navigator.pop(context, {
        'username': usernameController.text.trim(),
        'email': emailController.text.trim(),
        'birthday': birthdayController.text.trim(),
        'country': countryController.text.trim(),
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 60,
                backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                child: _profileImage == null
                    ? const Icon(
                        Icons.camera_alt,
                        size: 50,
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: passwordController,
              obscureText: !isPasswordVisible, // Toggle visibility based on the state
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible; // Toggle visibility
                    });
                  },
                ),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: birthdayController,
              decoration: const InputDecoration(
                labelText: 'Date of Birth',
                prefixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(),
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  setState(() {
                    birthdayController.text =
                        "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                  });
                }
              },
            ),
            const SizedBox(height: 15),
            TextField(
              controller: countryController,
              decoration: const InputDecoration(
                labelText: 'Country',
                prefixIcon: Icon(Icons.flag),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _saveChanges,
              child: const Text('Save Changes', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: const StadiumBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
