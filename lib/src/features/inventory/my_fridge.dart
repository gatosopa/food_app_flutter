import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_app_flutter/src/core/constants.dart';
import 'package:food_app_flutter/src/features/inventory/widgets/inventory_ingredient_list.dart';

class MyFridge extends StatefulWidget {
  const MyFridge({super.key});

  @override
  State<MyFridge> createState() => _MyFridgeState();
}

class _MyFridgeState extends State<MyFridge> {
  final List<Map<String, dynamic>> items = [];
  bool isEditMode = false;
  List<String> selectedItems = [];
  List<String> newIngredients = [];
  List<String> fridgeIngredients = [];
  bool isLoading = true;

  void toggleEditMode() {
    setState(() {
      isEditMode = !isEditMode;
      if (!isEditMode) {
        selectedItems.clear();
        
      }
    });
  }

  void saveSelectedItems() {
    setState(() {
    // Combine new ingredients with existing fridge ingredients
    fridgeIngredients.addAll(newIngredients);

    // Clear newIngredients after saving
    newIngredients.clear();
    items.clear();
    items.addAll(fridgeIngredients.map((ingredient) {
      return {"type": "?", "name": ingredient, "amount": "?"};
    }).toList());
  
  });

  // Save to Firestore
  _saveIngredientsToFirestore();
  }
  @override 
  void initState(){
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
        fridgeIngredients = List<String>.from(userDoc['fridge_ingredients'] ?? []);
        setState(() {
          items.addAll(fridgeIngredients.map((ingredient) {
            return {"type": "?", "name": ingredient, "amount": "?"};
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

  void _updateIngredients(List<String> updatedIngredients) {
    setState(() {
      fridgeIngredients = updatedIngredients;
    });

    // Optionally, update Firestore with the new list
    _saveIngredientsToFirestore();
  }

  Future<void> _saveIngredientsToFirestore() async {
    try {
      // Get the currently logged-in user's ID
      String? userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null) {
        throw Exception("No user is currently logged in.");
      }

      // Update the user document in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'fridge_ingredients': fridgeIngredients});
    } catch (e) {
      print("Error saving fridge ingredients to Firestore: $e");
    }
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
                      color: Constants.secondaryColor.withOpacity(0.7),
                      fontSize: 12,
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
          if (!isEditMode)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: InventoryIngredientlist(
                  ingredients: items,
                  onUpdateSelectedItems: _updateIngredients,
                  isLoading: isLoading,
                ),
              ),
            ),
          if (isEditMode)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: newIngredients.length + 1,
                      itemBuilder: (context, index) {
                        if (index == newIngredients.length) {
                          String newIngredient = "";
                          return ListTile(
                            leading: IconButton(
                              icon: Icon(Icons.add, color: Constants.primaryColor),
                              onPressed: (){
                                if (newIngredient.isNotEmpty) {
                                  setState(() {
                                    newIngredients.add(newIngredient);
                                  });
                                  newIngredient = ""; // Clear the temporary variable
                                };
                              }
                            ),
                            title: TextField(
                              decoration: const InputDecoration(
                                hintText: 'Enter ingredient name',
                              ),
                              onChanged: (value) {
                                newIngredient = value;
                              },
                              onSubmitted: (value) {
                                if (value.isNotEmpty) {
                                  setState(() {
                                    newIngredients.add(value);
                                  });
                                }
                              },
                            ),
                          );
                        } else {
                          return ListTile(
                            leading: Icon(Icons.circle, color: Constants.primaryColor),
                            title: Text(newIngredients[index]),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  newIngredients.removeAt(index);
                                });
                              },
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        saveSelectedItems();
                        toggleEditMode(); // Exit edit mode after saving
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constants.primaryColor,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "Save Changes",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: (){
                      setState(() {
                        newIngredients.clear();
                      });
                      toggleEditMode();

                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Constants.primaryColor,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      isEditMode ? "Cancel" : "Edit",
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
