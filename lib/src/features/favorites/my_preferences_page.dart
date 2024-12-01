import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_app_flutter/src/core/constants.dart';

class MypreferencesPage extends StatefulWidget {
  const MypreferencesPage({super.key});

  @override
  State<MypreferencesPage> createState() => _MypreferencesPageState();
}

class _MypreferencesPageState extends State<MypreferencesPage> {
  // Map to store diet preferences
  Map<String, bool> dietPreferences = {
    'Vegetarian': false,
    'Vegan': false,
    'Gluten-Free': false,
    'Dairy-Free': false,
    'Ketogenic': false,
    'Healthy': false,
    'Sustainable': false,
    'Cheap': false,
  };

  bool isLoading = true; // To handle loading state

  @override
  void initState() {
    super.initState();
    fetchPreferences();
  }

  // Method to fetch preferences from Firestore
  Future<void> fetchPreferences() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User not signed in.");
      }

      final userId = user.uid;

      // Fetch preferences from Firestore
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        final savedPreferences =
            Map<String, bool>.from(data['dietPreferences'] ?? {});

        // Update the local dietPreferences map
        setState(() {
          dietPreferences = {
            ...dietPreferences, // Keep default preferences for missing keys
            ...savedPreferences, // Overwrite with saved preferences
          };
          isLoading = false; // Disable loading
        });
      } else {
        setState(() {
          isLoading = false; // Disable loading even if no data exists
        });
      }
    } catch (e) {
      print("Error fetching preferences: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error fetching preferences.")),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  // Method to handle saving preferences to Firestore
  Future<void> savePreferences() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User not signed in.");
      }

      final userId = user.uid;

      // Save preferences under /users/{userId}
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .set({
            'dietPreferences': dietPreferences,
          }, SetOptions(merge: true)); // Use merge to keep existing data intact

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preferences saved!")),
      );
    } catch (e) {
      print("Error saving preferences: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error saving preferences.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Diet Preferences'),
        centerTitle: true,
        backgroundColor: Constants.primaryColor,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loader if data is loading
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select your dietary preferences:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      children: dietPreferences.keys.map((diet) {
                        return SwitchListTile(
                          title: Text(diet),
                          value: dietPreferences[diet]!,
                          activeColor: Constants.primaryColor,
                          onChanged: (bool value) {
                            setState(() {
                              dietPreferences[diet] = value;
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: savePreferences,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Constants.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      'Save Preferences',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
