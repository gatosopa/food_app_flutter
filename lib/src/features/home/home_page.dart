import 'package:flutter/material.dart';
import 'package:food_app_flutter/src/core/constants.dart';
import 'package:food_app_flutter/src/features/home/widgets/categories.dart';
import 'package:food_app_flutter/src/features/home/widgets/food_slider.dart';
import 'package:food_app_flutter/src/models/cuisine.dart';
import 'package:food_app_flutter/src/models/food.dart';
import 'package:iconsax/iconsax.dart';
import 'package:food_app_flutter/src/core/containers/section_heading.dart';
import 'package:dio/dio.dart';
import 'package:food_app_flutter/src/features/recipe/recipe_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController(); // Controller for search bar
  final Dio _dio = Dio(); // Dio instance for making requests

  List<Food> _foodList = [];
  List<Food> filteredFoodList = [];
  String selectedCategory = categories[0]; // default
  bool _isLoading = false; // Loading state

  @override
  void initState() {
    super.initState();
    _foodList = Food.foodList;
    _filterFoodList();
  }

  // Filter food recipe mechanism
  void _filterFoodList() {
    setState(() {
      if (selectedCategory == 'All') {
        // Show all food
        filteredFoodList = List.from(_foodList);
      } else {
        filteredFoodList = _foodList.where((food) {
          final diet = food.diet;

          if (selectedCategory == 'Cheap') {
            return diet['isCheap'] ?? false;
          } else if (selectedCategory == 'Dairy Free') {
            return diet['isDairyFree'] ?? false;
          } else if (selectedCategory == 'Gluten Free') {
            return diet['isGlutenFree'] ?? false;
          } else if (selectedCategory == 'Ketogenic') {
            return diet['isKetogenic'] ?? false;
          } else if (selectedCategory == 'Sustainable') {
            return diet['isSustainable'] ?? false;
          } else if (selectedCategory == 'Vegan') {
            return diet['isVegan'] ?? false;
          } else if (selectedCategory == 'Vegetarian') {
            return diet['isVegetarian'] ?? false;
          } else if (selectedCategory == 'Healthy') {
            return diet['isHealthy'] ?? false;
          }
          return false;
        }).toList();
      }
    });
    print('Filtered food list: $filteredFoodList'); // Debugging
  }

  // Callback function for category
  void _onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
    });
    _filterFoodList();
  }

  // Method to send the search query to the backend
  Future<void> _sendSearchQuery(String query) async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      final response = await _dio.post(
        '${Constants.serverIP}/search', // Replace with your backend URL
        data: {'query': query},
      );

      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RecipePage(jsonData: response.data.toString()),
          ),
        );
      } else {
        _showErrorSnackbar("Failed to fetch recipes.");
      }
    } catch (e) {
      _showErrorSnackbar("Error sending search query: $e");
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      body: CustomScrollView(
        slivers: <Widget>[
          // Sliver app bar
          SliverAppBar(
            backgroundColor: Constants.primaryColor,
            leading: const Icon(Icons.menu),
            expandedHeight: 110,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(),
              title: const Text(
                'F O O D I E',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              centerTitle: true,
            ),
          ),

          // Search Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    width: size.width * .9,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search, color: Colors.black54.withOpacity(.6)),
                        const SizedBox(width: 20),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            showCursor: true,
                            onSubmitted: (query) {
                              if (query.trim().isNotEmpty) {
                                _sendSearchQuery(query); // Send query to backend
                              }
                            },
                            decoration: const InputDecoration(
                              hintText: 'Find a Famous Recipe',
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                          ),
                        ),
                        Icon(Icons.mic, color: Colors.black54.withOpacity(.6)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),

          // Loading Indicator
          if (_isLoading)
            const SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                ),
              ),
            ),

          // Today's Chef Picks
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: const SectionHeading(
                      title: 'Today\'s Chef Picks',
                      showActionButton: false,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.all(1),
                    child: FoodSlider(banners: _foodList),
                  ),
                ],
              ),
            ),
          ),

          // Categories
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: const Text(
                "Categories",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Filtered Food List
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 50),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Categories(
                    currentCat: selectedCategory,
                    onCategorySelected: _onCategorySelected,
                  ),
                  const SizedBox(height: 20),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: filteredFoodList.isEmpty
                          ? [const Center(child: Text('No recipe found for this category!'))]
                          : List.generate(
                              filteredFoodList.length,
                              (index) => Container(
                                margin: EdgeInsets.only(
                                  left: index == 0 ? 20 : 0,
                                  right: index == _foodList.length - 1 ? 20 : 10,
                                ),
                                width: 200,
                                child: Stack(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          height: 130,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15),
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  filteredFoodList[index].imageUrl),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          filteredFoodList[index].foodName,
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          children: [
                                            const Icon(
                                              Iconsax.flash_1,
                                              size: 18,
                                              color: Colors.grey,
                                            ),
                                            Text(
                                              "${filteredFoodList[index].foodCalories} Cal",
                                              style: const TextStyle(
                                                  fontSize: 12, color: Colors.grey),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
