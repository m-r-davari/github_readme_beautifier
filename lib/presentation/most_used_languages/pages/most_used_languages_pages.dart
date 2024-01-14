import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:github_readme_beautifier/presentation/exporter/exporter_view.dart';
import 'package:github_readme_beautifier/presentation/most_used_languages/controllers/most_used_languages_controller.dart';
import 'package:github_readme_beautifier/presentation/user/user_controller.dart';
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


  @override
  void initState() {
    controller.getMostLanguages(Get.find<UserController>().userName);
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //langData = await controller.getMostLanguages();
          //setState(() {});

          for(int i = 0; i < controller.langsData.length ; i++){

            controller.touchedIndex.value = i;
            // final frame = await screenShotMaker.captureScreen(key: mostLangsBoundryGlobalKey);
            // lightFrames.add(frame);
            await Future.delayed(const Duration(milliseconds: 1000));
          }
        },
        child: const Text('get'),
      ),
      body: Obx(
              (){
            if(controller.langsData.isEmpty){
              return const Center(child: GithubLoading());
            }
            else{
              final rec = controller.isRecording.value;
              print('-----rebuilding');
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: RepaintBoundary(
                      key: mostLangsBoundryGlobalKey,
                      child: Container(
                          margin: const EdgeInsets.all(2),
                          padding: const EdgeInsets.all(16),
                          width: 400,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                            borderRadius: BorderRadius.circular(16),
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
                                  key: controller.staggeredKey.value,
                                  children: AnimationConfiguration.toStaggeredList(
                                      duration: const Duration(milliseconds: 250),
                                      delay: const Duration(milliseconds: 250),
                                      childAnimationBuilder: (widget) => SlideAnimation(
                                        verticalOffset: 50,
                                        child: FadeInAnimation(
                                          child: widget,
                                        ),
                                      ),
                                      children: generateSections(data: controller.langsData)
                                  ),
                                ),
                              )
                            ],
                          )
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: ()async {
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
                        if(ConstKeeper.isFFmpegLoaded.value){
                          await controller.export();
                        }
                        else{
                          await ConstKeeper.isFFmpegLoaded.stream.firstWhere((loaded) => loaded == true);
                          await controller.export();
                        }
                      },
                      child: Text(rec ? 'Export' :'---')
                  ),
                ],
              );
            }
          }
      ),
    );
  }

  List<Widget> generateSections({required Map<String, int>? data}) {
    if (data == null) {
      return [];
    }
    return List.generate(data.length, (i) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GithubText(str: data.keys.toList()[i], isLight: controller.isLight.value, isBold: i == controller.touchedIndex.value,),
              const SizedBox(
                width: 6,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: SvgPicture.network(
                    width: 16,
                    height: 16,
                    'https://abrudz.github.io/logos/${data.keys.toList()[i]}.svg',
                    // placeholderBuilder: (BuildContext context) =>
                    //     SizedBox(width: 16, height: 16, child: Container() //CircularProgressIndicator(strokeWidth: 2,),
                    //     ),
                ),
              ),
            ],
          ),
          // SizedBox(height: 2,),
          Row(
            children: [
              Flexible(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    height: 12,
                    child: RotatedBox(
                      quarterTurns: 1,
                      child: BarChart(
                        swapAnimationDuration: const Duration(milliseconds: 250),
                        BarChartData(
                          gridData: const FlGridData(show: false),
                          titlesData:  const FlTitlesData(show: false,),
                          borderData: FlBorderData(show: false,),
                          barTouchData: BarTouchData(
                            enabled: false,
                            touchCallback: (FlTouchEvent event, barTouchResponse) {
                              print('---- ontouch----');
                              setState(() {
                                if (!event.isInterestedForInteractions ||
                                    barTouchResponse == null ||
                                    barTouchResponse.spot == null) {
                                  controller.touchedIndex.value = -1;
                                  return;
                                }
                                controller.touchedIndex.value = i;
                              });
                            },
                          ),
                          barGroups: [
                            BarChartGroupData(
                              x: 0,
                              barRods: [
                                BarChartRodData(
                                  toY: i == controller.touchedIndex.value ? data.values.toList()[i].toDouble()+1  : data.values.toList()[i].toDouble(),
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
        ]
      );
    });
  }
}
