import 'package:flutter/material.dart';
import 'package:food_app_flutter/src/core/constants.dart';
import 'widgets/ingredient_list.dart';

class AvailableIngredientPage extends StatefulWidget {
  final List<Map<String, dynamic>> availableIngredients;

  const AvailableIngredientPage({super.key, required this.availableIngredients});

  @override
  State<AvailableIngredientPage> createState() => _AvailableIngredientPageState();
}

class _AvailableIngredientPageState extends State<AvailableIngredientPage> {
  late List<Map<String, dynamic>> availableItems;

  @override
  void initState() {
    super.initState();
    availableItems = widget.availableIngredients;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Constants.primaryColor,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.keyboard_arrow_left, color: Colors.white),
            ),
            expandedHeight: 110,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Available Ingredients',
                style: TextStyle(color: Colors.white),
              ),
              centerTitle: true,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: IngredientList(
                items: availableItems,
                title: "Available Ingredients",
                onAdd: () {
                  setState(() {
                    availableItems.add({
                      "type": "New Type",
                      "name": "New Ingredient",
                      "amount": "0g",
                    });
                  });
                },
                onRemove: (index) {
                  setState(() {
                    availableItems.removeAt(index);
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
