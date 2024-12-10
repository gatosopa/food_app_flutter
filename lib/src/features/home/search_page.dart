import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import '../camera/presentation/view/widgets/recipe_card.dart';
import '../camera/presentation/view/available_ingredient_page.dart';
import 'package:food_app_flutter/src/core/constants.dart';
import 'package:food_app_flutter/src/core/widgets/food_card.dart';
import 'package:food_app_flutter/src/models/food.dart';
import 'package:food_app_flutter/src/models/recipe_model.dart';
import 'package:food_app_flutter/src/features/recipe/recipe_page.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart'; // 

List<Recipe> parseRecipes(String jsonData) {
  final data = jsonDecode(jsonData);
  if (data is List) {
    return data.map((recipe) => Recipe.fromJson(recipe)).toList();
  } else {
    throw Exception('Invalid JSON format for recipes');
  }
}

class SearchPage extends StatefulWidget {

  
  const SearchPage({Key? key,}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  final Dio _dio = Dio(); // For HTTP requests

  List<String> _recipelist = [
    'Pasta',
    'Salad',
    'Rice',
    'Soup',
    'Sandwich',
    'Pizza',
    'Burger',
    'Steak',
    'Fries',
    'Curry',
    'Omelette',
    'Tacos',
    'Sushi',
    'Toast',
    'Bacon',
    'Pancakes',
    'Waffles',
    'Smoothie',
    'Wrap',
    'Noodles',
    'Grilled Cheese',
    'Hot Dog',
    'BBQ Ribs',
    'Chili',
    'Lasagna',
    'Biryani',
    'Casserole',
    'Dumplings',
    'Mac and Cheese',
    'Stir Fry',
    'Chicken',
  ];

  List<String> _filteredRecipes = [];
  bool _isLoading = false;
  bool _isProgrammaticUpdate = false;
  bool _isShowRecipe = false;
  String jsonData = "";

  @override
  void initState() {
    super.initState();
    _filteredRecipes = _recipelist;
    _controller.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onSearchChanged);
    _controller.dispose();
    super.dispose();
  }

  // Query change, so suggestions dynamically displayed
  void _onSearchChanged() {
    if (_isProgrammaticUpdate) return;
    setState(() {
      if (_controller.text.isEmpty) {
        _filteredRecipes = _recipelist;
        _isShowRecipe = false;
      } else {
        _filteredRecipes = _recipelist
            .where((item) => item.toLowerCase().contains(_controller.text.toLowerCase()))
            .toList();
         if (_filteredRecipes.isNotEmpty) {
          _isShowRecipe = false;
        }
      }
    });
  }

  // Backend Integration: Send search query with logging
  Future<void> sendSearchQuery(String keyword, int number) async {
    setState(() {
      _isLoading = true;
    });
    String? userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null) {
        throw Exception("No user is currently logged in.");
      }

    final requestData = {
      'keyword': keyword,
      'number': number,
      'user_id': userId, 
    };

    // Log the request data
    print("Sending data to backend: $requestData");

    try {
      final response = await _dio.post(
        '${Constants.serverIP}/recipes/search',
        data: requestData,
        options: Options(
          headers: {
            'Content-Type': 'application/json', // Ensure JSON format
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        print("Received response from backend: $data");

        // Navigate to RecipePage with the response data
        if (mounted) {
          jsonData = jsonEncode(data['recipes']);
          
        }
      } else {
        print("Failed to fetch recipes. Status Code: ${response.statusCode}");
        
      }
    } catch (e) {
      print("Error sending data to backend: $e");
      
    } finally {
      setState(() {
        _isLoading = false;
        _isShowRecipe = true;
      });
    }
  }

  // User picks a suggestion
  void _onSuggestionSelected(String suggestion) {
    setState(() {
      _isProgrammaticUpdate = true;
      _controller.text = suggestion;
      _isShowRecipe = true;
    });

    FocusScope.of(context).unfocus();
    sendSearchQuery(suggestion, 2);
    setState(() {
      _isProgrammaticUpdate = false;
    });
  }

  // User submits a query
  void _onSearchSubmitted(String query) {
    FocusScope.of(context).unfocus();
    sendSearchQuery(query, 2);
    setState(() {
      _isLoading = true;
    });
  
  }

  @override
  Widget build(BuildContext context) {
    List<Recipe> recipes = [];
    if (_isShowRecipe && jsonData.isNotEmpty) {
      try {
        recipes = parseRecipes(jsonData); // Parse only if jsonData is valid
      } catch (e) {
        print("Error parsing recipes: $e");
        recipes = [];
      }
    }

    Size size = MediaQuery.of(context).size; // Get screen size
    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      appBar: AppBar(
        backgroundColor: Constants.backgroundColor,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.keyboard_arrow_left, color: Constants.primaryColor),
            ),
            const Text(
              "Search",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
                  SizedBox(width: 20),

                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Search the Foodie App',
                        hintStyle: TextStyle(color: Colors.black54),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none
                      ),
                      onSubmitted: _onSearchSubmitted,
                    ),
                  ),
                  Icon(Icons.mic, color: Colors.black54.withOpacity(.6)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _isShowRecipe
                ? _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: recipes.length,
                        itemBuilder: (context, index) {
                          final recipe = recipes[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AvailableIngredientPage(
                                    availableIngredients: recipe.existingIngredients
                                        .map((ingredient) => {'name': ingredient})
                                        .toList(),
                                  ),
                                ),
                              );
                            },
                            child: RecipeCard(
                              recipe: recipe,
                            ),
                          );
                        },
                      )
                : _filteredRecipes.isEmpty
                    ? const Center(
                        child: Text(
                          'No suggestions available',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _filteredRecipes.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Icon(
                              Icons.search,
                              color: Colors.black.withOpacity(.6),
                            ),
                            title: Text(_filteredRecipes[index]),
                            onTap: () => _onSuggestionSelected(_filteredRecipes[index]),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
