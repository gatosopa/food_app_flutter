import 'package:flutter/material.dart';
import 'package:food_app_flutter/src/core/constants.dart';
import 'package:food_app_flutter/src/core/widgets/food_card.dart';
import 'package:food_app_flutter/src/models/food.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  //Suggestion List
  // ignore: prefer_final_fields
  List<String> _recipelist = [
    'Aglio e Olio',
    'Salad',
    'Fried Rice'
  ];

  //Suggestion for the search box based on query
  List<String> _filteredRecipes = [];

  //List to store related recipes based on selected or inputed query
  List<Food> _relatedRecipes = [];

  bool _showGrid = false;
  bool _isProgrammaticUpdate = false;
  final List<Food> _foodList = Food.foodList;

  @override
  void initState(){
    super.initState();
    _filteredRecipes = _recipelist;
    _controller.addListener(_onSearchChanged);
  }

  @override
  void dispose(){
    _controller.removeListener(_onSearchChanged);
    _controller.dispose();
    super.dispose();
  }

  //Query change, so suggestion dynamically displayed
  void _onSearchChanged(){
    if(_isProgrammaticUpdate) return;
    setState(() {
      if(_controller.text.isEmpty){
        //Empty search bar, show list again
        _showGrid = false;
        _filteredRecipes = _recipelist;
      }
      else{
        _filteredRecipes = _recipelist
        .where((item) =>
          item.toLowerCase().contains(_controller.text.toLowerCase())
        ).toList();

        if (_filteredRecipes.isNotEmpty){
          _showGrid = false;
        }
      }
      
    });
  }


  //User pick from suggestion
  void _onSuggestionSelected (String suggestion){
    
    setState((){
      _isProgrammaticUpdate = true; 
      _controller.text = suggestion;
      _relatedRecipes = _foodList
          .where((food) => food.foodName.toLowerCase().contains(suggestion.toLowerCase()))
          .toList();
      _showGrid = _filteredRecipes.isNotEmpty;
      _isProgrammaticUpdate = false; 

    });
  }

  //Enter
  void _onSearchSubmitted(String query){
    setState((){
      _controller.text = query;
      _relatedRecipes = _foodList
          .where((food) => food.foodName.toLowerCase().contains(query.toLowerCase()))
          .toList();
      
      _showGrid = _filteredRecipes.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          backgroundColor: Constants.backgroundColor,
          
          automaticallyImplyLeading: false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: (){
                      Navigator.pop(context);
                    }
                  , icon: Icon(Icons.keyboard_arrow_left, color: Constants.primaryColor,)
                  ),
                  Text("Search", style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 24
                  ),),

                ],
              ),

            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container( //Actual Search Box
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                      ),
                      width: size.width* 0.9,
                      
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(17),
                      ),
                    
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search, color:Colors.black54.withOpacity(.6),),
                          SizedBox(
                            width:20
                          ),
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              autofocus: true,
                              showCursor: true,
                              decoration: const InputDecoration(
                                hintText: 'Search the Foodie app',
                                hintStyle: TextStyle(color: Colors.black54),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                              onSubmitted: (query) {
                                _onSearchSubmitted(query);
                              },
                            ),
                            
                          ),
                          Icon(Icons.mic, color: Colors.black54.withOpacity(.6),),
                        ],
                      ),
                    
                    ),
                  
            SizedBox (height: 20,),
            //Show suggestion, not actual search result
            if(!_showGrid)
              Expanded(
                child: _filteredRecipes.isEmpty?
                Center(
                  child: Text(
                    'No recipe found',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ) : 
                ListView.builder(
                itemCount: _filteredRecipes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(
                      Icons.search,
                      color: Colors.black.withOpacity(.6),
                    ),
                    title: Text(_filteredRecipes[index]),
                    onTap: () => _onSearchSubmitted(_filteredRecipes[index]),
                  );
                },
                ),
              ),
            if(_showGrid)
              Padding(
                  padding: const EdgeInsets.symmetric(),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    itemCount: _relatedRecipes.length,
                    itemBuilder: (context, index) {
                      final food = _relatedRecipes[index];
                      return FoodCard(food : food);
                    }
                            
                  ),
                ),
          ],
        ),
      ),
    );
  }
}