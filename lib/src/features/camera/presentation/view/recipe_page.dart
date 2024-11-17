import 'package:flutter/material.dart';
import '../../data/models/recipe_model.dart';
import '../../../../core/utils/parser.dart';
import 'recipe_card.dart';

class RecipePage extends StatelessWidget {
  final List<Recipe> recipes;

  RecipePage({required String jsonData}) : recipes = parseRecipes(jsonData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipes'),
      ),
      body: recipes.isEmpty
          ? Center(
              child: Text(
                'No recipes available',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : ListView.builder(
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                final recipe = recipes[index];
                return RecipeCard(recipe: recipe);
              },
            ),
    );
  }
}
