import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_app_flutter/src/features/profile/edit_profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:food_app_flutter/src/core/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_app_flutter/src/features/onboarding/onboarding_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String username = "Loading...";
  String email = "Loading...";
  String dateOfBirth = "Loading...";
  String country = "Loading...";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('firebaseUserId');

      if (userId != null) {
        DocumentSnapshot userDoc =
            await FirebaseFirestore.instance.collection('users').doc(userId).get();

        if (userDoc.exists) {
          setState(() {
            username = "${userDoc['first_name'] ?? 'Unknown'} ${userDoc['last_name'] ?? ''}";
            email = userDoc['email'] ?? 'Unknown';
            dateOfBirth = userDoc['date_of_birth'] ?? 'Unknown';
            country = userDoc['country'] ?? 'Unknown';
          });
        } else {
          print("User document does not exist.");
        }
      } else {
        print("No Firebase user ID found in local storage.");
      }
    } catch (e) {
      print("Error loading user data: $e");
    }
  }

  Future<void> _logout(BuildContext context) async {
    // Confirm the logout action
    bool? shouldLogout = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );

    if (shouldLogout ?? false) {
      try {
        // Perform the logout
        await FirebaseAuth.instance.signOut();

        // Clear locally stored data
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.clear();

        // Navigate back to the onboarding screen
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
          (route) => false, // Remove all previous routes
        );
      } catch (e) {
        // Handle logout error
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Constants.tProfile,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Picture
              SizedBox(
                width: 120,
                height: 120,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset(
                    Constants.profilePhoto,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Username
              Text(
                username,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 20),
              // Email
              TextField(
                enabled: false,
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: const Icon(Icons.email),
                  border: const OutlineInputBorder(),
                ),
                controller: TextEditingController(text: email),
              ),
              const SizedBox(height: 12),
              // Date of Birth
              TextField(
                enabled: false,
                decoration: InputDecoration(
                  labelText: "Date of Birth",
                  prefixIcon: const Icon(Icons.calendar_today),
                  border: const OutlineInputBorder(),
                ),
                controller: TextEditingController(text: dateOfBirth),
              ),
              const SizedBox(height: 12),
              // Country
              TextField(
                enabled: false,
                decoration: InputDecoration(
                  labelText: "Country",
                  prefixIcon: const Icon(Icons.flag),
                  border: const OutlineInputBorder(),
                ),
                controller: TextEditingController(text: country),
              ),
              const SizedBox(height: 20),
              // Edit Profile Button
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () async {
                    final updatedInfo = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfilePage(
                          username: username,
                          email: email,
                          birthday: dateOfBirth,
                          country: country,
                        ),
                      ),
                    );

                    if (updatedInfo != null) {
                      setState(() {
                        username = updatedInfo['username'] ?? username;
                        email = updatedInfo['email'] ?? email;
                        dateOfBirth = updatedInfo['birthday'] ?? dateOfBirth;
                        country = updatedInfo['country'] ?? country;
                      });
                      // Optionally update Firestore here
                    }
                  },
                  child: Text(
                    Constants.tEditProfile,
                    style: TextStyle(color: Constants.backgroundColor),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Constants.primaryColor,
                    side: BorderSide.none,
                    shape: const StadiumBorder(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
