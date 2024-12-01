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
  bool isSelected;
  bool isFavorated;

  // Dietary Categories
  final bool isCheap;
  final bool isDairyFree;
  final bool isGlutenFree;
  final bool isKetogenic;
  final bool isSustainable;
  final bool isVegan;
  final bool isVegetarian;
  final bool isHealthy;
  final bool isPopular;

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
    required this.isSelected,
    required this.isFavorated,
    required this.isCheap,
    required this.isDairyFree,
    required this.isGlutenFree,
    required this.isKetogenic,
    required this.isSustainable,
    required this.isVegan,
    required this.isVegetarian,
    required this.isHealthy,
    required this.isPopular,
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
      isFavorated: true,
      isSelected: false,
      isCheap: true,
      isDairyFree: true,
      isGlutenFree: false,
      isKetogenic: false,
      isSustainable: true,
      isVegan: true,
      isVegetarian: true,
      isHealthy: true,
      isPopular: true,
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
      isFavorated: json['isFavorited'] ?? false,
      isSelected: json['isSelected'] ?? false,
      isCheap: json['isCheap'] ?? false,
      isDairyFree: json['isDairyFree'] ?? false,
      isGlutenFree: json['isGlutenFree'] ?? false,
      isKetogenic: json['isKetogenic'] ?? false,
      isSustainable: json['isSustainable'] ?? false,
      isVegan: json['isVegan'] ?? false,
      isVegetarian: json['isVegetarian'] ?? false,
      isHealthy: json['isHealthy'] ?? false,
      isPopular: json['isPopular'] ?? false,
    );
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
