import 'package:flutter/material.dart';
import 'package:food_app_flutter/src/core/constants.dart';
import 'package:food_app_flutter/src/models/food.dart';

class FoodCard extends StatelessWidget {
  const FoodCard({super.key, required this.food});
  final Food food;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 4,
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Ensures the height adjusts to fit content
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.asset(
                    food.imageUrl,
                    height: 80,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.favorite,
                        color: Constants.primaryColor,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Flexible(
              child: Text(
                food.foodName,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              '${food.foodCalories} Kcal',
              style: const TextStyle(
                fontSize: 12.0,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
