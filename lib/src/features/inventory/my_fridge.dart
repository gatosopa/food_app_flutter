import 'package:flutter/material.dart';
import 'package:food_app_flutter/src/core/constants.dart';
import 'package:food_app_flutter/src/features/inventory/widgets/inventory_ingredient_list.dart';

class MyFridge extends StatefulWidget {
  const MyFridge({super.key});

  @override
  State<MyFridge> createState() => _MyFridgeState();
}

class _MyFridgeState extends State<MyFridge> {
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
                // Act as a back button
                Navigator.pop(context);
              },
              icon: Icon(Icons.keyboard_arrow_left, color: Constants.secondaryColor),
            ),
            expandedHeight: 110,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'MYFRIDGE',
                    style: TextStyle(
                      color: Constants.secondaryColor.withOpacity(0.7), // Optional: Adjust color and opacity
                      fontSize: 12, // Smaller font for extra title
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    'F O O D I E',
                    style: TextStyle(
                      color: Constants.secondaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              centerTitle: true,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: const InventoryIngredientlist(), // Display ingredient list
            ),
          )
        ],
      ),
    );
  }
}
