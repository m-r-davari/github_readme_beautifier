import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:github_readme_beautifier/features/language_statistics%20/presentation/controllers/language_statistics_controller.dart';

class LanguageStatisticsPage extends StatefulWidget {
  const LanguageStatisticsPage({Key? key}) : super(key: key);

  @override
  State<LanguageStatisticsPage> createState() => _LanguageStatisticsPageState();
}

class _LanguageStatisticsPageState extends State<LanguageStatisticsPage> {

  final controller = Get.find<LanguageStatisticsController>();

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
          // controller.
        },
        child: Text('get'),
      ),
      body: Container(
        child: Center(child: Text('langiages'),),
      ),
    );
  }

}
