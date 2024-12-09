import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_app_flutter/src/core/constants.dart';
import 'package:dio/dio.dart';
import 'package:food_app_flutter/src/models/food.dart';
import 'package:food_app_flutter/src/models/recipe_model.dart';
import 'package:food_app_flutter/src/core/utils/food_storage.dart';

class LifestylePage extends StatefulWidget {
  const LifestylePage({super.key, required this.preferences});
  final Map<String, bool> preferences;

  @override
  State<LifestylePage> createState() => _LifestylePageState();
}

class _LifestylePageState extends State<LifestylePage> {
  late bool ketogenic;
  late bool sustainable;
  late bool vegan;
  late bool vegetarian;


  void initState() {
    super.initState();
    ketogenic = widget.preferences['Ketogenic'] ?? false;
    sustainable = widget.preferences['Sustainable'] ?? false;
    vegan = widget.preferences['Vegan'] ?? false;
    vegetarian = widget.preferences['Vegetarian'] ?? false;
  }

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
            'Ketogenic': ketogenic,
            'Sustainable': sustainable,
            'Vegan': vegan, 
            'Vegetarian': vegetarian,
          },
        }, SetOptions(merge: true));

    

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Preferences saved and updated successfully.")),
    );
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
        ketogenic = savedPreferences['Ketogenic'] ?? false;
        sustainable = savedPreferences['Sustainable'] ?? false;
        vegan = savedPreferences['Vegan'] ?? false;
        vegetarian = savedPreferences['Vegetarian'] ?? false;
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
      if (ketogenic) 'ketogenic',
      if (sustainable) 'sustainable',
      if (vegan) 'vegan',
      if (vegetarian) 'vegetarian',
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
              Text("Lifestyle", style: TextStyle(
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
                        title: Text("Ketogenic", style: 
                        TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400
                        ),),
                        trailing: Switch.adaptive(
                          value: ketogenic,
                          activeColor: Constants.primaryColor,
                          onChanged: (value) async{
                            setState(() {
                              ketogenic = value;
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
                      "A low-carb, high-fat diet designed to promote fat burning and ketosis.",
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
                        title: Text("Sustainable", style: 
                        TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400
                        ),),
                        trailing: Switch.adaptive(
                          value: sustainable,
                          activeColor: Constants.primaryColor,
                          onChanged: (value) async{
                            setState(() {
                              sustainable = value;
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
                      "Focuses on environmentally-friendly practices and reducing ecological impact.",
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
                        title: Text("Vegan", style: 
                        TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400
                        ),),
                        trailing: Switch.adaptive(
                          value: vegan,
                          activeColor: Constants.primaryColor,
                          onChanged: (value) async{
                            setState(() {
                              vegan = value;
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
                      "Excludes all animal products for ethical, environmental, and health reasons.",
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
                        title: Text("Vegetarian", style: 
                        TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400
                        ),),
                        trailing: Switch.adaptive(
                          value: vegetarian,
                          activeColor: Constants.primaryColor,
                          onChanged: (value) async{
                            setState(() {
                              vegetarian = value;
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
                      "A plant-based diet that avoids meat and fish but may include dairy and eggs.",
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