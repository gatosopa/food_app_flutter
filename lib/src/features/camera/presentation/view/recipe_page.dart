import 'package:flutter/material.dart';
import '../../data/models/recipe_model.dart';
import 'widgets/recipe_card.dart';
import 'available_ingredient_page.dart';
import 'needed_ingredient_page.dart';
import 'dart:convert'; // Adjust the path as per your project structure

// Function to parse recipes from JSON
List<Recipe> parseRecipes(String jsonData) {
  final data = jsonDecode(jsonData);
  if (data is List) {
    return data.map((recipe) => Recipe.fromJson(recipe)).toList();
  } else {
    throw Exception('Invalid JSON format for recipes');
  }
}

// Helper method to convert List<String> to List<Map<String, dynamic>>
List<Map<String, dynamic>> mapIngredients(List<String> ingredients) {
  return ingredients
      .map((ingredient) => {
            "type": "Ingredient",
            "name": ingredient,
            "amount": "-", // Placeholder amount
          })
      .toList();
}

class RecipePage extends StatelessWidget {
  final String jsonData;

  RecipePage({required this.jsonData});

  @override
  Widget build(BuildContext context) {
    final recipes = parseRecipes(jsonData); // Parse the JSON data to recipes
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
                    // Navigate to the AvailableIngredientPage on tap
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AvailableIngredientPage(
                          availableIngredients:
                              mapIngredients(recipe.existingIngredients),
                        ),
                      ),
                    );
                  },
                  child: RecipeCard(recipe: recipe),
                );
              },
            ),
    );
  }
}
