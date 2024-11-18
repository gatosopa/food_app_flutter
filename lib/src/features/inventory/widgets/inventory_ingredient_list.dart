import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_app_flutter/src/core/constants.dart';

class InventoryIngredientlist extends StatefulWidget {
  const InventoryIngredientlist({super.key});

  @override
  State<InventoryIngredientlist> createState() => _InventoryIngredientlistState();
}

class _InventoryIngredientlistState extends State<InventoryIngredientlist> {
  final List<Map<String, dynamic>> items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFridgeIngredients();
  }

  Future<void> _fetchFridgeIngredients() async {
    try {
      // Get the currently logged-in user's ID
      String? userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null) {
        throw Exception("No user is currently logged in.");
      }

      // Fetch user document from Firestore
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(userId).get();

      if (userDoc.exists) {
        final fridgeIngredients = List<String>.from(userDoc['fridge_ingredients'] ?? []);
        setState(() {
          items.addAll(fridgeIngredients.map((ingredient) {
            return {
              "type": "?",
              "name": ingredient,
              "amount": "?",
            };
          }).toList());
          isLoading = false;
        });
      } else {
        throw Exception("User document does not exist.");
      }
    } catch (e) {
      print("Error fetching fridge ingredients: $e");
      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Card(
                      color: Colors.white,
                      elevation: 2.0,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Item Info Section
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "ITEM TYPES (${item['type'].toUpperCase()})",
                                  style: TextStyle(
                                    color: Constants.primaryColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4.0),
                                Text(
                                  item['name'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4.0),
                                Text(
                                  item['amount'],
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            // Action Buttons Section
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    // Handle reduce amount
                                  },
                                  icon: Icon(Icons.remove, color: Constants.primaryColor),
                                ),
                                IconButton(
                                  onPressed: () {
                                    // Handle increase amount
                                  },
                                  icon: Icon(Icons.add, color: Constants.primaryColor),
                                ),
                              ],
                            ),
                          ],
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
