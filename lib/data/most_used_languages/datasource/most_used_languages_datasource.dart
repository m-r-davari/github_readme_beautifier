import 'package:github_readme_beautifier/core/network_manager/i_nework_manager.dart';
import 'package:github_readme_beautifier/data/git_repos/datasource/i_git_repos.dart';
import 'package:github_readme_beautifier/data/most_used_languages/datasource/i_most_used_languages_datasource.dart';

class MostUsedLanguagesDatasource extends IMostUsedLanguagesDatasource{

  final INetworkManager networkManager;
  final IGitReposRemoteDataSource reposDataSource;
  MostUsedLanguagesDatasource({required this.networkManager,required this.reposDataSource});

  @override
  Future<dynamic> getMostUsedLanguages({required String userName})async{
    final repos = await reposDataSource.getUserGitRepos(userName: userName);
    List<dynamic> langs = [];
    for(final repo in repos){
      final lang = await networkManager.getRequest(path: '');
      langs.add(lang);
    }
  }

}