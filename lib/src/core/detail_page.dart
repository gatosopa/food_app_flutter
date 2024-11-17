import 'package:flutter/material.dart';
import 'package:food_app_flutter/src/models/food.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.food});
  final Food food;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<Food> _foodList = Food.foodList;
    return Scaffold(
      appBar: AppBar(
        title: const Text('details'),
      ),
    );
  }
}