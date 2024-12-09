import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_app_flutter/src/core/constants.dart';
import 'package:dio/dio.dart';
import 'package:food_app_flutter/src/models/food.dart';
import 'package:food_app_flutter/src/models/recipe_model.dart';
import 'package:food_app_flutter/src/core/utils/food_storage.dart';


class HealthPage extends StatefulWidget {
  const HealthPage({super.key, required this.preferences});
  final Map<String, bool> preferences;

  @override
  State<HealthPage> createState() => _HealthPageState();
}

class _HealthPageState extends State<HealthPage> {
  late bool dairy_free ;
  late bool gluten_free;
  late bool healthy;

  void initState() {
    super.initState();
    dairy_free = widget.preferences['Dairy-Free'] ?? false;
    gluten_free = widget.preferences['Gluten-Free'] ?? false;
    healthy = widget.preferences['Healthy'] ?? false;
  }
  // Method to handle saving preferences to Firestore
  Future<void> savePreferences() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User not signed in.");
      }

      final userId = user.uid;

      // Save preferences under /users/{userId}
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .set({
            'dietPreferences': {
              'Dairy-Free': dairy_free,
              'Gluten-Free': gluten_free,
              'Healthy': healthy,
            },
          }, SetOptions(merge: true)); // Use merge to keep existing data intact

      
    } catch (e) {
      print("Error saving preferences: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error saving preferences.")),
      );
    }
  }

  // Copy these functions into your LifestylePage class
Future<void> fetchPreferences() async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User not signed in.");
    }

    final userId = user.uid;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      final savedPreferences =
          Map<String, bool>.from(data['dietPreferences'] ?? {});

      setState(() {
        dairy_free = savedPreferences['Dairy-Free'] ?? false;
        gluten_free = savedPreferences['Gluten-Free'] ?? false;
        healthy = savedPreferences['Healthy'] ?? false;
      
      });
    }
  } catch (e) {
    print("Error fetching preferences: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Error fetching preferences.")),
    );
  }
}

Future<void> _fetchDailyRecipes() async {
  try {
    Dio dio = Dio();
    final includeTags = [
      if (dairy_free) 'dairy_free',
      if (gluten_free) 'gluten_free', 
      if (healthy) 'healthy',
      
    ];

    final requestData = {
      'include_tags': includeTags,
      'number': 2,
    };

    final response = await dio.post(
      '${Constants.serverIP}/get_daily_recipes',
      data: requestData,
      options: Options(
        headers: {'Content-Type': 'application/json'},
      ),
    );

    if (response.statusCode == 200) {
      final recipes = response.data;

      if (recipes is Map<String, dynamic> && recipes['recipe_info'] is List) {
        final recipeList = recipes['recipe_info'] as List<dynamic>;

        // Convert recipes to Food list
        List<Food> foodList = recipeList.map((recipe) {
          Recipe recipeObj = Recipe.fromJson(recipe);
          return recipeObj.toFood();
        }).toList();

        // Save the Food list locally
        await FoodStorage.saveFoodList(foodList);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Daily recipes updated.")),
        );
      }
    } else {
      print("Failed to fetch recipes. Status code: ${response.statusCode}");
    }
  } catch (e) {
    print("Error fetching daily recipes: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Error fetching daily recipes.")),
    );
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      appBar: AppBar(
        backgroundColor: Constants.backgroundColor,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.keyboard_arrow_left, color: Constants.primaryColor),
        ),
        leadingWidth: 100,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Health", style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontSize: 30
              ),),
              const SizedBox(height: 20,),
        
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12, // Shadow color
                            blurRadius: 4, // Blur radius
                            offset: Offset(2, 2), 
                          )
                        ]
                      ),
                      child: ListTile(
                        title: Text("Dairy-Free", style: 
                        TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400
                        ),),
                        trailing: Switch.adaptive(
                          value: dairy_free,
                          activeColor: Constants.primaryColor,
                          onChanged: (value) async{
                            setState(() {
                              dairy_free = value;
                            });

                            await savePreferences();
                            // Fetch updated preferences
                            await fetchPreferences();

                            // Fetch daily recipes based on the updated preferences
                            await _fetchDailyRecipes();
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Text(
                      "Excludes all dairy products for those with sensitivities or ethical preferences.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 20,),
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12, // Shadow color
                            blurRadius: 4, // Blur radius
                            offset: Offset(2, 2), 
                          )
                        ]
                      ),
                      child: ListTile(
                        title: Text("Gluten-Free", style: 
                        TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400
                        ),),
                        trailing: Switch.adaptive(
                          value: gluten_free,
                          activeColor: Constants.primaryColor,
                          onChanged: (value) async{
                            setState(() {
                              gluten_free = value;
                            });

                            await savePreferences();
                            // Fetch updated preferences
                            await fetchPreferences();

                            // Fetch daily recipes based on the updated preferences
                            await _fetchDailyRecipes();
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Text(
                      "Avoids gluten, making it suitable for individuals with gluten intolerance or celiac disease.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 20,),
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12, // Shadow color
                            blurRadius: 4, // Blur radius
                            offset: Offset(2, 2), 
                          )
                        ]
                      ),
                      child: ListTile(
                        title: Text("Healthy", style: 
                        TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400
                        ),),
                        trailing: Switch.adaptive(
                          value: healthy,
                          activeColor: Constants.primaryColor,
                          onChanged: (value) async{
                            setState(() {
                              healthy = value;
                            });
                            await savePreferences();
                            // Fetch updated preferences
                            await fetchPreferences();

                            // Fetch daily recipes based on the updated preferences
                            await _fetchDailyRecipes();
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Text(
                      "Focuses on nutrient-dense foods that support overall well-being and vitality.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 20,),
                    
                 
            ],
          ),
        ),
      ),
    );
  }
}