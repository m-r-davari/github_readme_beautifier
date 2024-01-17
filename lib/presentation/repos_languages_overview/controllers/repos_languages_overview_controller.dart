
import 'package:get/get.dart';
import 'package:github_readme_beautifier/data/repos_languages_overview/repository/i_repos_languages_overview_repository.dart';

class ReposLanguagesOverviewController extends GetxController {

  final repository = Get.find<IReposLanguagesOverviewRepository>();

  Future<void> getReposLanguagesOverview(String userName)async{

    final result = await repository.getReposLanguagesOverview(userName: userName);

  }


}