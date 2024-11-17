import 'package:flutter/material.dart';
import 'package:food_app_flutter/src/core/constants.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
        backgroundColor: Constants.primaryColor,
      ),
    );
  }
}
