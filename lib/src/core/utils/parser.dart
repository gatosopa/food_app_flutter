import 'dart:convert';
import '../../models/recipe_model.dart';

List<Recipe> parseRecipes(String jsonData) {
  final data = jsonDecode(jsonData) as List;
  return data.map((json) => Recipe.fromJson(json)).toList();
}
