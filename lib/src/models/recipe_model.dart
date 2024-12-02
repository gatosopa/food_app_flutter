import 'package:food_app_flutter/src/models/food.dart';

class Recipe {
  final int id;
  final String title;
  final String image;
  final int calories;
  final List<String> existingIngredients;
  final List<String> nonExistingIngredients;
  final List<String> nutrients;
  final List<String> steps;
  final String cuisineType;
  final int? cookingTime; // Nullable for when no cooking time is provided

  Recipe({
    required this.id,
    required this.title,
    required this.image,
    required this.calories,
    required this.existingIngredients,
    required this.nonExistingIngredients,
    required this.nutrients,
    required this.steps,
    required this.cuisineType,
    this.cookingTime,
  });

  // Factory constructor to parse JSON
  factory Recipe.fromJson(Map<String, dynamic> json) {
    final nutrients = List<String>.from(json['nutrients'] ?? []);
    final caloriesString = nutrients.firstWhere(
      (n) => n.startsWith('calories'),
      orElse: () => 'calories 0',
    );
    final calories = int.tryParse(caloriesString.split(' ')[1]) ?? 0;

    return Recipe(
      id: json['id'] as int,
      title: json['title'] as String,
      image: json['image'] as String,
      calories: calories,
      existingIngredients:
          List<String>.from(json['existing_ingredients'] ?? []),
      nonExistingIngredients:
          List<String>.from(json['non_existing_ingredients'] ?? []),
      nutrients: nutrients,
      steps: List<String>.from(json['steps'] ?? []),
      cuisineType: json['cuisine_type'] ?? 'Unknown',
      cookingTime: json['cooking_time'],
    );
  }

  // Convert Recipe to Food
  Food toFood() {
  return Food(
    foodId: id,
    foodName: title,
    foodCalories: calories,
    imageUrl: image,
    recipes: steps.join('\n'),
    steps: steps,
    cuisine: cuisineType,
    cookingTime: cookingTime,
    nutrients: nutrients,
    isSelected: false,
    isFavorated: false,
    diet: {
      'isCheap': false,
      'isDairyFree': false,
      'isGlutenFree': false,
      'isKetogenic': false,
      'isSustainable': false,
      'isVegan': false,
      'isVegetarian': false,
      'isHealthy': false,
    },
  );
}

}
