import 'package:github_readme_beautifier/core/network_manager/i_nework_manager.dart';
import 'package:github_readme_beautifier/data/user/model/user_info_model.dart';
import 'i_user_info_remote_datasource.dart';

class UserInfoRemoteDatasource extends IUserInfoRemoteDatasource {

  final INetworkManager networkManager;
  UserInfoRemoteDatasource({required this.networkManager});

  @override
  Future<UserInfoModel> getUserInfo({required String userName})async{
    final result = await networkManager.getRequest(path: '/users/$userName');
    return UserInfoModel.fromJson(result);
  }

}