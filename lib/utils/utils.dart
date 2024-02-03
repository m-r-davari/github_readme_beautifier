import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:github_readme_beautifier/utils/const_keeper.dart';

class Utils {

  int generateRandomNumFromRange(int min, int max){
    return Random.secure().nextInt(max) + min ;
  }

  double generateUniqueRandomDouble(double min, double max) {
    // Create an instance of Random
    final random = Random();

    // Create a set to store unique random doubles
    Set<double> uniqueNumbers = Set<double>();

    // Generate a unique random double
    double randomDouble;
    do {
      randomDouble = min + random.nextDouble() * (max - min);
    } while (!uniqueNumbers.add(randomDouble));

    // Return the unique random double
    return randomDouble;
  }

  //--desire width and heigh of screen for export is : width : 1038.4000244140625 -- height : 715.2000122070312
  //--desire size --- width : 1038.4000244140625 , height : 711.2000122070312.


  static bool canNotExport(){
    final isWebMobile = kIsWeb && (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android);
    return isWebMobile;
    return ConstKeeper.isIos || ConstKeeper.isAndroid || ConstKeeper.isWindows || ConstKeeper.isMacOs || ConstKeeper.isLinux || ConstKeeper.isPhone || ConstKeeper.isTablet;
  }

}
