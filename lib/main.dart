import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:github_readme_beautifier/splash_page.dart';
import 'package:responsive_builder/responsive_builder.dart';

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
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveBuilder(
        builder: (context, sizingInformation) {
          if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: const SplashPage(),
            );
          }

          // if (sizingInformation.deviceScreenType == DeviceScreenType.tablet) {
          //   return Container(color:Colors.red);
          // }
          //
          // if (sizingInformation.deviceScreenType == DeviceScreenType.watch) {
          //   return Container(color:Colors.yellow);
          // }

          return Container(color:Colors.purple);
        },
      )
    );
  }
}
