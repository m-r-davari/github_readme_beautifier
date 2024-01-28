import 'package:github_readme_beautifier/data/most_used_languages/datasource/i_most_used_languages_remote_datasource.dart';
import 'package:github_readme_beautifier/data/most_used_languages/repository/i_most_used_languages_repository.dart';

class MostLanguagesRepository extends IMostLanguagesRepository {
  final IMostUsedLanguagesRemoteDatasource datasource;
  MostLanguagesRepository({required this.datasource});

  @override
  Future<Map<String, int>> getMostLanguages({required String userName}) async {
    return await datasource.getMostUsedLanguages(userName: userName);
  }

}