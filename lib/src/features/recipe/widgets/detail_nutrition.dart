import 'package:flutter/material.dart';

class DetailNutrition extends StatelessWidget {
  final List<String> nutrients;

  const DetailNutrition({super.key, required this.nutrients});

  // Helper method to reformat nutrient text
  String formatNutrientText(String nutrient) {
    // Match number followed by optional unit and any remaining text
    final RegExp regex = RegExp(r'(\d+)\s*([a-zA-Z]+)?\s*(.*)');
    final match = regex.firstMatch(nutrient);

    if (match != null) {
      final String number = match.group(1)!;
      final String? unit = match.group(2);
      String? name = match.group(3);
      
      // If name is empty, try to extract it from the original string
      if (name?.isEmpty ?? true) {
        if (nutrient.toLowerCase().contains('protein')) name = 'Proteins';
        else if (nutrient.toLowerCase().contains('carb')) name = 'Carbs';
        else if (nutrient.toLowerCase().contains('fat')) name = 'Fats';
      }
      
      // Format based on whether it's calories or other nutrients
      if (nutrient.toLowerCase().contains('cal')) {
        return '$number ${unit ?? 'KCal'}'.trim();
      } else {
        return '$number${unit ?? 'g'} ${name ?? ''}'.trim();
      }
    }
    return nutrient; // Return original if no match
  }

  @override
  Widget build(BuildContext context) {
    // Map the nutrients list into a structured format with icons
    final List<Map<String, dynamic>> nutrientItems = nutrients.map((nutrient) {
      if (nutrient.toLowerCase().contains('carbs')) {
        return {'icon': Icons.spa, 'label': formatNutrientText(nutrient)};
      } else if (nutrient.toLowerCase().contains('protein')) {
        return {'icon': Icons.fitness_center, 'label': formatNutrientText(nutrient)};
      } else if (nutrient.toLowerCase().contains('calories') || nutrient.toLowerCase().contains('kcal')) {
        return {'icon': Icons.local_fire_department, 'label': formatNutrientText(nutrient)};
      } else if (nutrient.toLowerCase().contains('fat')) {
        return {'icon': Icons.fastfood, 'label': formatNutrientText(nutrient)};
      } else {
        return {'icon': Icons.info, 'label': formatNutrientText(nutrient)};
      }
    }).toList();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 2,
        mainAxisSpacing: 16.0,
        crossAxisSpacing: 16.0,
        childAspectRatio: 3.0,
        physics: const NeverScrollableScrollPhysics(), // Disable scroll for GridView
        children: nutrientItems.map((item) {
          return Row(
            children: [
              // Icon with gray background
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.grey[300], // Gray background for the icon
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Icon(
                  item['icon'],
                  size: 24.0,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 8.0),
              // Text with white background
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  decoration: BoxDecoration(
                    color: Colors.white, // White background for the text
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    item['label'],
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2, // Allow wrapping for longer text
                    overflow: TextOverflow.visible,
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
