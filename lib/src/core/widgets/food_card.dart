import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_app_flutter/src/core/constants.dart';
import 'package:food_app_flutter/src/models/food.dart';
import 'package:page_transition/page_transition.dart';
import 'package:food_app_flutter/src/features/recipe/detail_page.dart';
import 'package:food_app_flutter/src/models/recipe_model.dart';

class FoodCard extends StatelessWidget {
  const FoodCard({super.key, required this.food, required this.recipe, required this.onFavoriteUpdated});
  final Food food;
  final Recipe recipe;
  final VoidCallback onFavoriteUpdated;

  Future<void> _updateFavoriteList(BuildContext context) async {
    try {
      // Get the currently logged-in user's ID
      String? userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null) {
        throw Exception("No user is currently logged in.");
      }

      // Update Firestore: Remove the food ID from the favorites list
      final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
      await userDoc.update({
        'favorites': FieldValue.arrayRemove([food.foodId]) // Remove this item from the favorites list
      });

      // Call the callback to update the UI
      onFavoriteUpdated();
    } catch (e) {
      print("Error updating favorite list: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update favorites')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          PageTransition(
            child: DetailPage(recipe: recipe),
            type: PageTransitionType.bottomToTop,
          ),
        );
      },
      child:  Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 4,
          child: Container(
            width: 160,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // Ensures the height adjusts to fit content
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Image.network(
                        food.imageUrl,
                        height: 80,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.broken_image, size: 80, color: Colors.grey);
                        },
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () {
                          _updateFavoriteList(context);
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Icon(
                              Icons.favorite,
                              color: Constants.primaryColor,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Text(
                  food.foodName,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4.0),
                
              ],
            ),
          ),
        ),
      
    );
  }
}
