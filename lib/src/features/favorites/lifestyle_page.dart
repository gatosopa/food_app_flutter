import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_app_flutter/src/core/constants.dart';

class LifestylePage extends StatefulWidget {
  const LifestylePage({super.key, required this.preferences});
  final Map<String, bool> preferences;

  @override
  State<LifestylePage> createState() => _LifestylePageState();
}

class _LifestylePageState extends State<LifestylePage> {
  late bool ketogenic;
  late bool sustainable;
  late bool vegan;
  late bool vegetarian;


  void initState() {
    super.initState();
    ketogenic = widget.preferences['Ketogenic'] ?? false;
    sustainable = widget.preferences['Sustainable'] ?? false;
    vegan = widget.preferences['Vegan'] ?? false;
    vegetarian = widget.preferences['Vegetarian'] ?? false;
  }

  Future<void> savePreferences() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User not signed in.");
      }

      final userId = user.uid;

      // Save preferences under /users/{userId}
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .set({
            'dietPreferences': {
              'Ketogenic': ketogenic,
              'Sustainable': sustainable,
              'Vegan': vegan, 
              'Vegetarian': vegetarian,
            },
          }, SetOptions(merge: true)); // Use merge to keep existing data intact

      
    } catch (e) {
      print("Error saving preferences: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error saving preferences.")),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      appBar: AppBar(
        backgroundColor: Constants.backgroundColor,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.keyboard_arrow_left, color: Constants.primaryColor),
        ),
        leadingWidth: 100,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Lifestyle", style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontSize: 30
              ),),
              const SizedBox(height: 20,),
        
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12, // Shadow color
                            blurRadius: 4, // Blur radius
                            offset: Offset(2, 2), 
                          )
                        ]
                      ),
                      child: ListTile(
                        title: Text("Ketogenic", style: 
                        TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400
                        ),),
                        trailing: Switch.adaptive(
                          value: ketogenic,
                          activeColor: Constants.primaryColor,
                          onChanged: (value) async{
                            setState(() {
                              ketogenic = value;
                            });
                            await savePreferences();
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Text(
                      "A low-carb, high-fat diet designed to promote fat burning and ketosis.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 20,),
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12, // Shadow color
                            blurRadius: 4, // Blur radius
                            offset: Offset(2, 2), 
                          )
                        ]
                      ),
                      child: ListTile(
                        title: Text("Sustainable", style: 
                        TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400
                        ),),
                        trailing: Switch.adaptive(
                          value: sustainable,
                          activeColor: Constants.primaryColor,
                          onChanged: (value) async{
                            setState(() {
                              sustainable = value;
                            });
                            await savePreferences();
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Text(
                      "Focuses on environmentally-friendly practices and reducing ecological impact.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 20,),
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12, // Shadow color
                            blurRadius: 4, // Blur radius
                            offset: Offset(2, 2), 
                          )
                        ]
                      ),
                      child: ListTile(
                        title: Text("Vegan", style: 
                        TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400
                        ),),
                        trailing: Switch.adaptive(
                          value: vegan,
                          activeColor: Constants.primaryColor,
                          onChanged: (value) async{
                            setState(() {
                              vegan = value;
                            });
                            await savePreferences();
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Text(
                      "Excludes all animal products for ethical, environmental, and health reasons.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 20,),
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12, // Shadow color
                            blurRadius: 4, // Blur radius
                            offset: Offset(2, 2), 
                          )
                        ]
                      ),
                      child: ListTile(
                        title: Text("Vegetarian", style: 
                        TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400
                        ),),
                        trailing: Switch.adaptive(
                          value: vegetarian,
                          activeColor: Constants.primaryColor,
                          onChanged: (value) async{
                            setState(() {
                              vegetarian = value;
                            });
                            await savePreferences();
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Text(
                      "A plant-based diet that avoids meat and fish but may include dairy and eggs.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 20,),
                 
            ],
          ),
        ),
      ),
    );
  }
}