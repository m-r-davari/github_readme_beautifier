
import 'package:github_readme_beautifier/data/github_friends/models/github_firend_model.dart';

abstract class IGithubFriendsRepository{

  Future<List<GithubFriendModel>> getGithubFriends({required String userName});

}