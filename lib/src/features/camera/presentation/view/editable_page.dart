import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/constants.dart';
import 'recipe_page.dart';

class EditablePage extends StatefulWidget {
  final String jsonData;

  EditablePage({required this.jsonData});

  @override
  _EditablePageState createState() => _EditablePageState();
}

class _EditablePageState extends State<EditablePage> {
  String? _userId;
  List<TextEditingController> _controllers = [];
  final Dio _dio = Dio();
  bool _isLoading = false; // Controls the loading spinner

  @override
  void initState() {
    super.initState();
    _fetchUserId();
    try {
      final data = jsonDecode(widget.jsonData);
      final ingredients = List<String>.from(data['ingredients'] ?? []);
      _controllers = ingredients.map((ingredient) => TextEditingController(text: ingredient)).toList();
    } catch (e) {
      _controllers = [];
    }
  }

  Future<void> _fetchUserId() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null && mounted) {
        setState(() {
          _userId = currentUser.uid;
        });
      }
    } catch (e) {
      print('Error fetching user ID: $e');
    }
  }

  @override
  void dispose() {
    _controllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  String getEditedJson() {
    List<String> updatedIngredients = _controllers.map((controller) {
      return controller.text.trim().replaceAll(RegExp(r'^\d+\.?\s*'), '');
    }).toList();

    return jsonEncode({
      'user_id': _userId,
      'ingredients': updatedIngredients,
    });
  }

  Future<void> sendEditedData() async {
    setState(() {
      _isLoading = true; // Show the loading spinner
    });

    try {
      final editedJson = getEditedJson();
      final decodedData = jsonDecode(editedJson);
      print(editedJson);

      final response = await _dio.post(
        '${Constants.serverIP}/submit_json',
        data: decodedData,
      );

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Data sent successfully!")),
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipePage(jsonData: jsonEncode(response.data)),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to send data.")),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error sending data: $e")),
        );
      }
    } finally {
      setState(() {
        _isLoading = false; // Hide the loading spinner
      });
    }
  }

  void _submit() {
    sendEditedData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
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
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _controllers.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
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
                                style: const TextStyle(fontWeight: FontWeight.bold),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Ingredient #${index + 1}',
                                  labelStyle: const TextStyle(
                                    color: Colors.red,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
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
                            onPressed: _submit,
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
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
