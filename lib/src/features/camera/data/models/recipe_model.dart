import 'package:food_app_flutter/src/models/food.dart';

class Recipe {
  final String title;
  final String image;
  final int calories;
  final List<String> existingIngredients;
  final List<String> nonExistingIngredients;
  final List<String> steps;

  Recipe({
    required this.title,
    required this.image,
    required this.calories,
    required this.existingIngredients,
    required this.nonExistingIngredients,
    required this.steps,
  });

  // Factory constructor to parse JSON
  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      title: json['title'] as String,
      image: json['image'] as String,
      calories: json['calories'] as int,
      existingIngredients:
          List<String>.from(json['existingIngredients'] ?? []),
      nonExistingIngredients:
          List<String>.from(json['nonExistingIngredients'] ?? []),
      steps: List<String>.from(json['steps'] ?? []),
    );
  }

  // Convert Recipe to Food
  Food toFood() {
  return Food(
    foodId: DateTime.now().millisecondsSinceEpoch, // Unique ID
    foodName: title,
    foodCalories: calories,
    imageUrl: image,
    recipes: steps.join('\n'), // Combine steps into a single string for `Food.recipes`
    steps: steps, // Pass the `steps` parameter
    isFavorated: false, // Default favorite status
    isSelected: false, // Default selection status
    isCheap: false, // Default to `false` (can be customized)
    isDairyFree: false, // Default to `false` (can be customized)
    isGlutenFree: false, // Default to `false` (can be customized)
    isKetogenic: false, // Default to `false` (can be customized)
    isSustainable: false, // Default to `false` (can be customized)
    isVegan: false, // Default to `false` (can be customized)
    isVegetarian: false, // Default to `false` (can be customized)
    isHealthy: false, // Default to `false` (can be customized)
    isPopular: false, // Default to `false` (can be customized)
  );
}

}
