import 'package:github_readme_beautifier/core/network_manager/i_nework_manager.dart';
import 'package:github_readme_beautifier/data/github_friends/datasource/i_github_friends_remoted_datasource.dart';
import 'package:github_readme_beautifier/data/github_friends/models/github_firend_model.dart';

class GithubFriendsRemoteDatasource extends IGithubFriendsRemoteDatasource {

  final INetworkManager networkManager;
  GithubFriendsRemoteDatasource({required this.networkManager});

  @override
  Future<List<GithubFriendModel>> getGithubFriends({required String userName})async{
    final result = await networkManager.getRequest(path: 'users/$userName/followers');
    List<GithubFriendModel> friends = <GithubFriendModel>[];
    result.forEach((v) {
      friends.add(GithubFriendModel.fromJson(v));
    });
    return friends;
  }

}