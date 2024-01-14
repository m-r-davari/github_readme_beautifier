import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:github_readme_beautifier/presentation/most_used_languages/controllers/most_used_languages_controller.dart';

class UsedLanguagesOverviewPage extends StatefulWidget {
  const UsedLanguagesOverviewPage({Key? key}) : super(key: key);

  @override
  State<UsedLanguagesOverviewPage> createState() => _UsedLanguagesOverviewPageState();
}

class _UsedLanguagesOverviewPageState extends State<UsedLanguagesOverviewPage> {

  final controller = Get.find<MostUsedLanguagesController>();

  double ipc = 1.0;
  double ipc2 = 1.0;
  double ipc3 = 1.0;
  double ipc4 = 1.0;

  int touchedIndex = -1;
  bool isPieLoaded = false;

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
        title: const Text('Typewriter Text'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          //controller.getMostLanguages();
          setState(() {
            isPieLoaded = true;
            ipc = 30.0;
            ipc2 = 40.0;
            ipc3 = 20.0;
            ipc4 = 10.0;
          });
        },
        child: const Text('get'),
      ),
      body: Container(
       // width: 300,height: 300,
        margin: EdgeInsets.all(40),
        child: PieChart(
          PieChartData(
            sections: showingSections(),
            sectionsSpace: isPieLoaded ? 2 : 0,
            pieTouchData: PieTouchData(
                touchCallback: (flTouchEvent, pieTouchResponse) {
                setState(() {
                  final desiredTouch = flTouchEvent
                  is! FlPointerExitEvent && flTouchEvent is! FlTapUpEvent;
                  if (desiredTouch && pieTouchResponse!.touchedSection != null) {
                    touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                  } else {
                    touchedIndex = -1;
                  }
                });
            })
          ),
          swapAnimationDuration: const Duration(milliseconds: 1375), // Optional
          swapAnimationCurve: Curves.linear,
        )
      ),
    );
  }



  List<PieChartSectionData> showingSections() {
    return List.generate(1, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      return PieChartSectionData(
        color: isPieLoaded
            ? Colors.blueAccent
            : Colors.grey,
        value: isPieLoaded
            ? i == 0 ? ipc : i==1 ? ipc2 : i==2? ipc3 : ipc4
            : 100,
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