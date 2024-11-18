import 'package:flutter/material.dart';
import 'package:food_app_flutter/src/core/constants.dart';
import 'package:food_app_flutter/src/core/containers/section_heading.dart';
import 'package:food_app_flutter/src/core/widgets/food_card.dart';
import 'package:food_app_flutter/src/features/favorites/my_preferences_page.dart';
import 'package:food_app_flutter/src/features/favorites/widgets/my_preferences.dart';
import 'package:food_app_flutter/src/models/food.dart';
import 'package:page_transition/page_transition.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final List<Food> _foodList = Food.foodList;

    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text("Account", style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontSize: 30
          ),),
        ),   
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, PageTransition(child: MypreferencesPage(), type: PageTransitionType.bottomToTop));
                    },
                    child: MyPreferences()
                    ),
                ),
                const SizedBox(height: 16,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 7.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'My Favorites',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextButton(
                        onPressed: (){

                        },
                        child: Text(
                          'View All',
                          style: TextStyle(
                            color: Constants.primaryColor
                            
                          ),
                        )
                      )
                    ],
                  ),
                ),
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
                    itemCount: _foodList.length,
                    itemBuilder: (context, index) {
                      final food = _foodList[index];
                      return FoodCard(food : food);
                    }
                            
                  ),
                ),
              ],
            )
          ),
        ),
      ),
    );
  }
}