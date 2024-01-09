import 'package:github_readme_beautifier/core/network_manager/i_nework_manager.dart';
import 'package:github_readme_beautifier/features/common/git_repos/datasources/i_git_repos.dart';
import 'package:github_readme_beautifier/features/common/git_repos/models/git_repo_model.dart';
import 'i_language_statistics_remote_datasource.dart';

class LanguageStatisticsRemoteDatasource extends ILanguageStatisticsRemoteDatasource{

  final INetworkManager networkManager;
  final IGitReposRemoteDataSource reposDataSource;
  LanguageStatisticsRemoteDatasource({required this.networkManager,required this.reposDataSource});

  @override
  Future<dynamic> getLanguageStatistics({required String userName})async{
    final repos = await reposDataSource.getUserGitRepos(userName: userName);
    List<dynamic> langs = [];
    for(final repo in repos){
      final lang = await networkManager.getRequest(path: repo.languagesUrl);
      langs.add(lang);
    }
  }

}