import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:github_readme_beautifier/core/states/states.dart';
import 'package:github_readme_beautifier/presentation/exporter/exporter_view.dart';
import 'package:github_readme_beautifier/presentation/repos_languages_overview/controllers/repos_languages_overview_controller.dart';
import 'package:github_readme_beautifier/presentation/user/user_controller.dart';
import 'package:github_readme_beautifier/resources/github_themes.dart';
import 'package:github_readme_beautifier/resources/languages_themes.dart';
import 'package:github_readme_beautifier/utils/const_keeper.dart';
import 'package:github_readme_beautifier/widgets/github_loading.dart';
import 'package:github_readme_beautifier/widgets/github_text.dart';

class ReposLanguagesOverviewPage extends StatefulWidget {
  const ReposLanguagesOverviewPage({Key? key}) : super(key: key);

  @override
  State<ReposLanguagesOverviewPage> createState() => _ReposLanguagesOverviewPageState();
}

class _ReposLanguagesOverviewPageState extends State<ReposLanguagesOverviewPage> {
  final controller = Get.find<ReposLanguagesOverviewController>();
  final userController = Get.find<UserController>();
  final githubTheme = GithubThemes();
  final LanguagesThemes langThemes = LanguagesThemes();

  @override
  void initState() {
    controller.getReposLanguagesOverview(userName: userController.userName.value);
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
      body: Obx(() {
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
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(40),
                child: RepaintBoundary(
                  key: reposLangOverviewBoundryGlobalKey,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          width: 400,
                          height: 400,
                          decoration: BoxDecoration(
                            border:
                            Border.all(width: 1, color: controller.isLight.value ? githubTheme.lightBgColor : githubTheme.darkBgColor),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      Container(
                          width: 400,
                          height: 400,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 1, color: controller.isLight.value ? githubTheme.lightBorderColor : githubTheme.darkBorderColor),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GithubText(str: 'Repos Languages Overview',isBold: true, isLight: controller.isLight.value),
                              const SizedBox(
                                height: 16,
                              ),
                              Expanded(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        GithubText(fontSize: 24,isBold: true,str: controller.touchedIndex.value == -1 ? '' : data.keys.toList()[controller.touchedIndex.value], isLight: controller.isLight.value,),
                                        GithubText(fontSize: 22,isBold: false,str: controller.touchedIndex.value == -1 ? '' : '${data.values.toList()[controller.touchedIndex.value]}%', isLight: controller.isLight.value,),
                                      ],
                                    ),
                                    PieChart(
                                      PieChartData(
                                          sections: showingSections(data: data,isBg : true),
                                          sectionsSpace: 0,
                                      ),
                                      swapAnimationDuration: const Duration(milliseconds: 150), // Optional
                                      swapAnimationCurve: Curves.linear,
                                    ),
                                    Positioned(
                                      top: 2.5,right: 2.5,bottom: 2.5,left: 2.5,
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
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 15,
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
                      await controller.export(userName: userController.userName.value);
                    } else {
                      await ConstKeeper.isFFmpegLoaded.stream.firstWhere((loaded) => loaded == true);
                      await controller.export(userName: userController.userName.value);
                    }
                  },
                  child: const Text('Export'))
            ],
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

  List<PieChartSectionData> showingSections({required Map<String, int>? data,bool isBg = false}) {
    if (data == null) {
      return [];
    }
    return List.generate(isBg ? 1 : data.length, (i) {
      final isTouched = isBg ? true : i == controller.touchedIndex.value;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isBg ? 65.0 :  isTouched ? 60.0 : 50.0;
      return PieChartSectionData(
        color: isBg ? (controller.isLight.value ? githubTheme.lightBgColor : githubTheme.darkBgColor) : langThemes.languagesColors[data.keys.toList()[i]] ?? Colors.cyan,
        value: data.values.toList()[i].toDouble(),
        title: '',
        radius: radius,
        titleStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
      );
    });
  }

}
