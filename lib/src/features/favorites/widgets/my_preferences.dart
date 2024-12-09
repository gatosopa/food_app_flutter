import 'package:flutter/material.dart';
import 'package:food_app_flutter/src/core/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io'; 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class MyPreferences extends StatefulWidget {
  const MyPreferences({super.key});

  @override
  State<MyPreferences> createState() => _MyPreferencesState();
}

class _MyPreferencesState extends State<MyPreferences> {
  String displayName = "Loading..."; // Default placeholder name
  File? profileImage;

  @override
  void initState() {
    super.initState();
    _fetchUserName();
    _loadProfileImage();
  }

  Future<void> _fetchUserName() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // Fetch user details from Firestore
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            displayName = userDoc.data()?['first_name'] ?? "User"; // Use 'first_name' field
          });
        } else {
          setState(() {
            displayName = "User";
          });
        }
      }
    } catch (e) {
      setState(() {
        displayName = "Error";
      });
      print("Error fetching user name: $e");
    }
  }
  Future<void> _loadProfileImage() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final profileImagePath = path.join(directory.path, 'profile_image.png');
      final file = File(profileImagePath);

      if (await file.exists()) {
        setState(() {
          profileImage = file;
        });
      }
    } catch (e) {
      print("Error loading profile image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage:
                      profileImage != null ? FileImage(profileImage!) : AssetImage(Constants.defaultProfilePhoto) as ImageProvider,
                  child: profileImage == null
                      ? const Icon(
                          Icons.camera_alt,
                          size: 50,
                        )
                      : null,
          ),
          const SizedBox(width: 16.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                displayName, // Display the fetched name
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                'My Preferences',
                style: TextStyle(
                  fontSize: 14,
                  color: Constants.primaryColor,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              color: Constants.primaryColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Icon(
              Icons.arrow_forward,
              color: Constants.secondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
