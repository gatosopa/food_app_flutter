import 'package:flutter/material.dart';
import 'package:food_app_flutter/src/core/constants.dart';
import 'package:food_app_flutter/src/features/recipe/widgets/detail_nutrition.dart';
import 'package:food_app_flutter/src/features/camera/data/models/recipe_model.dart';
import 'package:food_app_flutter/src/core/widgets/bottom_navigation_bar.dart';
import 'package:food_app_flutter/src/features/favorites/favorites_page.dart';
import 'package:food_app_flutter/src/features/home/home_page.dart';
import 'package:food_app_flutter/src/features/inventory/inventory_page.dart';
import 'package:food_app_flutter/src/features/profile/profile_page.dart';
import 'package:food_app_flutter/src/features/camera/presentation/view/camera_page.dart';
import 'package:page_transition/page_transition.dart';

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
            ? Column(
                children: [
                  Expanded(
                    child: NestedScrollView(
                      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                        return [
                          SliverAppBar(
                            expandedHeight: 300.0,
                            pinned: true,
                            flexibleSpace: FlexibleSpaceBar(
                              background: Image.network(
                                widget.recipe.image,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[200],
                                    child: const Center(
                                      child: Icon(
                                        Icons.broken_image,
                                        size: 80,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 8.0),
                                  Text(
                                    widget.recipe.title,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Row(
                                    children: [
                                      Text(
                                        widget.recipe.cuisineType,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(width: 8.0),
                                      Container(
                                        height: 5.0,
                                        width: 5.0,
                                        decoration: const BoxDecoration(
                                          color: Colors.grey,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 8.0),
                                      Text(
                                        widget.recipe.cookingTime != null
                                            ? '${widget.recipe.cookingTime} mins'
                                            : 'Unknown time',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16.0),
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
                                  // TabBar
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
                                ],
                              ),
                            ),
                          ),
                        ];
                      },
                      body: TabBarView(
                        controller: _tabController,
                        children: [
                          // Ingredients Tab
                          ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0),
                            itemCount: widget.recipe.existingIngredients.length +
                                widget.recipe.nonExistingIngredients.length,
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
                                    color: isAvailable ? Constants.primaryColor : Colors.red,
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
                  ),
                ],
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
