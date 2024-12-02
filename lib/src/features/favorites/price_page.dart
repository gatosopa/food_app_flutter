import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_app_flutter/src/core/constants.dart';

class PricePage extends StatefulWidget {
  const PricePage({super.key, required this.preferences});
  final Map<String, bool> preferences;

  @override
  State<PricePage> createState() => _PricePageState();
}

class _PricePageState extends State<PricePage> {
  late bool cheap;

  void initState() {
    super.initState();
    cheap = widget.preferences['Cheap'] ?? false;
  }
  // Method to handle saving preferences to Firestore
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
            'dietPreferences': {'Cheap': cheap},
          }, SetOptions(merge: true)); // Use merge to keep existing data intact

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preferences saved!")),
      );
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
              Text("Price", style: TextStyle(
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
                        title: Text("Cheap", style: 
                        TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400
                        ),),
                        trailing: Switch.adaptive(
                          value: cheap,
                          activeColor: Constants.primaryColor,
                          onChanged: (value) async{
                            setState(() {
                              cheap= value;
                            });

                            await savePreferences();
                          },
                        ),
                      ),
                    ),
                  
                
          
              const SizedBox(height: 10,),
              Text(
                "Affordable options that offer good value without compromising quality.",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}