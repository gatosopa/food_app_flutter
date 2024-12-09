import 'dart:io';
import 'package:flutter/material.dart';
import 'package:food_app_flutter/src/core/constants.dart';
import 'package:food_app_flutter/src/core/containers/section_heading.dart';
import 'package:food_app_flutter/src/core/widgets/food_card.dart';
import 'package:food_app_flutter/src/features/favorites/my_preferences_page.dart';
import 'package:food_app_flutter/src/features/favorites/widgets/my_preferences.dart';
import 'package:food_app_flutter/src/models/food.dart';
import 'package:page_transition/page_transition.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:dio/dio.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  String username = "Loading...";
  String email = "Loading...";
  String dateOfBirth = "Loading...";
  String country = "Loading...";
  File? profileImage;
  List<Food> favoriteRecipes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadProfileImage();
    _fetchFavoriteRecipes();
  }

  Future<void> _fetchFavoriteRecipes() async {
    try {
      // Get the logged-in user's ID
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('firebaseUserId');

      if (userId == null) {
        throw Exception("No user ID found.");
      }

      // Call the backend endpoint
      Dio dio = Dio();
      final response = await dio.get('${Constants.serverIP}/get_fav_recipes/$userId');

      if (response.statusCode == 200) {
        final recipes = response.data['recipes'] as List;

        setState(() {
          favoriteRecipes = recipes.map((recipe) => Food.fromJson(recipe)).toList();
          isLoading = false;
        });
      } else {
        throw Exception("Failed to fetch favorite recipes. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching favorite recipes: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadUserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('firebaseUserId');

      if (userId != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();

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
    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            "Account",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black,
              fontSize: 30,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                child: MypreferencesPage(),
                                type: PageTransitionType.bottomToTop,
                              ),
                            );
                          },
                          child: MyPreferences(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 7.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'My Favorites',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                          ),
                          itemCount: favoriteRecipes.length,
                          itemBuilder: (context, index) {
                            final food = favoriteRecipes[index];
                            return FoodCard(food: food);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
