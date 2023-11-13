import 'package:flutter/material.dart';

class AudioModelProvider with ChangeNotifier {
  int _id = 0;

  int get id => _id;

  void setId(int id) {
    _id = id;
    notifyListeners();
  }
}