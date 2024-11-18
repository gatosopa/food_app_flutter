import 'package:flutter/material.dart';
import 'package:food_app_flutter/src/core/constants.dart';
import 'package:food_app_flutter/src/features/login/login_page.dart';
import 'package:food_app_flutter/src/features/login/register_page.dart';

class LoginSignup extends StatefulWidget {
  const LoginSignup({super.key});

  @override
  State<LoginSignup> createState() => _LoginSignupState();
}

class _LoginSignupState extends State<LoginSignup> {
  bool showLoginPage = true;
  void togglePages(){
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }
   @override
    Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.primaryColor, // Background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
    
            Container(
              
              decoration: BoxDecoration(
                color: Colors.white, // Circle background
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Image.asset('assets/image/foodie_logo.png',
                  width: 300,
                  height: 300,
                  ),
                
              ),
            ),
            const SizedBox(height: 20), // Space between circle and text
            Text(
              'Start your cooking journey with \n Foodie now!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30), // Space between text and buttons

            // Log In Button
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  // Log in action
                  setState(() {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginPage(onTap: togglePages,)));
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Constants.secondaryColor, // Button background color
                  foregroundColor: Constants.primaryColor, // Button text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  'Log In',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),

            const SizedBox(height: 10), // Space between buttons

            // Sign Up Button
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => RegisterPage(onTap: togglePages,)));
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Constants.secondaryColor, // Button background color
                  foregroundColor: Constants.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}