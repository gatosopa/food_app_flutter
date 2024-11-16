class Recipe {
  final String title;
  final String image;
  final List<String> existingIngredients;
  final List<String> nonExistingIngredients;

  Recipe({
    required this.title,
    required this.image,
    required this.existingIngredients,
    required this.nonExistingIngredients,
  });

  // Factory method to parse JSON into Recipe objects
  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      title: json['title'],
      image: json['image'],
      existingIngredients: List<String>.from(json['existing_ingredients']),
      nonExistingIngredients: List<String>.from(json['non_existing_ingredients']),
    );
  }
}
