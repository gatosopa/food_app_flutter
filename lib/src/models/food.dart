import 'package:flutter/material.dart';

class Food {
  final String foodName;
  final int foodId;
  final int foodCalories;
  final String imageUrl;
  final String recipes;
  final List<String> steps;
  final String? cuisine;
  final int? cookingTime;
  final List<String>? nutrients;
  final Map<String, bool> diet; // Store dietary preferences as a map
  bool isSelected;
  bool isFavorated;

  Food({
    required this.foodId,
    required this.foodName,
    required this.foodCalories,
    required this.imageUrl,
    required this.recipes,
    required this.steps,
    this.cuisine,
    this.cookingTime,
    this.nutrients,
    required this.diet,
    required this.isSelected,
    required this.isFavorated,
  });

  // Static list of food items (Mock Data)
  static List<Food> foodList = [
    Food(
      foodId: 123,
      foodName: 'Aglio e Olio',
      foodCalories: 700,
      imageUrl: 'assets/image/pasta.jpg',
      recipes: 'Classic Italian pasta dish...',
      steps: ['Boil pasta', 'Prepare sauce', 'Mix and serve'],
      cuisine: 'Italian',
      cookingTime: 30,
      nutrients: ['Calories: 700', 'Protein: 10g', 'Carbs: 85g'],
      diet: {
        'isCheap': true,
        'isDairyFree': true,
        'isGlutenFree': false,
        'isKetogenic': false,
        'isSustainable': true,
        'isVegan': true,
        'isVegetarian': true,
        'isHealthy': true,
        'isPopular': true,
      },
      isFavorated: true,
      isSelected: false,
    ),
  ];

  // Factory Constructor for JSON Parsing
  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      foodId: json['id'],
      foodName: json['name'],
      foodCalories: json['calories'],
      imageUrl: json['image'],
      recipes: json['recipes'],
      steps: List<String>.from(json['steps'] ?? []),
      cuisine: json['cuisine'],
      cookingTime: json['cooking_time'],
      nutrients: List<String>.from(json['nutrients'] ?? []),
      diet: Map<String, bool>.from(json['diet'] ?? {}),
      isFavorated: json['isFavorited'] ?? false,
      isSelected: json['isSelected'] ?? false,
    );
  }

  // Convert Food to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': foodId,
      'name': foodName,
      'calories': foodCalories,
      'image': imageUrl,
      'recipes': recipes,
      'steps': steps,
      'cuisine': cuisine,
      'cooking_time': cookingTime,
      'nutrients': nutrients,
      'diet': diet,
      'isFavorited': isFavorated,
      'isSelected': isSelected,
    };
  }

  // Get favorited items
  static List<Food> getFavoritedFood() {
    return foodList.where((element) => element.isFavorated).toList();
  }

  // Get selected items
  static List<Food> addedToCartPlants() {
    return foodList.where((element) => element.isSelected).toList();
  }
}
