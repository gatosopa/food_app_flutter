import 'package:flutter/material.dart';
import 'package:food_app_flutter/src/models/food.dart';

class RecipeViewallPage extends StatefulWidget {
  const RecipeViewallPage({super.key, required this.foodList});

  final List<Food> foodList;

  @override
  State<RecipeViewallPage> createState() => _RecipeViewallPageState();
}

class _RecipeViewallPageState extends State<RecipeViewallPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}