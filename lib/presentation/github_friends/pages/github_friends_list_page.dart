import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:github_readme_beautifier/core/states/states.dart';
import 'package:github_readme_beautifier/data/github_friends/models/github_firend_model.dart';
import 'package:github_readme_beautifier/presentation/github_friends/controllers/github_friends_controller.dart';
import 'package:github_readme_beautifier/presentation/github_friends/widgets/friends_check_item.dart';
import 'package:github_readme_beautifier/presentation/user/user_controller.dart';
import 'package:github_readme_beautifier/widgets/github_loading.dart';

class GithubFriendsListPage extends StatefulWidget {
  const GithubFriendsListPage({Key? key}) : super(key: key);

  @override
  State<GithubFriendsListPage> createState() => _GithubFriendsListPageState();
}

class _GithubFriendsListPageState extends State<GithubFriendsListPage> {

  final githubFriendsController = Get.find<GithubFriendsController>();
  final userController = Get.find<UserController>();

  @override
  void initState() {
    githubFriendsController.getGithubFriends(userName: userController.userName.value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Github Friends List'),
      ),
      body: Obx(() {
        if(githubFriendsController.state.value is LoadingState){
          return const Center(
            child: GithubLoading(),
          );
        }
        else if(githubFriendsController.state.value is SuccessState){
          List<GithubFriendModel> data = (githubFriendsController.state.value as SuccessState).data;

          if(data.isEmpty){
            return const Center(child: Text('You have no Github followers'),);
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Choose 3 to ${githubFriendsController.maxFriendsNum} of your Github followers',style: const TextStyle(fontSize: 16,fontWeight: FontWeight.normal),),
                const SizedBox(
                  height: 16,
                ),
                Expanded(
                  child: ListView.separated(
                    itemCount: data.length,
                    physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (ctx, index) {
                      return FriendsCheckItem(
                        value: githubFriendsController.selectedFriends.contains(data[index]),
                        enabled: githubFriendsController.selectedFriends.length < githubFriendsController.maxFriendsNum || githubFriendsController.selectedFriends.contains(data[index]),
                        friendName: data[index].login ?? '---',
                        friendAvatar: data[index].avatarUrl ?? '',
                        onChange: (bool selected) {
                          if(selected){
                            if(index==2){
                              githubFriendsController.selectedFriends.add(data[index]..login = 'm-r-davari'..avatarUrl = 'https://avatars.githubusercontent.com/u/71879123?v=4');
                            }
                            else{
                              githubFriendsController.selectedFriends.add(data[index]);
                            }

                          }
                          else{
                            githubFriendsController.selectedFriends.remove(data[index]);
                          }
                          setState(() {});
                        },
                      );
                    },
                    separatorBuilder: (ctx, index) {
                      return const SizedBox(
                        height: 8,
                      );
                    },
                  ),
                ),
                ElevatedButton(
                    onPressed: (){
                      if(githubFriendsController.selectedFriends.length < 3){
                        Get.showSnackbar(const GetSnackBar(
                          title: 'Error',
                          message: 'Select At Least 3 Friend',
                          duration: Duration(seconds: 3),
                        ));
                        return;
                      }
                      Get.toNamed('/github_friends_page');
                    },
                    child: const Text('Continue')
                )
              ],
            ),
          );
        }
        else if (githubFriendsController.state is FailureState){
          return const Text("Failed To Load");
        }
        else{
          return Container();
        }
      }),
    );
  }
}
