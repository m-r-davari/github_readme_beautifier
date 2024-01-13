import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:github_readme_beautifier/presentation/most_used_languages/controllers/most_used_languages_controller.dart';
import 'package:github_readme_beautifier/widgets/github_text.dart';

class MostUsedLanguagesPage extends StatefulWidget {
  const MostUsedLanguagesPage({Key? key}) : super(key: key);

  @override
  State<MostUsedLanguagesPage> createState() => _MostUsedLanguagesPageState();
}

class _MostUsedLanguagesPageState extends State<MostUsedLanguagesPage> {

  final controller = Get.find<MostUsedLanguagesController>();
  int touchedIndex = -1;
  bool isChartLoaded = false;

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
        title: const Text('Most Used Languages'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //langData = await controller.getMostLanguages();
          setState(() {});
        },
        child: const Text('get'),
      ),
      body: Container(
          margin: const EdgeInsets.all(40),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const GithubText(
                str: 'Most Used Languages',
                isLight: true,
                isBold: true,
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                color: Colors.transparent,
                //height: 100,
                child: AnimationLimiter(
                  child: Column(
                    children: AnimationConfiguration.toStaggeredList(
                        duration: const Duration(milliseconds: 575),
                        childAnimationBuilder: (widget) => SlideAnimation(
                          verticalOffset: 50,
                          child: FadeInAnimation(
                            child: widget,
                          ),
                        ),
                        children: generateSections(data: controller.langsData)
                    ),
                  ),
                ),
              )
            ],
          )
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
              GithubText(str: '${data.keys.toList()[i]}', isLight: true),
              const SizedBox(
                width: 6,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: SvgPicture.network(
                    width: 16,
                    height: 16,
                    'https://abrudz.github.io/logos/${data.keys.toList()[i]}.svg',
                    placeholderBuilder: (BuildContext context) =>
                        SizedBox(width: 16, height: 16, child: Container() //CircularProgressIndicator(strokeWidth: 2,),
                        )),
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
                        BarChartData(
                          gridData: const FlGridData(show: false),
                          titlesData:  const FlTitlesData(show: false,),
                          borderData: FlBorderData(show: false,),
                          barTouchData: BarTouchData(
                            enabled: false,
                            touchCallback: (FlTouchEvent event, barTouchResponse) {
                              setState(() {
                                if (!event.isInterestedForInteractions ||
                                    barTouchResponse == null ||
                                    barTouchResponse.spot == null) {
                                  touchedIndex = -1;
                                  return;
                                }
                                touchedIndex = i;
                                print('edcjnejnzzzz zzzzzzzz zzzzzzz $touchedIndex');
                              });
                            },
                          ),
                          barGroups: [
                            BarChartGroupData(
                              x: 0,
                              barRods: [
                                BarChartRodData(
                                  toY: i == touchedIndex ? data.values.toList()[i].toDouble()+1  : data.values.toList()[i].toDouble(),
                                  color: i == touchedIndex ? Colors.amber : Colors.blue,
                                  width: 22,
                                  borderSide: const BorderSide(color: Colors.orangeAccent),
                                  backDrawRodData: BackgroundBarChartRodData(
                                    show: true,
                                    toY: 100,
                                    color: Colors.grey,
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
                width: 16,
              ),
              GithubText(
                str: '${data.values.toList()[i]}%',
                isLight: true,
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
