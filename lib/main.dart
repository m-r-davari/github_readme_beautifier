import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:github_readme_beautifier/app_bindings.dart';
import 'package:github_readme_beautifier/features/github_meme/github_meme_controller.dart';
import 'package:github_readme_beautifier/features/github_meme/github_meme_page.dart';
import 'package:github_readme_beautifier/home_page.dart';
import 'package:github_readme_beautifier/splash_page.dart';
import 'package:github_readme_beautifier/features/typewriter_text/views/controllers/typewriter_controller.dart';
import 'package:github_readme_beautifier/features/typewriter_text/views/pages/typewriter_export_page.dart';
import 'package:github_readme_beautifier/features/typewriter_text/views/pages/typewriter_text_page.dart';

void main()async{
  AppBindings appBindings = AppBindings();
  runApp(MyApp(appBindings: appBindings,));
}

class MyApp extends StatelessWidget {
  MyApp({super.key,required this.appBindings});
  final AppBindings appBindings;

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
        ,
        GetPage(
          name: "/typewriter_page",
          page: () => const TypewriterTextPage(),
          transition: Transition.fade,
          binding: BindingsBuilder(() {
            Get.put(TypeWriterController());
          }),
        )
        ,
        GetPage(
          name: "/typewriter_export_page",
          page: () => const TypewriterExportPage(),
          transition: Transition.fade,
          binding: BindingsBuilder(() {
            Get.put(TypeWriterController());
          }),
        )
      ],
      initialRoute: "/splash_page",
      initialBinding: appBindings,
      //home: const SplashPage(),

    );
  }

}