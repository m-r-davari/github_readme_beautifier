import 'package:get/get.dart';
import 'package:github_readme_beautifier/core/exceptions/exceptions.dart';
import 'package:github_readme_beautifier/core/states/states.dart';
import 'package:github_readme_beautifier/data/github_friends/models/github_firend_model.dart';
import 'package:github_readme_beautifier/data/github_friends/repository/i_github_friends_repository.dart';

class GithubFriendsController extends GetxController {

  Rx<UIState> state = Rx<UIState>(LoadingState());
  IGithubFriendsRepository repository = Get.find();
  List<GithubFriendModel> selectedFriends = [];
  final maxFriendsNum = 5;
  Rx<bool> isLight = true.obs;

  Future<void> getGithubFriends({required String userName})async{
    try {
      final result = await repository.getGithubFriends(userName: userName);
      state.value = SuccessState<List<GithubFriendModel>>(result);
    }
    on NetworkException catch(e){
      state.value = FailureState(error: e.message);
    }
    catch (e) {
      state.value = FailureState(error: e.toString());
    }

  }

}