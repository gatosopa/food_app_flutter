import 'package:flutter/material.dart';
import 'package:food_app_flutter/src/core/constants.dart';
import 'package:food_app_flutter/src/core/containers/section_heading.dart';
import 'package:food_app_flutter/src/features/recipe/widgets/recipe_appbar.dart';
import 'package:food_app_flutter/src/features/recipe/widgets/detail_ingredients.dart';
import 'package:food_app_flutter/src/features/recipe/widgets/detail_nutrition.dart';
import 'package:food_app_flutter/src/features/recipe/widgets/expanded_widget.dart';
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: <Widget>[
          RecipeviewAppbar(food: widget.food),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8.0),
                  SectionHeading(
                    title: widget.food.foodName,
                    showActionButton: false,
                  ),
                  const SizedBox(height: 8.0),
                  DefaultTextStyle(
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.black),
                    child: Row(
                      children: [
                        const Text('Italian'), // Replace with food category if available
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
                        const Text('60 mins'), // Replace with dynamic time if available
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  // Display the recipe steps
                  Text(
                    'Steps',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  // Use the ExpandedWidget to display recipe steps
                  ExpandedWidget(
                    text: widget.food.steps.join("\n\n"), // Combine steps into a single string
                  ),
                  const Divider(color: Colors.grey, height: 1.0),
                  Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: DetailNutrition(),
                  ),
                  const SizedBox(height: 16.0),
                  // Ingredients Section
                  Text(
                    'Ingredients',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Padding(
                    padding: const EdgeInsets.all(1),
                    child: DetailIngredientlist(food: widget.food),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      // Add to favorites logic
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Constants.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      'Add to Favorites',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
