import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:github_readme_beautifier/core/states/states.dart';
import 'package:github_readme_beautifier/presentation/exporter/exporter_view.dart';
import 'package:github_readme_beautifier/presentation/most_used_languages/controllers/most_used_languages_controller.dart';
import 'package:github_readme_beautifier/presentation/user/user_controller.dart';
import 'package:github_readme_beautifier/resources/github_themes.dart';
import 'package:github_readme_beautifier/utils/const_keeper.dart';
import 'package:github_readme_beautifier/widgets/github_loading.dart';
import 'package:github_readme_beautifier/widgets/github_text.dart';

class MostUsedLanguagesPage extends StatefulWidget {
  const MostUsedLanguagesPage({Key? key}) : super(key: key);

  @override
  State<MostUsedLanguagesPage> createState() => _MostUsedLanguagesPageState();
}

class _MostUsedLanguagesPageState extends State<MostUsedLanguagesPage> {
  final controller = Get.find<MostUsedLanguagesController>();
  final userController = Get.find<UserController>();
  final githubTheme = GithubThemes();

  @override
  void initState() {
    controller.getMostLanguages(Get.find<UserController>().userName.value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Most Used Languages'),
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
                padding: const EdgeInsets.all(40.0),
                child: RepaintBoundary(
                  key: mostLangsBoundryGlobalKey,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Container(
                          margin: const EdgeInsets.all(2),
                          padding: const EdgeInsets.all(16),
                          width: 400,
                          decoration: BoxDecoration(
                            border:
                                Border.all(width: 1, color: controller.isLight.value ? githubTheme.lightBgColor : githubTheme.darkBgColor),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      Container(
                          margin: const EdgeInsets.all(2),
                          padding: const EdgeInsets.all(16),
                          width: 400,
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
                              GithubText(
                                str: 'Most Used Languages',
                                isLight: controller.isLight.value,
                                isBold: true,
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Container(
                                color: Colors.transparent,
                                //height: 100,
                                child: Column(
                                  children: generateSections(data: data),
                                ),
                              )
                            ],
                          ))
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    if(!ConstKeeper.isWeb || !ConstKeeper.isDesktop){
                      Get.showSnackbar(const GetSnackBar(
                        title: 'Error',
                        message: 'Use desktop web browser to export files.',
                        duration: Duration(seconds: 3),
                      ));
                      return;
                    }
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

  List<Widget> generateSections({required Map<String, int>? data}) {
    if (data == null) {
      return [];
    }
    return List.generate(data.length, (i) {
      return Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GithubText(
              str: data.keys.toList()[i],
              isLight: controller.isLight.value,
              isBold: i == controller.touchedIndex.value,
            ),
            const SizedBox(
              width: 6,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Stack(
                children: [
                  Positioned.fill(child: Container(color: controller.isLight.value ? githubTheme.lightBgColor : githubTheme.darkBgColor)),
                  SvgPicture.network(
                    width: 16,
                    height: 16,
                    'https://abrudz.github.io/logos/${data.keys.toList()[i]}.svg',
                    // placeholderBuilder: (BuildContext context) =>
                    //     SizedBox(width: 16, height: 16, child: Container() //CircularProgressIndicator(strokeWidth: 2,),
                    //     ),
                  )
                ],
              ),
            ),
          ],
        ),
        // SizedBox(height: 2,),
        Row(
          children: [
            Flexible(
              child: Stack(
                children: [
                  Positioned.fill(child: Container(color: controller.isLight.value ? githubTheme.lightBgColor : githubTheme.darkBgColor)),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      height: 12,
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: BarChart(
                          swapAnimationDuration: const Duration(milliseconds: 150),
                          BarChartData(
                            gridData: const FlGridData(show: false),
                            titlesData: const FlTitlesData(
                              show: false,
                            ),
                            borderData: FlBorderData(
                              show: false,
                            ),
                            barTouchData: BarTouchData(
                              enabled: false,
                              touchCallback: (FlTouchEvent event, barTouchResponse) {
                                if (!event.isInterestedForInteractions || barTouchResponse == null || barTouchResponse.spot == null) {
                                  controller.touchedIndex.value = -1;
                                  return;
                                }
                                controller.touchedIndex.value = i;
                              },
                            ),
                            barGroups: [
                              BarChartGroupData(
                                x: 0,
                                barRods: [
                                  BarChartRodData(
                                    toY: i == controller.touchedIndex.value
                                        ? data.values.toList()[i].toDouble() + 1
                                        : data.values.toList()[i].toDouble(),
                                    color: i == controller.touchedIndex.value ? Colors.amber : Colors.blue,
                                    width: 22,
                                    borderSide: const BorderSide(color: Colors.orangeAccent),
                                    backDrawRodData: BackgroundBarChartRodData(
                                      show: true,
                                      toY: 100,
                                      color: const Color(0xffcecece),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            GithubText(
              str: '${data.values.toList()[i].toString().length == 1 ? '  ' : ''}${data.values.toList()[i]}%',
              isLight: controller.isLight.value,
              isBold: i == controller.touchedIndex.value,
            )
          ],
        ),
        const SizedBox(
          height: 8,
        )
      ]);
    });
  }
}
