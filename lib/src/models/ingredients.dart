class Ingredients {
  final String name;
  final String imageUrl;

  Ingredients({
    required this.name,
    required this.imageUrl,
    
});

static List<Ingredients> ingredientList = [
  Ingredients(
    name: "Meat",
    imageUrl: 'assets/image/meat.jpg'
  ),
  Ingredients(
    name: "Vegetables",
    imageUrl: 'assets/image/vegetables.jpg'
  ),
  Ingredients(
    name: "Fruit",
    imageUrl: 'assets/image/fruit.jpg'
  ),
  Ingredients(
    name: "Pasta and Rice",
    imageUrl: 'assets/image/rawpasta.jpg'
  ),
  Ingredients(
    name: "Herbs and Spices",
    imageUrl: 'assets/image/herbs.jpg'
  ),
  Ingredients(
    name: "Baking",
    imageUrl: 'assets/image/flour.jpg'
  ),
];
}