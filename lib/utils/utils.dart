import 'dart:math';

class Utils {

  int generateRandomNumFromRange(int min, int max){
    return Random.secure().nextInt(max) + min ;
  }


  // desire width and heigh of screen for export is : width : 1038.4000244140625 -- height : 715.2000122070312 .

}
