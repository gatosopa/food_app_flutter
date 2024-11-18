import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/constants.dart';
import 'recipe_page.dart';

class EditablePage extends StatefulWidget {
  final String jsonData; // Pass JSON data as a string when creating this page

  EditablePage({required this.jsonData});

  @override
  _EditablePageState createState() => _EditablePageState();
}

class _EditablePageState extends State<EditablePage> {
  String? _userId; // User ID from Firebase
  List<TextEditingController> _controllers = [];
  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    _fetchUserId(); // Fetch the Firebase user ID
    print('EditablePage received jsonData: ${widget.jsonData}');
    try {
      final data = jsonDecode(widget.jsonData);
      final ingredients = List<String>.from(data['ingredients'] ?? []);
      print('Parsed ingredients: $ingredients');
      _controllers = ingredients.map((ingredient) => TextEditingController(text: ingredient)).toList();
    } catch (e) {
      print('Error decoding JSON or initializing ingredients: $e');
      _controllers = [];
    }
  }

  Future<void> _fetchUserId() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        setState(() {
          _userId = currentUser.uid; // Assign the user ID
        });
      }
    } catch (e) {
      print('Error fetching user ID: $e');
    }
  }

  @override
  void dispose() {
    // Dispose of controllers to free up memory
    _controllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  // Convert the edited list back to JSON format with userId
  String getEditedJson() {
    List<String> updatedIngredients = _controllers.map((controller) {
      String ingredient = controller.text.trim();
      return ingredient.replaceAll(RegExp(r'^\d+\.?\s*'), ''); // Remove leading numbers and dots
    }).toList();

    final updatedData = {
      'user_id': _userId, // Use Firebase user ID
      'ingredients': updatedIngredients,
    };
    return jsonEncode(updatedData);
  }

  // Function to send edited data to the server
  Future<void> sendEditedData() async {
    try {
      final editedJson = getEditedJson();
      final decodedData = jsonDecode(editedJson);

      final response = await _dio.post(
        '${Constants.serverIP}/submit_json', // Replace with your server endpoint
        data: decodedData, // Packaged in the updated JSON format
      );

      // Log the full server response
      print("Server Response: ${response.data}");

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Data sent successfully!")),
        );

        // Assuming the server response contains the recipe JSON data
        final jsonResponseFromServer = response.data; // Adjust as necessary if the data is wrapped

        // Navigate to RecipePage with the received JSON
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipePage(jsonData: jsonEncode(jsonResponseFromServer)),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to send data.")),
        );
      }
    } catch (e) {
      print("Error sending data: $e"); // Log the error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error sending data: $e")),
      );
    }
  }

  // Submit function now includes sending the data to the server
  void _submit() {
    sendEditedData(); // Call the function to send data to the server
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Slightly gray background
      body: CustomScrollView(
        slivers: [
          // SliverAppBar for the "FOODIE" app bar
          SliverAppBar(
            backgroundColor: Constants.primaryColor,
            expandedHeight: 110,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(),
              title: const Text(
                'F O O D I E',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              centerTitle: true,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Editable ingredients list
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _controllers.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white, // White rectangle
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: TextField(
                            controller: _controllers[index],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold, // Bold text for ingredient
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: 'Ingredient #${index + 1}',
                              labelStyle: const TextStyle(
                                color: Colors.red, // Red label text
                                fontWeight: FontWeight.bold,
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.grey),
                            onPressed: () {
                              setState(() {
                                _controllers.removeAt(index);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Ingredient removed.')),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text(
                      "Any undetected ingredients? Add More!",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Buttons for Add and Submit
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            // Add a new TextEditingController to the list for a new ingredient
                            _controllers.add(TextEditingController());
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Constants.primaryColor,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          "Add",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _submit, // Trigger the submit function
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Constants.primaryColor,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          "Find Recipes",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
