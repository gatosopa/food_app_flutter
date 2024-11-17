class Food {
  final String foodName;
  final int foodId;
  final int foodCalories;
  final String imageUrl;
  final String recipes;
  bool isSelected;
  bool isFavorated;

  Food({
    required this.foodId,
    required this.foodName,
    required this.foodCalories,
    required this.imageUrl,
    required this.recipes,
    required this.isSelected,
    required this.isFavorated,
  });

  static List<Food> foodList = [
    Food(
      foodId: 123,
      foodCalories: 700, 
      foodName: 'Aglio e Olio', 
      imageUrl: 'assets/image/pasta.jpg', 
      recipes: 'Aglio e Olio is a simple, classic Italian pasta dish made with just a few ingredients. To prepare, start by cooking 200g of spaghetti in salted boiling water until al dente. Meanwhile, in a large pan, heat 1/4 cup of extra virgin olive oil over medium heat. Add 4-5 cloves of thinly sliced garlic and cook until golden and fragrant, about 2-3 minutes, being careful not to burn the garlic. Add a pinch of red pepper flakes for heat, if desired. Once the pasta is cooked, reserve 1/2 cup of pasta water and drain the rest. Toss the pasta into the garlic oil mixture, adding the reserved pasta water gradually to create a silky sauce. Season with salt and freshly ground black pepper to taste. Finish with a generous handful of chopped parsley and grated Parmesan cheese, if preferred. Serve hot and enjoy this simple yet flavorful dish!',
      isFavorated: true,
      isSelected: false,      
      ),

      Food(
      foodId: 234,
      foodCalories: 800, 
      foodName: 'Fried Rice', 
      imageUrl: 'assets/image/fried_rice.jpg', 
      recipes: ' To make fried rice, start by heating a bit of oil in a pan or wok over medium heat. Add minced garlic and diced onions, cooking until fragrant. Add any vegetables or proteins you like, such as carrots, peas, or shrimp, and stir-fry for a few minutes. Push everything to the side and crack an egg in the middle, scrambling it until cooked. Then, add cold, cooked rice to the pan and toss everything together. Season with soy sauce, salt, and pepper to taste. Stir-fry for a couple more minutes until everything is well combined and heated through. Serve hot!',
      isFavorated: false,
      isSelected: false,      
      ),

      Food(
      foodId: 345,
      foodCalories: 500, 
      foodName: 'Salad', 
      imageUrl: 'assets/image/salad.jpg', 
      recipes: ' To make a simple salad, start by combining fresh mixed greens like lettuce, spinach, or arugula in a large bowl. Add sliced cucumbers, cherry tomatoes, and thinly sliced red onions. For extra texture and flavor, toss in some crumbled feta cheese or grated Parmesan, and a handful of nuts like walnuts or almonds. To make the dressing, whisk together olive oil, lemon juice, salt, pepper, and a touch of honey or Dijon mustard. Drizzle the dressing over the salad and toss gently to coat. Enjoy this light and refreshing dish as a side or main meal!',
      isFavorated: false,
      isSelected: false,      
      )
  ];
  //Get the favorated items
  static List<Food> getFavoritedFood(){
    List<Food> _travelList = Food.foodList;
    return _travelList.where((element) => element.isFavorated == true).toList();
  }

  //Get the cart items
  static List<Food> addedToCartPlants(){
    List<Food> _selectedPlants = Food.foodList;
    return _selectedPlants.where((element) => element.isSelected == true).toList();
  }
}