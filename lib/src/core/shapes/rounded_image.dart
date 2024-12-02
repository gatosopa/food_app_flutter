import 'package:flutter/material.dart';
import 'package:food_app_flutter/src/core/constants.dart';
import 'package:food_app_flutter/src/features/recipe/detail_page.dart';
import 'package:food_app_flutter/src/models/food.dart';
import 'package:page_transition/page_transition.dart';
import 'package:food_app_flutter/src/models/recipe_model.dart';

class RoundedImage extends StatelessWidget {
  const RoundedImage({
    super.key, 
    this.width, 
    this.height,  
    this.applyImageRadius = true, 
    this.border, 
    this.backgroundColor = Colors.transparent, 
    this.fit = BoxFit.cover, 
    this.padding, 
    this.isNetworkImage = false, 
    this.onPressed, 
    this.borderRadius = 20,
    required this.food,
  });

  final double? width, height;
  final Food food;
  final bool applyImageRadius;
  final BoxBorder? border;
  final Color backgroundColor;
  final BoxFit? fit;
  final EdgeInsetsGeometry? padding;
  final bool isNetworkImage;
  final VoidCallback? onPressed;
  final double borderRadius;


  @override
  Widget build(BuildContext context) {
    
    
    bool toggleIsFavorated(bool isFavorited){
      return !isFavorited;
    }

    return GestureDetector(
      onTap: () {
        final recipe = Recipe(
          id: food.foodId,
          title: food.foodName,
          image: food.imageUrl,
          calories: food.foodCalories,
          existingIngredients: [], // Populate appropriately
          nonExistingIngredients: [], // Populate appropriately
          nutrients: [], // Populate appropriately
          steps: food.steps,
          cuisineType: 'Unknown', // Populate appropriately
          cookingTime: null, // Populate appropriately
        );

        Navigator.push(
          context,
          PageTransition(
            child: DetailPage(recipe: recipe),
            type: PageTransitionType.bottomToTop,
          ),
        );
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: double.infinity,
        height: height,
        margin: EdgeInsets.only(bottom: 5),
        padding: padding,
        decoration: BoxDecoration(
          border: border, 
          color: Colors.white, 
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 20,
              offset: Offset(0, 5)
            )
          ]
        ),
        child: SingleChildScrollView(
          child: Stack(
            children: [
              
              Column(
              children: [
                Container(
                  clipBehavior: Clip.hardEdge,
                  height: 320,
                  width: 400,
                  margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadius)
                  ),
                  child: Image(fit: fit, image: isNetworkImage? NetworkImage(food.imageUrl) : AssetImage(food.imageUrl) as ImageProvider),
                ),
                SizedBox(height: 30,),
                Text(food.foodName, style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  
                  ),
                ),
                SizedBox(height: 15,),
                
              ]
            ),

            Positioned(
                top : 20,
                right: 20,
                child: Container(
                  height: 50,
                  width: 50,
                  
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    
                  ),

                  child: IconButton(
                    onPressed: (){
                      bool isFavorited = toggleIsFavorated(food.isFavorated);
                      food.isFavorated = isFavorited;
                    },
                    icon: Icon(food.isFavorated == true ? Icons.favorite : Icons.favorite_border, color: Constants.primaryColor,),
                    color: Constants.primaryColor,
                    iconSize: 30,
                  ),
                )
              ),

             
            ]
          ),
        ),
      ),
    );
  }
}