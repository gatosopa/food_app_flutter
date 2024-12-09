import 'package:flutter/foundation.dart';

class FoodNotifier extends ChangeNotifier {
  void refresh(){
    notifyListeners();
  }
}

final foodNotifier = FoodNotifier();