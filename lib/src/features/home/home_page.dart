import 'package:flutter/material.dart';
import 'package:food_app_flutter/src/core/constants.dart';
import 'package:food_app_flutter/src/core/utils/food_notifier.dart';
import 'package:food_app_flutter/src/features/home/widgets/categories.dart';
import 'package:food_app_flutter/src/features/home/widgets/food_slider.dart';
import 'package:food_app_flutter/src/models/cuisine.dart';
import 'package:food_app_flutter/src/models/food.dart';
import 'package:iconsax/iconsax.dart';
import 'package:food_app_flutter/src/core/containers/section_heading.dart';
import 'package:dio/dio.dart';
import 'package:food_app_flutter/src/features/recipe/recipe_page.dart';
import 'package:food_app_flutter/src/features/home/search_page.dart';
import 'package:page_transition/page_transition.dart';
import 'package:food_app_flutter/src/core/utils/get_daily_recipes.dart';
import 'package:food_app_flutter/src/core/utils/food_storage.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Food> _foodList = [];
  List<Food> filteredFoodList = [];
  String selectedCategory = categories[0]; // default
  bool _isLoading = false; // Loading state

  @override
  void initState() {
    super.initState();
    _foodList = Food.foodList;
    _filterFoodList();
    _loadDailyFoods();

    foodNotifier.addListener(() {
      _loadDailyFoods();
    });
  }

  @override
  void dispose() {
    foodNotifier.removeListener(() {
      _loadDailyFoods();
    });
    super.dispose();
  }

  Future<void> _loadDailyFoods() async {
    List<Food> foodList = await FoodStorage.getFoodList();
    if (foodList.isNotEmpty) {
      setState(() {
        _foodList = foodList;
        _isLoading = false;
      });
    } else {
      print("No food found in SharedPreferences.");
      setState(() {
        _isLoading = false;
      });
    }
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
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, PageTransition(child: SearchPage(), type: PageTransitionType.rightToLeft));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      width: size.width * .9,
                      height: size.height * .05,
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
                            child: Text(
                              'Search for Recipes...',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black54.withOpacity(.6),
                              ),
                            ),
                            
                          ),
                          Icon(Icons.mic, color: Colors.black54.withOpacity(.6)),
                        ],
                      ),
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

          
        ],
      ),
    );
  }
}
