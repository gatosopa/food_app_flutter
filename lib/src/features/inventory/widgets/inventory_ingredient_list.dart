import 'package:flutter/material.dart';
import 'package:food_app_flutter/src/core/constants.dart';

class InventoryIngredientlist extends StatefulWidget {
  final Function(List<String>) onUpdateSelectedItems; 
  final List<Map<String, dynamic>> ingredients;
  final bool isLoading;
  // Callback to update selected items
  const InventoryIngredientlist({super.key, required this.onUpdateSelectedItems, required this.ingredients, required this.isLoading});

  @override
  State<InventoryIngredientlist> createState() => _InventoryIngredientlistState();
}

class _InventoryIngredientlistState extends State<InventoryIngredientlist> {
  List<Map<String, dynamic>> items = [];
  final List<String> selectedItems = [];

  @override
  void initState() {
    super.initState();
    items = widget.ingredients;
  }



  void _removeItem(int index) {
    setState(() {
      items.removeAt(index);
    });
    widget.onUpdateSelectedItems(items.map((item) => item['name'] as String).toList());
  }

  @override
  Widget build(BuildContext context) {
    return widget.isLoading
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];

              return Dismissible(
                key: ValueKey(item['name']), // Use a unique key
                background: Container(
                  color: Constants.backgroundColor,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 16.0),
                  child:  Icon(Icons.delete, color: Constants.primaryColor),
                ),
                secondaryBackground: Container(
                  color: Constants.backgroundColor,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Icon(Icons.delete, color: Constants.primaryColor),
                ),
                onDismissed: (direction) {
                  _removeItem(index);
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Card(
                    color: Colors.white,
                    elevation: 2.0,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Item Info Section
                          Text(
                            item['name'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          // Placeholder for extra actions
                        
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
  }
}
