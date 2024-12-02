import 'package:flutter/material.dart';
import 'package:food_app_flutter/src/core/constants.dart';
import 'package:food_app_flutter/src/features/recipe/detail_page.dart';
import 'package:food_app_flutter/src/models/food.dart';
import 'package:page_transition/page_transition.dart';
import 'package:food_app_flutter/src/models/recipe_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RoundedImage extends StatefulWidget {
  const RoundedImage({
    super.key,
    this.width,
    this.height,
    this.applyImageRadius = true,
    this.border,
    this.backgroundColor = Colors.transparent,
    this.fit = BoxFit.cover,
    this.padding,
    this.isNetworkImage = false,
    this.onPressed,
    this.borderRadius = 20,
    required this.food,
  });

  final double? width, height;
  final Food food;
  final bool applyImageRadius;
  final BoxBorder? border;
  final Color backgroundColor;
  final BoxFit? fit;
  final EdgeInsetsGeometry? padding;
  final bool isNetworkImage;
  final VoidCallback? onPressed;
  final double borderRadius;

  @override
  _RoundedImageState createState() => _RoundedImageState();
}

class _RoundedImageState extends State<RoundedImage> with SingleTickerProviderStateMixin {
  bool isFavorited = false;
  bool isAnimating = false; // To handle the heart animation

  @override
  void initState() {
    super.initState();
    isFavorited = widget.food.isFavorated; // Initialize the favorite state
  }

  // Method to toggle favorite state with Firestore update
  void toggleFavorite() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // Handle unauthenticated state
      print("User is not signed in.");
      return;
    }

    setState(() {
      isFavorited = !isFavorited;
      isAnimating = true;
    });

    // Wait for the animation duration
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {
      isAnimating = false;
    });

    // Update the Food model state
    widget.food.isFavorated = isFavorited;

    // Firestore update logic
    try {
      final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);

      if (isFavorited) {
        // Add to favorites
        await userDoc.update({
          'favorites': FieldValue.arrayUnion([widget.food.foodId]),
        });
        print("Added to favorites: ${widget.food.foodId}");
      } else {
        // Remove from favorites
        await userDoc.update({
          'favorites': FieldValue.arrayRemove([widget.food.foodId]),
        });
        print("Removed from favorites: ${widget.food.foodId}");
      }
    } catch (e) {
      print("Error updating favorites: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final recipe = Recipe(
          id: widget.food.foodId,
          title: widget.food.foodName,
          image: widget.food.imageUrl,
          calories: widget.food.foodCalories,
          existingIngredients: [], // Populate appropriately
          nonExistingIngredients: [], // Populate appropriately
          nutrients: [], // Populate appropriately
          steps: widget.food.steps,
          cuisineType: 'Unknown', // Populate appropriately
          cookingTime: null, // Populate appropriately
        );

        Navigator.push(
          context,
          PageTransition(
            child: DetailPage(recipe: recipe),
            type: PageTransitionType.bottomToTop,
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: widget.width ?? double.infinity,
        height: widget.height ?? 400, // Constrain the height
        margin: const EdgeInsets.only(bottom: 5),
        padding: widget.padding,
        decoration: BoxDecoration(
          border: widget.border,
          color: Colors.white,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  clipBehavior: Clip.hardEdge,
                  height: 300, // Constrain image height
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                  ),
                  child: Image.network(
                    widget.food.imageUrl,
                    fit: widget.fit ?? BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(
                            Icons.broken_image,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  widget.food.foodName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis, // Handle long text gracefully
                  maxLines: 1,
                ),
              ],
            ),
            Positioned(
              top: 20,
              right: 20,
              child: GestureDetector(
                onTap: toggleFavorite,
                child: AnimatedScale(
                  scale: isAnimating ? 1.5 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(
                      isFavorited ? Icons.favorite : Icons.favorite_border,
                      color: Constants.primaryColor,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
