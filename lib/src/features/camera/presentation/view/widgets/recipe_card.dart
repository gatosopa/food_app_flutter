import 'package:flutter/material.dart';
import 'package:food_app_flutter/src/core/constants.dart';
import 'package:page_transition/page_transition.dart';
import 'package:food_app_flutter/src/features/recipe/detail_page.dart';
import 'package:food_app_flutter/src/features/camera/presentation/view/available_ingredient_page.dart';
import 'package:food_app_flutter/src/features/camera/presentation/view/needed_ingredient_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../data/models/recipe_model.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;

  const RecipeCard({super.key, required this.recipe});

  // Helper method to convert List<String> to List<Map<String, dynamic>>
  List<Map<String, dynamic>> mapIngredients(List<String> ingredients) {
    return ingredients
        .map((ingredient) => {
              "type": "Ingredient",
              "name": ingredient,
              "amount": "-",
            })
        .toList();
  }

  // Function to add recipe ID to user's favorites array
  Future<void> _addToFavorites(int recipeId) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // Handle unauthenticated state
      print("User is not signed in.");
      return;
    }

    try {
      final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);

      // Update the favorites array
      await userDoc.update({
        'favorites': FieldValue.arrayUnion([recipeId]), // Add recipe ID to array
      });

      print("Recipe added to favorites: $recipeId");
    } catch (e) {
      print("Error adding to favorites: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to DetailPage with Recipe object
        Navigator.push(
          context,
          PageTransition(
            child: DetailPage(recipe: recipe),
            type: PageTransitionType.bottomToTop,
          ),
        );
      },
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.only(bottom: 16.0),
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image and Favorite Icon
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.network(
                      recipe.image,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 150,
                          color: Colors.grey[200],
                          child: const Center(
                            child: Icon(
                              Icons.broken_image,
                              color: Colors.grey,
                              size: 50,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        _addToFavorites(recipe.id);
                      },
                      child: const Icon(
                        Icons.favorite_border,
                        color: Colors.white,
                        size: 28.0,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              // Recipe Name and Calories
              Text(
                recipe.title,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                "${recipe.calories} kcal",
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8.0),
              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            child: AvailableIngredientPage(
                              availableIngredients: mapIngredients(recipe.existingIngredients),
                            ),
                            type: PageTransitionType.bottomToTop,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constants.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Center(
                        child: Text(
                          'Available Ingredients',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            child: NeededIngredientPage(
                              neededIngredients: mapIngredients(recipe.nonExistingIngredients),
                            ),
                            type: PageTransitionType.bottomToTop,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Center(
                        child: Text(
                          'Needed Ingredients',
                          style: TextStyle(color: Constants.primaryColor),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
