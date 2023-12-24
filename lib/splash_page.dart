import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:github_readme_beautifier/home_page.dart';


class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LauncherPage();
  }
}

class _LauncherPage extends State<SplashPage> with TickerProviderStateMixin {

  //flip
  late AnimationController flipController;
  late Animation flipAnim;

  //move up
  late AnimationController transUpController;
  late Animation<Offset> transUpOffset;

  //fade in
  late AnimationController fadeInController;
  late Animation<double> fadeIn;

  int count = 0;


  @override
  void initState() {
    super.initState();


    flipController = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);
    flipAnim = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: flipController, curve: const Interval(0.0, 1.0, curve: Curves.linear)));

    flipAnim.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (count < 1) {
          count++;
          //print("count ${count}");
          flipController.reset();
          flipController.forward();
        }
        else {
          flipController.stop();
          count = 0;
          //print("count ${count}");


          Future.delayed(const Duration(milliseconds: 300), () {
            //Get.to(const HomePage(),transition: Transition.fadeIn);
            Get.offNamed('/home_page');
          });
        }
      }


    });

    transUpController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
    transUpOffset = Tween<Offset>(begin: const Offset(0.0, 6.0), end: Offset.zero).animate(transUpController);


    fadeInController = AnimationController(vsync: this, duration: const Duration(seconds: 3));
    fadeIn = Tween(begin: -1.0, end: 1.0).animate(fadeInController);
  }

  bool isPlay = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          child: AnimatedBuilder(
              animation: flipController,
              builder: (BuildContext context, Widget? child) {
                transUpController.forward();
                flipController.forward();
                fadeInController.forward();
                return Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                          width: 190, height: 190,
                          alignment: Alignment.center,
                          child: SlideTransition(
                            position: transUpOffset,
                            child: Transform(
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.001)
                                ..rotateY(2 * pi * flipAnim.value),
                              alignment: Alignment.center,
                              child: Image.asset('assets/logo_github_1.png', fit: BoxFit.fill,width: 150,height: 150,),
                            ),
                          )
                      ),
                    )
                    ,
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: FadeTransition(
                        opacity: fadeIn,
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text("Github Readme Beautifier", style: TextStyle(fontSize: 20.0),),
                        ),
                      ),
                    )
                  ],

                );
              }
          ),
        )
    );
  }


  @override
  void dispose() {
    super.dispose();
    flipController.dispose();
    transUpController.dispose();
  }

}




