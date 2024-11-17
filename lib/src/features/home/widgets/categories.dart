import 'package:flutter/material.dart';
import 'package:food_app_flutter/src/core/constants.dart';
import 'package:food_app_flutter/src/models/cuisine.dart';

class Categories extends StatelessWidget {
  const Categories({
    super.key,
    required this.currentCat,
  });

  final String currentCat;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          categories.length, 
          (index) => Container(
            decoration: BoxDecoration(
              color: currentCat==categories[index]? Constants.primaryColor : Colors.white,
              borderRadius: BorderRadius.circular(17),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            margin: EdgeInsets.only(left: index== 0 ? 20: 0, right : index== categories.length-1? 20 : 10),
            child: Text(categories[index],
            style: TextStyle(
              color: currentCat == categories[index]? Constants.secondaryColoer : Colors.black
            )),
          ),
        ),
      ),
    );
  }
}