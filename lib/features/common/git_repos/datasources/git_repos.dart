import 'dart:convert';
import 'package:github_readme_beautifier/core/network_manager/i_nework_manager.dart';
import 'package:github_readme_beautifier/features/common/git_repos/models/git_repo_model.dart';
import 'i_git_repos.dart';

class GitReposRemoteDataSource extends IGitReposRemoteDataSource {
  
  final INetworkManager networkManager;
  GitReposRemoteDataSource({required this.networkManager});
  
  @override
  Future<List<GitRepoModel>> getUserGitRepos({required String userName}) async {
    final result =  await networkManager.getRequest(path: 'users/$userName/repos');
    final List<dynamic> jsonList = json.decode(result);
    return jsonList.map((json) => GitRepoModel.fromJson(json)).toList();
  }
  
}