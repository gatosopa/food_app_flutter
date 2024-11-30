import 'package:flutter/material.dart';
import 'package:food_app_flutter/src/core/constants.dart';
import 'package:food_app_flutter/src/models/food.dart';

class DetailIngredientlist extends StatelessWidget {
  const DetailIngredientlist({super.key, required this.food});
  final Food food;

  @override
  Widget build(BuildContext context) {
    final ingredients = List.generate(6, (index) => 'Rice');

    return Column(
      
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Text(
            '${ingredients.length} items', // Display total ingredients count
            style: const TextStyle(
              fontSize: 16.0,
              color: Color(0xff748189)
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: ingredients.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Card(
                color: const Color.fromRGBO(255, 255, 255, 1),
                elevation: 2.0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListTile(
                    leading: Icon(Icons.rice_bowl, color: Constants.primaryColor,),
                    title: Text(ingredients[index],
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                      ),
                      
                      ),
                    trailing: Text('200gr',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                      ),
                      ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
 }
