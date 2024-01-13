import 'package:get/get.dart';
import 'package:github_readme_beautifier/data/most_used_languages/repository/i_most_used_languages_repository.dart';

class MostUsedLanguagesController extends GetxController {


  Map<String,int>? langsData;
  final repository = Get.find<IMostLanguagesRepository>();

  Future<void> getMostLanguages(String userName)async{
    langsData = await repository.getMostLanguages(userName: userName);
  }

}