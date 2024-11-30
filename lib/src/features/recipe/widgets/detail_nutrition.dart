import 'package:flutter/material.dart';

class DetailNutrition extends StatelessWidget {
  const DetailNutrition({super.key,});

  @override
  Widget build(BuildContext context) {

    final List<Map<String, dynamic>> nutritionItems = [
    {'icon': Icons.grain, 'label': '65g carbs'},
    {'icon': Icons.egg, 'label': '27g proteins'},
    {'icon': Icons.local_fire_department, 'label': '120 Kcal'},
    {'icon': Icons.local_pizza_rounded, 'label': '91g fats'},
    ];

    return Container(
      padding: EdgeInsets.all(0),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 2,
        mainAxisSpacing: 16.0,
        crossAxisSpacing: 16.0,
        childAspectRatio: 3,
        children: nutritionItems.map((item){
          return Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Color(0xfff2f2f7),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Icon(
                  item['icon'],
                  color: Colors.black,
                  size: 24.0,
                ),
              ),
              SizedBox(width: 8.0,),
              Expanded(
                child: Text(
                  item['label'],
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              )
      
            ],);
        }). toList(),
      ),
    );
     /*Row(
       children: [
         Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            
            ),
          ),
       ],
     );*/
  }
}

