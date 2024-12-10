import 'package:flutter/material.dart';
import 'package:food_app_flutter/src/core/constants.dart';
import 'package:food_app_flutter/src/features/recipe/widgets/detail_nutrition.dart';
import 'package:food_app_flutter/src/models/recipe_model.dart';
import 'package:food_app_flutter/src/core/widgets/bottom_navigation_bar.dart';
import 'package:food_app_flutter/src/features/favorites/favorites_page.dart';
import 'package:food_app_flutter/src/features/home/home_page.dart';
import 'package:food_app_flutter/src/features/inventory/inventory_page.dart';
import 'package:food_app_flutter/src/features/profile/profile_page.dart';
import 'package:food_app_flutter/src/features/camera/presentation/view/camera_page.dart';
import 'package:page_transition/page_transition.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_app_flutter/src/core/containers/section_heading.dart';
import 'package:food_app_flutter/src/features/recipe/widgets/recipe_appbar.dart';

class DetailPage extends StatefulWidget {
  final Recipe recipe;

  const DetailPage({Key? key, required this.recipe}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _bottomNavIndex = -1; // Use -1 to represent the DetailPage itself

  // List of other pages
  final List<Widget> pages = const [
    HomePage(),
    InventoryPage(),
    FavoritesPage(),
    ProfilePage(),
  ];
  late List<String> fridgeIngredients = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> _fetchFridgeIngredients() async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null) {
        throw Exception("No user is currently logged in.");
      }

      final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();

      if (userDoc.exists) {
        setState(() {
          fridgeIngredients = List<String>.from(userDoc['fridge_ingredients'] ?? []);
        });
      } else {
        throw Exception("User document does not exist.");
      }
    } catch (e) {
      print("Error fetching fridge ingredients: $e");
    }
  }

  Future<bool> _onWillPop() async {
    if (_bottomNavIndex != -1) {
      // If on a different page, return to DetailPage
      setState(() {
        _bottomNavIndex = -1;
      });
      return false; // Prevent default back navigation
    }
    return true; // Allow default behavior (e.g., exit app)
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: _bottomNavIndex == -1
            ? CustomScrollView(
              slivers: <Widget>[
                RecipeviewAppbar(recipeImage: widget.recipe.image,),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 8.0,),
                        SectionHeading(title: widget.recipe.title, showActionButton: false,),
                        const SizedBox(height: 16.0,),
                        DefaultTextStyle(
                          style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.black),
                          child: Row(
                            children: [
                              Text(widget.recipe.cuisineType ?? 'Unknown time'),
                              const SizedBox(width: 8.0,),
                              Container(
                                height: 5.0,
                                width: 5.0,
                                decoration: const BoxDecoration(
                                  color: Colors.grey,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8.0,),
                              Text(widget.recipe.cookingTime != null
                                            ? '${widget.recipe.cookingTime} mins'
                                            : 'Unknown time'),
                            ]
                          ),
                        ),
                        const SizedBox(height: 16.0,),
                        const Divider(color: Colors.grey, height: 1.0),
                        const SizedBox(height: 8.0,),
                        const Text(
                          'Nutritional Facts',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                          widget.recipe.nutrients.isNotEmpty
                            ? DetailNutrition(nutrients: widget.recipe.nutrients)
                            : const Text(
                                'No nutritional information available.',
                                style: TextStyle(color: Colors.grey),
                              ),
                        const SizedBox(height: 16.0),
                        Container(
                                    margin: const EdgeInsets.symmetric(vertical: 16.0),
                                    decoration: BoxDecoration(
                                      color: const Color(0xfff2f2f7),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: TabBar(
                                      controller: _tabController,
                                      indicator: BoxDecoration(
                                        color: Constants.primaryColor,
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      labelColor: Colors.white,
                                      unselectedLabelColor: Colors.black,
                                      indicatorSize: TabBarIndicatorSize.tab,
                                      tabs: const [
                                        Tab(
                                          height: 40,
                                          child: Center(
                                            child: Text('Ingredients'),
                                          ),
                                        ),
                                        Tab(
                                          height: 40,
                                          child: Center(
                                            child: Text('Instructions'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                      Container(
                        height: MediaQuery.of(context).size.height - 100,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            // Ingredients Tab
                            ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 24.0),
                              itemCount: widget.recipe.existingIngredients.length +
                                  widget.recipe.nonExistingIngredients.length,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final isExisting = index < widget.recipe.existingIngredients.length;
                                final ingredient = isExisting
                                    ? widget.recipe.existingIngredients[index]
                                    : widget.recipe.nonExistingIngredients[index -
                                        widget.recipe.existingIngredients.length];
                                final isAvailable = isExisting;
                        
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                                  child: ListTile(
                                    leading: Icon(
                                      isAvailable ? Icons.check_circle : Icons.cancel,
                                      color: isAvailable ? Colors.green : Colors.red,
                                    ),
                                    title: Text(
                                      ingredient,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                    trailing: Text(
                                      isAvailable ? 'Available' : 'Needed',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            // Instructions Tab
                            ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 24.0),
                              itemCount: widget.recipe.steps.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Constants.primaryColor,
                                      child: Text(
                                        '${index + 1}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      widget.recipe.steps[index],
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      ],
                    ),
                  ),
                )
              ]
            )
            
            
            
            : IndexedStack(
                index: _bottomNavIndex, // Adjust index for pages
                children: pages,
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              PageTransition(
                child: const CameraPage(),
                type: PageTransitionType.bottomToTop,
              ),
            );
          },
          shape: const CircleBorder(),
          backgroundColor: Constants.primaryColor,
          child: const Icon(Icons.camera_alt, color: Colors.white),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: _bottomNavIndex == -1 ? 0 : _bottomNavIndex,
          onTap: (index) {
            setState(() {
              if (index == 0) {
                // Navigate to HomePage
                _bottomNavIndex = 0;
              } else {
                _bottomNavIndex = index;
              }
          });
          },
        ),
      ),
    );
  }
}
