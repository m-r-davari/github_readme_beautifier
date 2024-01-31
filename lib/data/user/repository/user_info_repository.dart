import 'package:github_readme_beautifier/data/user/datasource/i_user_info_remote_datasource.dart';
import 'package:github_readme_beautifier/data/user/model/user_info_model.dart';
import 'i_user_info_repository.dart';

class UserInfoRepository extends IUserInfoRepository {

  final IUserInfoRemoteDatasource remoteDatasource;
  UserInfoRepository({required this.remoteDatasource});

  @override
  Future<UserInfoModel> getUserInfo({required String userName})async{
    final result = await remoteDatasource.getUserInfo(userName: userName);
    return result;
  }

}