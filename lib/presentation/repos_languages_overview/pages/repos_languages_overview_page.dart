import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:github_readme_beautifier/core/states/states.dart';
import 'package:github_readme_beautifier/presentation/repos_languages_overview/controllers/repos_languages_overview_controller.dart';
import 'package:github_readme_beautifier/presentation/user/user_controller.dart';
import 'package:github_readme_beautifier/resources/github_themes.dart';
import 'package:github_readme_beautifier/resources/languages_themes.dart';
import 'package:github_readme_beautifier/widgets/github_loading.dart';

class ReposLanguagesOverviewPage extends StatefulWidget {
  const ReposLanguagesOverviewPage({Key? key}) : super(key: key);

  @override
  State<ReposLanguagesOverviewPage> createState() => _ReposLanguagesOverviewPageState();
}

class _ReposLanguagesOverviewPageState extends State<ReposLanguagesOverviewPage> {

  final controller = Get.find<ReposLanguagesOverviewController>();
  final userController = Get.find<UserController>();
  final githubTheme = GithubThemes();
  final LanguagesThemes langThemes = LanguagesThemes.instance;

  @override
  void initState() {
    controller.getReposLanguagesOverview(userController.userName.value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Repos Language Overview'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          //controller.getReposLanguagesOverview(userController.userName.value);
        },
        child: const Text('get'),
      ),
      body: Obx((){

        if (controller.state.value is LoadingState) {
          return const Center(child: GithubLoading());
        } else if (controller.state.value is SuccessState) {
          Map<String, int> data = (controller.state.value as SuccessState).data;
          if (data.isEmpty) {
            return const Center(
              child: Text(
                textAlign: TextAlign.center,
                'You don\'t have any individual Repo, or all of them are Forked repos.\n Must have at least 1 individual repo.',
                style: TextStyle(color: Colors.red),
              ),
            );
          }
          return Container(
            // width: 300,height: 300,
              margin: const EdgeInsets.all(40),
              child: PieChart(
                PieChartData(
                    sections: showingSections(data: data),
                    sectionsSpace: 2,
                    pieTouchData: PieTouchData(
                        touchCallback: (flTouchEvent, pieTouchResponse) {
                          final desiredTouch = flTouchEvent is! FlPointerExitEvent && flTouchEvent is! FlTapUpEvent;
                          if (desiredTouch && pieTouchResponse!.touchedSection != null) {
                            controller.touchedIndex.value = pieTouchResponse.touchedSection!.touchedSectionIndex;
                          } else {
                            controller.touchedIndex.value = -1;
                          }
                        })
                ),
                swapAnimationDuration: const Duration(milliseconds: 150), // Optional
                swapAnimationCurve: Curves.linear,
              )
          );
        } else {
          String error = (controller.state.value as FailureState).error;
          return Center(
            child: Text(error),
          );
        }
      }),
    );
  }



  List<PieChartSectionData> showingSections({required Map<String, int>? data}) {
    if (data == null) {
      return [];
    }
    return List.generate(data.length, (i) {
      final isTouched = i == controller.touchedIndex.value;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      return PieChartSectionData(
        color: langThemes.languagesColors[data.keys.toList()[i]] ?? Colors.cyan,
        value: data.values.toList()[i].toDouble(),
        title: '',
        radius: radius,
        titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xffffffff)),
      );
    });
  }




}
