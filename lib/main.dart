import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:github_readme_beautifier/github_meme/github_meme_controller.dart';
import 'package:github_readme_beautifier/github_meme_page.dart';
import 'package:github_readme_beautifier/home_page.dart';
import 'package:github_readme_beautifier/splash_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Github Readme Beautifier',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      getPages: [
        GetPage(
            name: "/splash_page",
            page: () => const SplashPage(),
            transition: Transition.fade,
        ),
        GetPage(
          name: "/home_page",
          page: () => const HomePage(),
          transition: Transition.fade,
        )
        ,
        GetPage(
          name: "/meme_page",
          page: () => const GithubMemePage(),
          transition: Transition.fade,
          binding: BindingsBuilder(() {
            Get.put(GithubMemeController());
          }),
        )
      ],
      initialRoute: "/splash_page",
      home: const SplashPage(),

    );
  }

}