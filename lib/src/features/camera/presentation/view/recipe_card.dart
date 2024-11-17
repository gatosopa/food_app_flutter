import 'package:flutter/material.dart';
import '../../data/models/recipe_model.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;

  RecipeCard({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              recipe.title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Image.network(recipe.image),
            SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ingredients You Have',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      ...recipe.existingIngredients.map((ingredient) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Text('• $ingredient'),
                          )),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ingredients You Need',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      ...recipe.nonExistingIngredients.map((ingredient) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Text('• $ingredient'),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
