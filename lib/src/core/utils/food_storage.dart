import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:food_app_flutter/src/models/food.dart';  

class FoodStorage {
  // Save a list of Food objects to SharedPreferences
  static Future<void> saveFoodList(List<Food> foodList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = jsonEncode(foodList.map((food) => food.toMap()).toList());
    print("Saving food list: $jsonString");
    await prefs.setString('daily_foods', jsonString);
    
  }

  // Retrieve a list of Food objects from SharedPreferences
  static Future<List<Food>> getFoodList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('daily_foods');
    print("Retrieved food list: $jsonString"); 

    if (jsonString != null) {
      List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => Food.fromJson(json)).toList();
    }
    return [];
  }
}