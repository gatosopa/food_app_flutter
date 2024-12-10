import 'package:flutter/material.dart';

class ProfileNotifier extends ChangeNotifier{
  void refresh(){
    notifyListeners();
  }
}

final profileNotifier = ProfileNotifier();