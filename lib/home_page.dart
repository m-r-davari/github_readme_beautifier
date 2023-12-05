import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:github_readme_beautifier/github_grid_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        title: const Text('Github Readme Beautifier'),
      ),
      body:  Container(
        padding: const EdgeInsets.all(30),
        child: ElevatedButton(
          onPressed: (){
            Get.toNamed('/meme_page');
          },
          child: const Text('Github Meme'),
        ),
      ),
    );
  }




}
