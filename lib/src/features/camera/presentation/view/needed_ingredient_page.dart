import 'package:flutter/material.dart';
import 'package:food_app_flutter/src/core/constants.dart';
import 'widgets/ingredient_list.dart';

class NeededIngredientPage extends StatefulWidget {
  final List<Map<String, dynamic>> neededIngredients;

  const NeededIngredientPage({super.key, required this.neededIngredients});

  @override
  State<NeededIngredientPage> createState() => _NeededIngredientPageState();
}

class _NeededIngredientPageState extends State<NeededIngredientPage> {
  late List<Map<String, dynamic>> neededItems;

  @override
  void initState() {
    super.initState();
    neededItems = widget.neededIngredients;
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
              background: Container(),
              title: Text('F O O D I E', style: TextStyle(
                color: Constants.secondaryColor,
                fontWeight: FontWeight.w500,
              ),),
              centerTitle: true,
              ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: IngredientList(
                items: neededItems,
                title: "Needed Ingredients",
                onAdd: () {
                  setState(() {
                    neededItems.add({
                      "type": "New Type",
                      "name": "New Ingredient",
                      "amount": "0g",
                    });
                  });
                },
                onRemove: (index) {
                  setState(() {
                    neededItems.removeAt(index);
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
