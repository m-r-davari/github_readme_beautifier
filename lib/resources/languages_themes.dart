
import 'package:flutter/material.dart';

class LanguagesThemes {

  LanguagesThemes._();
  static LanguagesThemes instance = LanguagesThemes._();

  Map<String,Color> languagesColors = {
    'dart' : Colors.green,
    'c++' : Colors.purple,
    'cmake' : Colors.red,
    'html' : Colors.pink,
    'other' : Colors.grey
  };

}