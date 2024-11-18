import 'package:flutter/material.dart';
import 'login_page.dart';
import 'register_page.dart';

class loginOrRegisterPage extends StatefulWidget {
  const loginOrRegisterPage({super.key});

  @override
  State<loginOrRegisterPage> createState() => _loginOrRegisterPageState();
}

class _loginOrRegisterPageState extends State<loginOrRegisterPage> {

  bool showLoginPage = true;

  void togglePages(){
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context){
    if (showLoginPage){
      return LoginPage(
        onTap: togglePages,
      );
    } else {
      return RegisterPage(
        onTap: togglePages,
      );
    }
  }
}