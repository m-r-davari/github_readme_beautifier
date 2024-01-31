import 'dart:convert';
import 'package:github_readme_beautifier/core/network_manager/i_nework_manager.dart';
import 'package:github_readme_beautifier/data/git_repos/models/git_repo_model.dart';
import 'i_git_repos_remote_datasource.dart';

class GitReposRemoteDataSource extends IGitReposRemoteDataSource {
  
  final INetworkManager networkManager;
  GitReposRemoteDataSource({required this.networkManager});

  @override
  Future<List<GitRepoModel>> getUserGitRepos({required String userName}) async {
    final result =  await networkManager.getRequest(path: 'users/$userName/repos');
    List<GitRepoModel> repos = <GitRepoModel>[];
    result.forEach((v) {
      repos.add(GitRepoModel.fromJson(v));
    });
    return repos;
  }
  
}