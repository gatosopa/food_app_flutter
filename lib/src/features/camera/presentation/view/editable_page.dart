import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../../core/constants.dart';
import 'recipe_page.dart';

class EditablePage extends StatefulWidget {
  final String jsonData; // Pass JSON data as a string when creating this page

  EditablePage({required this.jsonData});

  @override
  _EditablePageState createState() => _EditablePageState();
}

class _EditablePageState extends State<EditablePage> {
  List<TextEditingController> _controllers = [];
  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    // Parse the JSON and initialize controllers for each ingredient
    final data = jsonDecode(widget.jsonData);
    List<String> ingredients = List<String>.from(data['ingredients']);
    _controllers = ingredients.map((ingredient) => TextEditingController(text: ingredient)).toList();
  }

  @override
  void dispose() {
    // Dispose of controllers to free up memory
    _controllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  // Convert the edited list back to JSON format
String getEditedJson() {
  List<String> updatedIngredients = _controllers.map((controller) {
    String ingredient = controller.text.trim();
    return ingredient.replaceAll(RegExp(r'^\d+\.?\s*'), ''); // Remove leading numbers and dots
  }).toList();
  
  final updatedData = {'message': {'ingredients': updatedIngredients}};
  return jsonEncode(updatedData);
}


  // Function to send edited data to the server
  Future<void> sendEditedData() async {
  try {
    final editedJson = getEditedJson();
    final decodedData = jsonDecode(editedJson);

    final response = await _dio.post(
      '${Constants.serverIP}/submit_json', // Replace with your server endpoint
      data: {'message': decodedData}, // Packaged in the same JSON format
    );

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
      appBar: AppBar(
        title: Text('Edit Ingredients'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _submit, // Trigger the submit function on save
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _controllers.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _controllers[index],
              decoration: InputDecoration(
                labelText: 'Ingredient ${index + 1}',
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            // Add a new TextEditingController to the list for a new ingredient
            _controllers.add(TextEditingController());
          });
        },
        child: Icon(Icons.add),
        tooltip: 'Add Ingredient',
      ),
    );
  }
}
