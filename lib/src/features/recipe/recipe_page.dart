import 'package:flutter/material.dart';
import '../camera/data/models/recipe_model.dart';
import '../camera/presentation/view/widgets/recipe_card.dart';
import '../camera/presentation/view/available_ingredient_page.dart';
import '../camera/presentation/view/needed_ingredient_page.dart';
import 'dart:convert';
import 'package:food_app_flutter/src/core/constants.dart';
import 'package:food_app_flutter/src/core/widgets/bottom_navigation_bar.dart';

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

  RecipePage({required this.jsonData}) {
    // Log the received JSON data
    print("Received JSON from backend:");
    print(jsonData);
  }

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  int _bottomNavIndex = 0;

  // List of pages for navigation
  final List<Widget> pages = const [
    Placeholder(), // Replace with actual HomePage widget
    Placeholder(), // Replace with actual InventoryPage widget
    Placeholder(), // Replace with actual FavoritesPage widget
    Placeholder(), // Replace with actual ProfilePage widget
  ];

  @override
  Widget build(BuildContext context) {
    final recipes = parseRecipes(widget.jsonData);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipes'),
      ),
      body: recipes.isEmpty
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
                    // Log the JSON data being sent for the specific recipe
                    final ingredientJson = jsonEncode(recipe.existingIngredients
                        .map((ingredient) => {'name': ingredient})
                        .toList());

                    print("JSON being sent to AvailableIngredientPage:");
                    print(ingredientJson);

                    // Navigate to AvailableIngredientPage
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
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add CameraPage navigation logic here
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
        currentIndex: _bottomNavIndex,
        onTap: (index) {
          setState(() {
            _bottomNavIndex = index;
          });
          if (index < pages.length) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => pages[index]),
            );
          }
        },
      ),
    );
  }
}
