import 'package:flutter/material.dart';
import 'package:food_app_flutter/src/core/constants.dart';

class MyPreferences extends StatefulWidget {
  const MyPreferences({super.key});

  @override
  State<MyPreferences> createState() => _MyPreferencesState();
}

class _MyPreferencesState extends State<MyPreferences> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
      padding: const EdgeInsets.all(12.0),
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5.0,
            offset: Offset(0, 2)
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage('assets/image/pasta.jpg'),
          ),
          SizedBox(width: 16.0,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Oswaldo Dylan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                'My Preferences',
                style: TextStyle(
                  fontSize: 14,
                  color: Constants.primaryColor
                ),
              )
            ],
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.all(3.0),
            decoration: BoxDecoration(
            color: Constants.primaryColor,
            borderRadius: BorderRadius.circular(10.0),
            ),
            child: Icon(
              Icons.arrow_forward,
              color: Constants.secondaryColor,
            ),
          )
          
        ],
        
      
      ),
    );
  }
}