import 'package:github_readme_beautifier/data/github_friends/datasource/i_github_friends_remoted_datasource.dart';
import 'package:github_readme_beautifier/data/github_friends/models/github_firend_model.dart';
import 'package:github_readme_beautifier/data/github_friends/repository/i_github_friends_repository.dart';

class GithubFriendsRepository extends IGithubFriendsRepository {

  final IGithubFriendsRemoteDatasource datasource;
  GithubFriendsRepository({required this.datasource});

  @override
  Future<List<GithubFriendModel>> getGithubFriends({required String userName})async{
    final result = await datasource.getGithubFriends(userName: userName);
    return result;
  }



}