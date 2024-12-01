
import 'package:flutter/material.dart';
import 'package:food_app_flutter/src/core/constants.dart';
import 'package:food_app_flutter/src/features/home/recipe_view_all_page.dart';
import 'package:food_app_flutter/src/features/home/widgets/categories.dart';
import 'package:food_app_flutter/src/features/home/widgets/food_slider.dart';
import 'package:food_app_flutter/src/models/cuisine.dart';
import 'package:food_app_flutter/src/models/food.dart';
import 'package:iconsax/iconsax.dart';
import 'package:food_app_flutter/src/core/containers/section_heading.dart';
import 'package:page_transition/page_transition.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});



  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
    
    List<Food> _foodList = [];
    List<Food> filteredFoodList = []; 
    String selectedCategory = categories[0]; //default


    //Load food recipe
    @override
    void initState() {
      super.initState();
      _foodList = Food.foodList;
      _filterFoodList();
    }

    //Filter food recipe mechanism
    void _filterFoodList() {
      setState(() {
        if (selectedCategory == 'All') {
          // Show all food
          filteredFoodList = List.from(_foodList);
        } else {
          filteredFoodList = _foodList.where((food) {
            final diet = food.diet;

            if (selectedCategory == 'Cheap') {
              return diet['isCheap'] ?? false;
            } else if (selectedCategory == 'Dairy Free') {
              return diet['isDairyFree'] ?? false;
            } else if (selectedCategory == 'Gluten Free') {
              return diet['isGlutenFree'] ?? false;
            } else if (selectedCategory == 'Ketogenic') {
              return diet['isKetogenic'] ?? false;
            } else if (selectedCategory == 'Sustainable') {
              return diet['isSustainable'] ?? false;
            } else if (selectedCategory == 'Vegan') {
              return diet['isVegan'] ?? false;
            } else if (selectedCategory == 'Vegetarian') {
              return diet['isVegetarian'] ?? false;
            } else if (selectedCategory == 'Healthy') {
              return diet['isHealthy'] ?? false;
            }
            return false;
          }).toList();
        }
      });
      print('Filtered food list: $filteredFoodList'); // Debugging
    }

    //Callback function for category
    void _onCategorySelected(String category){
      setState(() {
        selectedCategory = category;
      });
      _filterFoodList();
    }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      body: CustomScrollView(
        slivers: <Widget>[
          //Sliver app bar
          SliverAppBar(
            backgroundColor: Constants.primaryColor,
            leading: Icon(Icons.menu),
            
            expandedHeight: 110,
            
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
              
              ),
              title: Text('F O O D I E',
                style: TextStyle(
                  color: Constants.secondaryColor,
                  fontWeight: FontWeight.w500
                ),),
              centerTitle: true,
            ),
          ),


          //Sliver items
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container( //Actual Search Box
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                    ),
                    width: size.width * .9,
                    
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
                        const Expanded(
                          child: TextField(
                            showCursor: false,
                            decoration: InputDecoration(
                              hintText: 'Find a Famous Recipe',
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                          ),
                        ),
                        Icon(Icons.mic, color: Colors.black54.withOpacity(.6),),
                      ],
                    ),

                  )
                ],
              ),
            ),
          ), 
            //Today's Chef Picks
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: Column(
                children: [
                  Container( 
                    margin: const EdgeInsets.only(left: 20),
                    child: SectionHeading(title: 'Today\'s Chef Picks' , showActionButton: false,)
                    ), //Heading
                  const SizedBox(height: 16,),
                  Padding(
                    padding: const EdgeInsets.all(1),
                    child: FoodSlider(banners: _foodList)
                  )
                  
                ],
              ),
              )
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(left: 20,right: 20),
                child: Text("Categories",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 50),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Categories(
                      currentCat: selectedCategory,
                      onCategorySelected: _onCategorySelected,
                    ),
                    
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            "All in one!",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: TextButton(
                            onPressed: (){
                              Navigator.push(context, PageTransition(child: RecipeViewallPage(foodList : filteredFoodList), type: PageTransitionType.rightToLeft));
                            }, 
                            child: 
                            Text("View All", style: TextStyle(color: Constants.primaryColor,)),
                          ),
                        ),
                      ],),
                      const SizedBox(height: 20),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: filteredFoodList.isEmpty? [Center(child: Text('No recipe found for this category!'),)] : 
                        List.generate(filteredFoodList.length, (index) => 
                        
                        Container(
                          margin: EdgeInsets.only(left: index== 0 ? 20: 0, right : index== _foodList.length-1? 20 : 10),
                          width: 200,
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: 130,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(image: AssetImage(filteredFoodList[index].imageUrl), fit: BoxFit.cover)
                                    ),
                                  ),
                                  const SizedBox (height: 8),
                                  Text(filteredFoodList[index].foodName, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                                  const SizedBox (height: 5),

                                  Row(
                                    children: [
                                      Icon(
                                        Iconsax.flash_1,
                                        size: 18,
                                        color: Colors.grey),
                                      Text("${filteredFoodList[index].foodCalories} Cal", style: TextStyle(fontSize: 12, color: Colors.grey),),
                                    ],
                                  )
                                ],
                               
                              ),

                              Positioned(
                                top : 1,
                                right: 1,
                                  child: IconButton(
                                    onPressed: (){  
                                    },
                                    style: IconButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      fixedSize: const Size(30,30)
                                    ),
                                    icon: Icon(filteredFoodList[index].isFavorated == true ? Icons.favorite : Icons.favorite_border, color: Constants.primaryColor,),
                                    color: Constants.primaryColor,
                                    iconSize: 20,
                                  ),
                              ),
                            ],
                            
                          ),
                        )),
                        ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
    );
    
  }
}
