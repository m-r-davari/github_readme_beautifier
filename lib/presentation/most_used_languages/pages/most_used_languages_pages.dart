import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:github_readme_beautifier/presentation/most_used_languages/controllers/most_used_languages_controller.dart';

class MostUsedLanguagesPage extends StatefulWidget {
  const MostUsedLanguagesPage({Key? key}) : super(key: key);

  @override
  State<MostUsedLanguagesPage> createState() => _MostUsedLanguagesPageState();
}

class _MostUsedLanguagesPageState extends State<MostUsedLanguagesPage> {

  final controller = Get.find<MostUsedLanguagesController>();

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
          controller.getMostLanguages();
        },
        child: const Text('get'),
      ),
      body: Container(
        child: const Center(child: Text('languages'),),
      ),
    );
  }

}
