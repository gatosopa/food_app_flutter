import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:food_app_flutter/src/features/onboarding/onboarding_page.dart';
import 'package:food_app_flutter/src/core/root_page.dart';
import 'package:dio/dio.dart';
import 'package:food_app_flutter/src/core/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_app_flutter/src/models/food.dart';  
import 'package:food_app_flutter/src/models/recipe_model.dart';
import 'package:food_app_flutter/src/core/utils/food_storage.dart';

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
  bool _isLoading = true;
  String? _userId;
  List<String> _includeTags = [];

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _checkLoginStatus();
    await fetchPreferences(); // Fetch user preferences
    await _fetchDailyRecipes(); // Fetch recipes on startup
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
        
        setState(() {
          _includeTags = savedPreferences.entries
            .where((entry) => entry.value)
            .map((entry) => entry.key.toLowerCase())
            .toList();
        });
      }
    } catch (e) {
      print("Error fetching preferences: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error fetching preferences.")),
    );
  }
}

  Future<void> _fetchDailyRecipes() async {
    try {
      Dio dio = Dio();
      final requestData = {
        'include_tags': _includeTags,
        'number': 2,
      };

      print("Sending request with data: $requestData");
      
      final response = await dio.post(
        '${Constants.serverIP}/get_daily_recipes',
        data: requestData,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        final recipes = response.data; // Assumes recipes are returned as JSON
        print("Fetched recipes: $recipes");

      // Ensure 'recipes' exists in the response and is a List
      if (recipes is Map<String, dynamic> && recipes['recipe_info'] is List) {
        print("testing");
        final recipeList = recipes['recipe_info'] as List<dynamic>;

        // Convert recipes to Food list
        List<Food> foodList = recipeList.map((recipe) {
          Recipe recipeObj = Recipe.fromJson(recipe);
          return recipeObj.toFood();
        }).toList();

        // Save the Food list locally
        await FoodStorage.saveFoodList(foodList);
      }
      } else {
        print("Failed to fetch recipes. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching daily recipes: $e");
    }
  }
    Future<void> _fetchUserId() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null && mounted) {
        setState(() {
          _userId = currentUser.uid;
        });
      }
    } catch (e) {
      print('Error fetching user ID: $e');
    }
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
