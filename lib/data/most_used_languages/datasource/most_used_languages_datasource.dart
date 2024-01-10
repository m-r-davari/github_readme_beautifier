import 'package:github_readme_beautifier/core/network_manager/i_nework_manager.dart';
import 'package:github_readme_beautifier/data/git_repos/datasource/i_git_repos.dart';
import 'package:github_readme_beautifier/data/most_used_languages/datasource/i_most_used_languages_datasource.dart';

class MostUsedLanguagesDatasource extends IMostUsedLanguagesDatasource{

  final INetworkManager networkManager;
  final IGitReposRemoteDataSource reposDataSource;
  MostUsedLanguagesDatasource({required this.networkManager,required this.reposDataSource});

  @override
  Future<Map<String,int>> getMostUsedLanguages({required String userName})async{
    final repos = await reposDataSource.getUserGitRepos(userName: userName);
    List<String> reposLangs = repos.where((element) => element.language != null).map<String>((e) => e.language!).toList();
    print('--------> langslst : ${reposLangs}');
    final everyPartSize = 100 /reposLangs.length;
    final langsSets = reposLangs.toSet();
    Map<String,int> langsData = {};
    for(var langSet in langsSets){
      langsData[langSet] = (everyPartSize * reposLangs.where((element) => element == langSet).length).round();
    }
    print('----langs map data ----- $langsData -');
    return langsData;
  }

}