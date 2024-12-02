import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:food_app_flutter/src/core/constants.dart';
import 'package:food_app_flutter/src/core/widgets/food_card.dart';
import 'package:food_app_flutter/src/models/food.dart';
import 'package:food_app_flutter/src/models/recipe_model.dart';
import 'package:food_app_flutter/src/features/recipe/recipe_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  final Dio _dio = Dio(); // For HTTP requests

  List<String> _recipelist = ['Aglio e Olio', 'Salad', 'Fried Rice'];
  List<String> _filteredRecipes = [];
  bool _isLoading = false;
  bool _isProgrammaticUpdate = false;

  @override
  void initState() {
    super.initState();
    _filteredRecipes = _recipelist;
    _controller.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onSearchChanged);
    _controller.dispose();
    super.dispose();
  }

  // Query change, so suggestions dynamically displayed
  void _onSearchChanged() {
    if (_isProgrammaticUpdate) return;
    setState(() {
      if (_controller.text.isEmpty) {
        _filteredRecipes = _recipelist;
      } else {
        _filteredRecipes = _recipelist
            .where((item) => item.toLowerCase().contains(_controller.text.toLowerCase()))
            .toList();
      }
    });
  }

  // Backend Integration: Send search query with logging
  Future<void> sendSearchQuery(String keyword, int number) async {
    setState(() {
      _isLoading = true;
    });

    final requestData = {
      'keyword': keyword,
      'number': number,
    };

    // Log the request data
    print("Sending data to backend: $requestData");

    try {
      final response = await _dio.post(
        '${Constants.serverIP}/recipes/search',
        data: requestData,
        options: Options(
          headers: {
            'Content-Type': 'application/json', // Ensure JSON format
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        print("Received response from backend: $data");

        // Navigate to RecipePage with the response data
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipePage(jsonData: jsonEncode(data['recipes'])),
            ),
          );
        }
      } else {
        print("Failed to fetch recipes. Status Code: ${response.statusCode}");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to fetch recipes.")),
        );
      }
    } catch (e) {
      print("Error sending data to backend: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching recipes: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // User picks a suggestion
  void _onSuggestionSelected(String suggestion) {
    setState(() {
      _isProgrammaticUpdate = true;
      _controller.text = suggestion;
    });

    FocusScope.of(context).unfocus();
    sendSearchQuery(suggestion, 2);
    setState(() {
      _isProgrammaticUpdate = false;
    });
  }

  // User submits a query
  void _onSearchSubmitted(String query) {
    FocusScope.of(context).unfocus();
    sendSearchQuery(query, 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      appBar: AppBar(
        backgroundColor: Constants.backgroundColor,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.keyboard_arrow_left, color: Constants.primaryColor),
            ),
            const Text(
              "Search",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Search for recipes...',
                border: OutlineInputBorder(),
              ),
              onSubmitted: _onSearchSubmitted,
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Expanded(
                child: _filteredRecipes.isEmpty
                    ? const Center(
                        child: Text(
                          'No suggestions available',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _filteredRecipes.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(_filteredRecipes[index]),
                            onTap: () => _onSuggestionSelected(_filteredRecipes[index]),
                          );
                        },
                      ),
              ),
          ],
        ),
      ),
    );
  }
}
