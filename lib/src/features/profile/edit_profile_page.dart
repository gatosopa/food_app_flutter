import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  bool isPasswordVisible = false; // To toggle password visibility

  @override
  void initState() {
    super.initState();
    // Initialize controllers with passed data
    usernameController = TextEditingController(text: widget.username);
    emailController = TextEditingController(text: widget.email);
    birthdayController = TextEditingController(text: widget.birthday);
    countryController = TextEditingController(text: widget.country);
    passwordController = TextEditingController();

    _fetchPassword(); // Fetch the real password from Firestore
  }

  Future<void> _fetchPassword() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            passwordController.text = userDoc['password'] ?? '';
          });
        }
      }
    } catch (e) {
      print("Error fetching password: $e");
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    birthdayController.dispose();
    countryController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // Update the email in Firebase Auth if it has changed
        if (emailController.text.trim() != widget.email) {
          await currentUser.updateEmail(emailController.text.trim());
        }

        // Update the password in Firebase Auth if it has been changed
        if (passwordController.text.trim().isNotEmpty) {
          await currentUser.updatePassword(passwordController.text.trim());
        }

        // Update Firestore document
        await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).update({
          'first_name': usernameController.text.trim().split(' ').first,
          'last_name': usernameController.text.trim().split(' ').length > 1 ? usernameController.text.trim().split(' ').sublist(1).join(' ') : '',
          'email': emailController.text.trim(),
          'password': passwordController.text.trim(),
          'date_of_birth': birthdayController.text.trim(),
          'country': countryController.text.trim(),
        });
      }

      // Return updated data to ProfilePage
      Navigator.pop(context, {
        'username': usernameController.text.trim(),
        'email': emailController.text.trim(),
        'birthday': birthdayController.text.trim(),
        'country': countryController.text.trim(),
      });
    } catch (e) {
      // Show an error dialog if updating fails
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
            // Username
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            // Email
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            // Password
            TextField(
              controller: passwordController,
              obscureText: !isPasswordVisible, // Toggle visibility
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
            // Birthday
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
            // Country
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
              child: const Text(
                'Save Changes',
                style: TextStyle(color: Colors.white),
              ),
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
