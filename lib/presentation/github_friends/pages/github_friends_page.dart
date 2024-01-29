import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:github_readme_beautifier/data/github_friends/models/github_firend_model.dart';
import 'package:github_readme_beautifier/presentation/exporter/exporter_view.dart';
import 'package:github_readme_beautifier/presentation/github_friends/controllers/github_friends_controller.dart';
import 'package:github_readme_beautifier/resources/github_themes.dart';
import 'package:github_readme_beautifier/utils/const_keeper.dart';
import 'package:github_readme_beautifier/widgets/github_text.dart';

class GithubFriendsPage extends StatefulWidget {
  const GithubFriendsPage({Key? key}) : super(key: key);

  @override
  State<GithubFriendsPage> createState() => _GithubFriendsPageState();
}

class _GithubFriendsPageState extends State<GithubFriendsPage> {
  late List<Widget> imageSliders;
  final CarouselController _carouselController = CarouselController();
  final controller = Get.find<GithubFriendsController>();
  final githubTheme = GithubThemes();

  @override
  void initState() {
    imageSliders = generateSections(controller.selectedFriends);
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(40),
            child: RepaintBoundary(
              //key: reposLangOverviewBoundryGlobalKey,
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
                            items: imageSliders,
                            options: CarouselOptions(enlargeCenterPage: true, height: 200, viewportFraction: 0.5),
                            carouselController: _carouselController,
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
                  //await controller.export(userName: userController.userName.value);
                } else {
                  await ConstKeeper.isFFmpegLoaded.stream.firstWhere((loaded) => loaded == true);
                  //await controller.export(userName: userController.userName.value);
                }
              },
              child: const Text('Export'))
        ],
      ),
    );
  }

  List<Widget> generateSections(List<GithubFriendModel> friends) {
    return friends
        .map((item) => Container(
              margin: const EdgeInsets.all(5.0),
              child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
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
                            maxLines: 1,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ))
        .toList();
  }
  
  
}
