
import 'package:get/get.dart';
import 'package:github_readme_beautifier/core/exceptions/exceptions.dart';
import 'package:github_readme_beautifier/core/states/states.dart';
import 'package:github_readme_beautifier/data/user/model/user_info_model.dart';
import 'package:github_readme_beautifier/data/user/repository/i_user_info_repository.dart';

class UserController extends GetxController {

  RxString userName = ''.obs;// m-r-davari //0x48415a484952 //parisa3084
  UserInfoModel? userInfo;
  Rx<UIState> state = Rx<UIState>(InitialState());
  final IUserInfoRepository repository = Get.find();

  Future<void> getUserInfo({required String userName})async{
    state.value = LoadingState();
    try {
      final result = await repository.getUserInfo(userName: userName);
      userInfo = result;
      state.value = SuccessState<UserInfoModel>(result);
    }
    on NetworkException catch(e){
      state.value = FailureState(error: e.message);
    }
    catch (e) {
      state.value = FailureState(error: e.toString());
    }

  }


}