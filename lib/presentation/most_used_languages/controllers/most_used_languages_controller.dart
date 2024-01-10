import 'package:get/get.dart';
import 'package:github_readme_beautifier/data/most_used_languages/repository/i_most_used_languages_repository.dart';

class MostUsedLanguagesController extends GetxController {

  String userName = 'm-r-davari';//0x48415a484952 //parisa3084
  final repository = Get.find<IMostLanguagesRepository>();

  Future<void> getMostLanguages()async{
    final result = await repository.getMostLanguages(userName: userName);
    print('----most used languages is : $result');
  }

}