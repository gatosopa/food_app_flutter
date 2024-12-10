import 'package:flutter/material.dart';

class FavoriteNotifier extends ChangeNotifier{
  void refresh(){
    notifyListeners();
  }
}

final favoriteNotifier = FavoriteNotifier();