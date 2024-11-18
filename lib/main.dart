import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:food_app_flutter/src/features/onboarding/onboarding_page.dart';
import 'package:food_app_flutter/src/core/root_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const FoodApp());
}

class FoodApp extends StatelessWidget {
  const FoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food App',
      home: const RootDecider(), // RootDecider decides where to navigate
      debugShowCheckedModeBanner: false,
    );
  }
}

class RootDecider extends StatefulWidget {
  const RootDecider({super.key});

  @override
  State<RootDecider> createState() => _RootDeciderState();
}

class _RootDeciderState extends State<RootDecider> {
  bool? _isLoggedIn;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if the user is logged in or if they have completed onboarding
    bool hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;
    User? currentUser = FirebaseAuth.instance.currentUser;

    setState(() {
      // If the user is logged in, bypass onboarding
      _isLoggedIn = currentUser != null || hasSeenOnboarding;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoggedIn == null) {
      // Show loading indicator while checking login status
      return const Center(child: CircularProgressIndicator());
    }

    // Navigate based on login status
    return _isLoggedIn! ? const RootPage() : const OnboardingScreen();
  }
}
