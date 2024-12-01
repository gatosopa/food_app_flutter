import 'package:flutter/material.dart';
import '../../data/models/recipe_model.dart';
import 'widgets/recipe_card.dart';
import 'available_ingredient_page.dart';
import 'needed_ingredient_page.dart';
import 'dart:convert';

List<Recipe> parseRecipes(String jsonData) {
  final data = jsonDecode(jsonData);
  if (data is List) {
    return data.map((recipe) => Recipe.fromJson(recipe)).toList();
  } else {
    throw Exception('Invalid JSON format for recipes');
  }
}

class RecipePage extends StatelessWidget {
  final String jsonData;

  RecipePage({required this.jsonData}) {
    // Log the received JSON data
    print("Received JSON from backend:");
    print(jsonData);
  }

  @override
  Widget build(BuildContext context) {
    final recipes = parseRecipes(jsonData);

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
    );
  }
}
