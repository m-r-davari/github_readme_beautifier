import 'dart:math';

class Utils {

  int generateRandomNumFromRange(int min, int max){
    return Random.secure().nextInt(max) + min ;
  }



}
