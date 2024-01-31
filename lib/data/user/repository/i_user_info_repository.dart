
import 'package:github_readme_beautifier/data/user/model/user_info_model.dart';

abstract class IUserInfoRepository {

  Future<UserInfoModel> getUserInfo({required String userName});

}