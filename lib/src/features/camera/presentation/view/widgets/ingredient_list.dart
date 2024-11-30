import 'package:flutter/material.dart';
import 'package:food_app_flutter/src/core/constants.dart';

class IngredientList extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final String title;
  final VoidCallback onAdd;
  final Function(int) onRemove;

  const IngredientList({
    super.key,
    required this.items,
    required this.title,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 10.0),
              elevation: 2.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Display ingredient details
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "ITEM TYPE: ${item['type']}",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Constants.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          item['name'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          item['amount'],
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                    // Action buttons
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => onRemove(index),
                          icon: Icon(Icons.remove, color: Constants.primaryColor),
                        ),
                        IconButton(
                          onPressed: onAdd,
                          icon: Icon(Icons.add, color: Constants.primaryColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
