import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:github_readme_beautifier/data/github_friends/models/github_firend_model.dart';
import 'package:github_readme_beautifier/presentation/exporter/exporter_view.dart';
import 'package:github_readme_beautifier/presentation/github_friends/controllers/github_friends_controller.dart';
import 'package:github_readme_beautifier/presentation/user/user_controller.dart';
import 'package:github_readme_beautifier/resources/github_themes.dart';
import 'package:github_readme_beautifier/utils/const_keeper.dart';
import 'package:github_readme_beautifier/widgets/github_text.dart';

class GithubFriendsPage extends StatefulWidget {
  const GithubFriendsPage({Key? key}) : super(key: key);

  @override
  State<GithubFriendsPage> createState() => _GithubFriendsPageState();
}

class _GithubFriendsPageState extends State<GithubFriendsPage> {
  final userController = Get.find<UserController>();
  final controller = Get.find<GithubFriendsController>();
  final githubTheme = GithubThemes();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Github Friends'),
      ),
      body: Obx(()=>Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(40),
            child: RepaintBoundary(
              key: githubFriendsGlobalKey,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      width: 400,
                      height: 400,
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 1, color: controller.isLight.value ? githubTheme.lightBgColor : githubTheme.darkBgColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  Container(
                      width: 400,
                      padding: const EdgeInsets.only(top: 8, bottom: 8, left: 0.2, right: 0.2),
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 1,
                            color: controller.isLight.value ? githubTheme.lightBorderColor : githubTheme.darkBorderColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: GithubText(str: 'Github Friends', isBold: true, isLight: controller.isLight.value),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          CarouselSlider(
                            items: generateSections(controller.selectedFriends),
                            options: CarouselOptions(
                              enlargeCenterPage: true,
                              height: 200,
                              viewportFraction: 0.5,
                            ),
                            carouselController: controller.carouselController,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ))
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () async {
                    showDialog(
                      context: Get.context!,
                      barrierDismissible: false,
                      builder: (context) {
                        return const AlertDialog(
                          backgroundColor: Colors.white,
                          surfaceTintColor: Colors.white,
                          content: ExporterDialog(),
                        );
                      },
                    );
                    if (ConstKeeper.isFFmpegLoaded.value) {
                      await controller.export(userName: userController.userName.value);
                    } else {
                      await ConstKeeper.isFFmpegLoaded.stream.firstWhere((loaded) => loaded == true);
                      await controller.export(userName: userController.userName.value);
                    }
                  },
                  child: const Text('Export')),
              const SizedBox(width: 16,),
              Container(
                height: 35,
                padding: const EdgeInsets.only(left: 8,),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(16),border: Border.all(color: Colors.deepPurpleAccent,width: 1)),
                child: Row(
                  children: [
                    const Text('Circle : : ',style: TextStyle(color: Colors.deepPurple),),
                    const SizedBox(width: 8,),
                    Switch(
                        value: controller.isCircle.value,
                        onChanged: (value){
                          controller.isCircle.value = value;
                        }
                    )
                  ],
                ),
              )
            ],
          )
        ],
      )),
    );
  }

  List<Widget> generateSections(List<GithubFriendModel> friends) {
    return friends
        .map((item) => Container(
              margin: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                borderRadius: controller.isCircle.value ? BorderRadius.circular(100) : BorderRadius.circular(5),
                border: Border.all(width: 1, color: controller.isLight.value ? githubTheme.lightBgColor : githubTheme.darkBgColor),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.all(controller.isCircle.value ? const Radius.circular(100.0) : const Radius.circular(5.0)),
                child: Stack(
                  children: <Widget>[
                    Image.network(
                      item.avatarUrl ?? '',
                      fit: BoxFit.cover,
                      width: 200.0,
                      height: 200,
                    ),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color.fromARGB(200, 0, 0, 0), Color.fromARGB(0, 0, 0, 0)],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                        child: Text(
                          item.login ?? '---',
                          textAlign: controller.isCircle.value ? TextAlign.center : TextAlign.start,
                          maxLines: 1,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize : controller.isCircle.value ? 14 : 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ))
        .toList();
  }
}
