import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_app_flutter/src/features/favorites/health_page.dart';
import 'package:food_app_flutter/src/features/favorites/lifestyle_page.dart';
import 'package:food_app_flutter/src/features/favorites/price_page.dart';
import 'package:food_app_flutter/src/core/constants.dart';
import 'package:ionicons/ionicons.dart';
import 'package:page_transition/page_transition.dart';


class MypreferencesPage extends StatefulWidget {
  const MypreferencesPage({super.key});

  @override
  State<MypreferencesPage> createState() => _MypreferencesPageState();
}

class _MypreferencesPageState extends State<MypreferencesPage> {
  // Map to store diet preferences
  Map<String, Map<String, bool>> dietPreferences = {
    'Price': {'Cheap': false},
    'Health': {'Dairy-Free': false, 'Gluten-Free': false, 'Healthy': false},
    'Lifestyle': {'Ketogenic': false, 'Sustainable': false, 'Vegan': false, 'Vegetarian': false},
  };

  bool isLoading = true; // To handle loading state

  @override
  void initState() {
    super.initState();
    fetchPreferences();
  }

  Map<String, Map<String,bool>> convertToDietPreferences(Map<String, Map<String, bool>> dietPreferences, Map<String, bool> savedPreferences) {
    final updatedPreferences = {
      for(var category in dietPreferences.keys)
        category: {...dietPreferences[category]!}
    };
    
    savedPreferences.forEach((key, value) {
      updatedPreferences.forEach((category, preferences){
        if (preferences.containsKey(key)) {
          preferences[key] = value;
      }
      });
    });

    return updatedPreferences;
  }

  Map<String, bool> flattenDietPreferences(Map<String, Map<String, bool>> dietPreferences) {
    final Map<String, bool> flattenedPreferences = {};

    dietPreferences.forEach((category, preferences) {
      preferences.forEach((key, value) {
        flattenedPreferences[key] = value;
      });
    });

    return flattenedPreferences;
  }

  // Method to fetch preferences from Firestore
  Future<void> fetchPreferences() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User not signed in.");
      }

      final userId = user.uid;

      // Fetch preferences from Firestore
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        final savedPreferences =
            Map<String, bool>.from(data['dietPreferences'] ?? {});

        // Update the local dietPreferences map
        setState(() {
          dietPreferences = {
            ...dietPreferences, // Keep default preferences for missing keys
            ...convertToDietPreferences(dietPreferences, savedPreferences), // Overwrite with saved preferences
          };
          isLoading = false; // Disable loading
        });
      } else {
        setState(() {
          isLoading = false; // Disable loading even if no data exists
        });
      }
    } catch (e) {
      print("Error fetching preferences: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error fetching preferences.")),
      );
      setState(() {
        isLoading = false;
      });
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
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("My Preferences", style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black,
              fontSize: 30
            ),),
            const SizedBox(height: 20,),
            GestureDetector(
                    
              onTap: () async{
                await fetchPreferences();
                Navigator.push(context, PageTransition(child: PricePage(preferences: dietPreferences['Price']!), type: PageTransitionType.rightToLeft));
              },
              child: Container(
                width: double.infinity,
                child: Row(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue.shade100,
                      ),
                      child: Icon(Ionicons.pricetag, color: Colors.blue)
                    ),
                    const SizedBox(width: 20,),
                    Text(
                      "Price",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(Icons.keyboard_arrow_right, color: Constants.primaryColor)
                      ),
                    
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20,),
            GestureDetector(
              onTap: () async{
                await fetchPreferences();
                Navigator.push(context, PageTransition(child: HealthPage(preferences: dietPreferences['Health']!), type: PageTransitionType.rightToLeft));
              },
              child: Container(
                width: double.infinity,
                child: Row(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red.shade100,
                      ),
                      child: Icon(Ionicons.heart, color: Constants.primaryColor,)
                    ),
                    const SizedBox(width: 20,),
                    Text(
                      "Health",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                  
                   Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(Icons.keyboard_arrow_right, color: Constants.primaryColor)
                      ),
                    
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20,),
            GestureDetector(
              onTap: () async{
                await fetchPreferences();
                Navigator.push(context, PageTransition(child: LifestylePage(preferences: dietPreferences['Lifestyle']!), type: PageTransitionType.rightToLeft));
              },
              child: Container(
                width: double.infinity,
                child: Row(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green.shade100,
                      ),
                      child: Icon(Ionicons.medical, color: Colors.green,)
                    ),
                    const SizedBox(width: 20,),
                    Text(
                      "Lifestyle",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(Icons.keyboard_arrow_right, color: Constants.primaryColor)
                      ),
                    
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20,),
            
        
          ],
        ),
      ),
    );
  }
}
