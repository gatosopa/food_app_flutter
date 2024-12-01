import 'package:flutter/material.dart';
import 'package:food_app_flutter/src/core/constants.dart';

class DetailIngredientlist extends StatelessWidget {
  const DetailIngredientlist({
    super.key,
    required this.existingIngredients,
    required this.nonExistingIngredients,
  });

  final List<String> existingIngredients;
  final List<String> nonExistingIngredients;

  @override
  Widget build(BuildContext context) {
    final allIngredients = [
      ...existingIngredients.map((ingredient) => {'name': ingredient, 'available': true}),
      ...nonExistingIngredients.map((ingredient) => {'name': ingredient, 'available': false}),
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Text(
            '${allIngredients.length} items', // Display total ingredients count
            style: const TextStyle(fontSize: 16.0, color: Color(0xff748189)),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: allIngredients.length,
          itemBuilder: (context, index) {
            final ingredient = allIngredients[index];
            final isAvailable = ingredient['available'] as bool;

            return Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Card(
                color: const Color.fromRGBO(255, 255, 255, 1),
                elevation: 2.0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListTile(
                    leading: Icon(
                      isAvailable ? Icons.check_circle : Icons.cancel,
                      color: isAvailable ? Constants.primaryColor : Colors.red,
                    ),
                    title: Text(
                      ingredient['name'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Text(
                      isAvailable ? 'Available' : 'Needed',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
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
