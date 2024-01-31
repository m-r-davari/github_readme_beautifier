import 'package:github_readme_beautifier/data/most_used_languages/datasource/i_most_used_languages_remote_datasource.dart';
import 'package:github_readme_beautifier/data/most_used_languages/repository/i_most_used_languages_repository.dart';
import 'package:github_readme_beautifier/data/repos_languages_overview/datasource/i_repos_languages_overview_remote_datasource.dart';
import 'package:github_readme_beautifier/data/repos_languages_overview/repository/i_repos_languages_overview_repository.dart';

class ReposLanguagesOverviewRepository extends IReposLanguagesOverviewRepository {
  final IReposLanguagesOverviewRemoteDatasource datasource;
  ReposLanguagesOverviewRepository({required this.datasource});

  @override
  Future<Map<String, int>> getReposLanguagesOverview({required String userName}) async {
    return await datasource.getReposLanguagesOverview(userName: userName);
  }

}