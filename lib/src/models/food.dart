class Food {
  final String foodName;
  final int foodId;
  final int foodCalories;
  final String imageUrl;
  final String recipes;
  final List<String> steps; // Steps for preparation
  bool isSelected;
  bool isFavorated;

  // Categories
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
    required this.steps, // Add steps to constructor
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

  // Static list of food items
  static List<Food> foodList = [
    Food(
      foodId: 123,
      foodCalories: 700,
      foodName: 'Aglio e Olio',
      imageUrl: 'assets/image/pasta.jpg',
      recipes: 'Aglio e Olio is a simple, classic Italian pasta dish...',
      steps: [
        'Cook 200g of spaghetti in salted boiling water until al dente.',
        'Heat 1/4 cup olive oil in a pan over medium heat.',
        'Add 4-5 sliced garlic cloves and sauté until golden.',
        'Add a pinch of red pepper flakes for heat, if desired.',
        'Toss cooked spaghetti in the garlic oil mixture.',
        'Season with salt and pepper to taste.',
        'Garnish with parsley and Parmesan cheese, if preferred.',
      ],
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
    Food(
      foodId: 234,
      foodCalories: 800,
      foodName: 'Fried Rice',
      imageUrl: 'assets/image/fried_rice.jpg',
      recipes: 'Fried rice is a versatile and quick meal...',
      steps: [
        'Heat a bit of oil in a pan or wok over medium heat.',
        'Add minced garlic and diced onions; cook until fragrant.',
        'Add vegetables or proteins like carrots, peas, or shrimp.',
        'Push everything to the side and scramble an egg in the center.',
        'Add cold, cooked rice and toss everything together.',
        'Season with soy sauce, salt, and pepper to taste.',
        'Stir-fry for a few more minutes until combined.',
      ],
      isFavorated: false,
      isSelected: false,
      isCheap: true,
      isDairyFree: true,
      isGlutenFree: false,
      isKetogenic: false,
      isSustainable: true,
      isVegan: false,
      isVegetarian: true,
      isHealthy: false,
      isPopular: true,
    ),
    Food(
      foodId: 345,
      foodCalories: 500,
      foodName: 'Salad',
      imageUrl: 'assets/image/salad.jpg',
      recipes: 'A fresh and healthy salad...',
      steps: [
        'Combine fresh mixed greens in a large bowl.',
        'Add sliced cucumbers, cherry tomatoes, and thinly sliced red onions.',
        'Toss in some crumbled feta cheese or grated Parmesan.',
        'Whisk together olive oil, lemon juice, salt, and pepper for the dressing.',
        'Drizzle the dressing over the salad and toss gently.',
        'Enjoy as a side or a main meal!',
      ],
      isFavorated: false,
      isSelected: false,
      isCheap: true,
      isDairyFree: false,
      isGlutenFree: false,
      isKetogenic: false,
      isSustainable: false,
      isVegan: false,
      isVegetarian: true,
      isHealthy: true,
      isPopular: false,
    ),
  ];

  // Get favorited items
  static List<Food> getFavoritedFood() {
    return foodList.where((element) => element.isFavorated).toList();
  }

  // Get selected items
  static List<Food> addedToCartPlants() {
    return foodList.where((element) => element.isSelected).toList();
  }
}
