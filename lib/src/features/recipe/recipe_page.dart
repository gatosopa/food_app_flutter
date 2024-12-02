import 'package:flutter/material.dart';
import '../../models/recipe_model.dart';
import '../camera/presentation/view/widgets/recipe_card.dart';
import '../camera/presentation/view/available_ingredient_page.dart';
import 'dart:convert';
import 'package:food_app_flutter/src/core/constants.dart';
import 'package:food_app_flutter/src/core/widgets/bottom_navigation_bar.dart';
import 'package:food_app_flutter/src/features/favorites/favorites_page.dart';
import 'package:food_app_flutter/src/features/home/home_page.dart';
import 'package:food_app_flutter/src/features/inventory/inventory_page.dart';
import 'package:food_app_flutter/src/features/profile/profile_page.dart';
import 'package:food_app_flutter/src/features/camera/presentation/view/camera_page.dart';
import 'package:page_transition/page_transition.dart';

List<Recipe> parseRecipes(String jsonData) {
  final data = jsonDecode(jsonData);
  if (data is List) {
    return data.map((recipe) => Recipe.fromJson(recipe)).toList();
  } else {
    throw Exception('Invalid JSON format for recipes');
  }
}

class RecipePage extends StatefulWidget {
  final String jsonData;

  const RecipePage({Key? key, required this.jsonData}) : super(key: key);

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  int _bottomNavIndex = -1; // Use -1 to represent the RecipePage itself

  // List of other pages
  final List<Widget> pages = const [
    HomePage(),
    InventoryPage(),
    FavoritesPage(),
    ProfilePage(),
  ];

  Future<bool> _onWillPop() async {
    if (_bottomNavIndex != -1) {
      // If on a different page, return to RecipePage
      setState(() {
        _bottomNavIndex = -1;
      });
      return false; // Prevent default back navigation
    }
    return true; // Allow default behavior (e.g., exit app)
  }

  @override
  Widget build(BuildContext context) {
    final recipes = parseRecipes(widget.jsonData);

    // RecipePage content
    final recipePageContent = recipes.isEmpty
        ? const Center(
            child: Text(
              'No recipes available',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          )
        : ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AvailableIngredientPage(
                        availableIngredients: recipe.existingIngredients
                            .map((ingredient) => {'name': ingredient})
                            .toList(),
                      ),
                    ),
                  );
                },
                child: RecipeCard(
                  recipe: recipe,
                ),
              );
            },
          );

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: _bottomNavIndex == -1
            ? recipePageContent // Show RecipePage content if index is -1
            : IndexedStack(
                index: _bottomNavIndex, // Adjust index for pages
                children: pages,
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              PageTransition(
                child: const CameraPage(),
                type: PageTransitionType.bottomToTop,
              ),
            );
          },
          shape: const CircleBorder(),
          backgroundColor: Constants.primaryColor,
          child: Image.asset(
            'assets/image/camera_icon_white.png',
            height: 30.0,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: _bottomNavIndex == -1 ? 0 : _bottomNavIndex,
          onTap: (index) {
            setState(() {
              if (index == 0) {
                // Navigate to HomePage
                _bottomNavIndex = 0; // HomePage is at index 1 in `pages`
              } else {
                _bottomNavIndex = index;
              }
            });
          },
        ),
      ),
    );
  }
}
