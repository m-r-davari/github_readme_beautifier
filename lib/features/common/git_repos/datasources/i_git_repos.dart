import 'package:github_readme_beautifier/features/common/git_repos/models/git_repo_model.dart';

abstract class IGitReposRemoteDataSource {
  Future<List<GitRepoModel>> getUserGitRepos({required String userName});
}