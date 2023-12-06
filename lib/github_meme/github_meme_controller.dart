import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:github_readme_beautifier/utils/pausable_timer.dart';

GlobalKey githubMemeBoundryGlobalKey = GlobalKey();

class GithubMemeController extends GetxController{

  List<AnimationController?> gridsAnimControllers = [];

  bool hasAnimListener = true;

  var animVal = 0.0;

  void generateFrames()async{
    hasAnimListener = false ;
    List<Uint8List> frames = [];//frames list
    const int exportDuration = 1000; //milSec
    //exportDuration / 41 = 24 fps
    for(var controller in gridsAnimControllers){
      controller?.stop();
    }
    await Future.delayed(Duration.zero);
    for(int i = 0 ; i<= exportDuration/41 ; i++){
      print('---- frame : $i -----');
      for(var controller in gridsAnimControllers){
        //increase anim value manually for next frame
        print('---- controller : $controller -----');
        if (controller!.status == AnimationStatus.forward){
          print('---- to increase : ${controller.value} ---${controller.status}---');
          controller.value += 0.1;
          print('---- increasing : ${controller.value} -----');
        }
        else if (controller.status == AnimationStatus.completed){
          print('---- complete : ${controller.value} ---${controller.status}---');
          controller.reverse();
          print('---- complete : ${controller.value} -----');
        }
        else if (controller.status == AnimationStatus.reverse){
          print('---- to decrease ---- ${controller.status} -- ${controller.value} --');
          controller.value -= 0.1;
          print('---- decreasing ---- ${controller.status} -- ${controller.value} --');
        }
        else if (controller.status == AnimationStatus.dismissed){
          print('---- to dismissed ---- ${controller.status} -- ${controller.value} --');
          controller.forward() ;
          print('---- dismissed ---- ${controller.status} -- ${controller.value} --');
        }
        else{
          print('---- elsing ---${controller.status}---');
        }
      }
      await Future.delayed(Duration.zero);
      final frame = await captureScreen();
      frames.add(frame);
    }


    showDialog(
      context: Get.context!,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            height: 800,
            width: 1500,
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: frames.length,
              itemBuilder: (BuildContext context, int index) {
                final image = frames[index];
                return Container(
                  height: 350,
                  child: Image.memory(
                    image
                    //image.buffer.asUint8List(),
                  ),
                );
              },
            ),
          ),
        );
      },
    );

  }

  void generateFramesZ()async{
    hasAnimListener = false ;
    List<Uint8List> scList = [];
    const animDuration = 1000;
    late final PausableTimer timer;
    timer =  PausableTimer.periodic(const Duration(milliseconds: 41), ()async{
      //print('---ticking---- n : ${timer.tick} ---- milSec: ${timer.tick*41} ----');

      //print('---sl----- ${gridsAnimControllers.where((element) => element!=null)}');
      for(var controller in gridsAnimControllers.where((element) => element!=null)){
        controller?.reset();
        controller?.stop();
      }
      timer.pause();
      final result = await captureScreen();
      scList.add(result);
      for(var controller in gridsAnimControllers){
        controller!.value = 0.2;
      }
      if(timer.tick*41<=animDuration){
        timer.start();
      }
      else{
        timer.cancel();
      }

    },
    )..start();





/*    Timer.periodic(const Duration(milliseconds: 42), (Timer timer)async{
      if(timer.tick*42 <= animDuration){
        print('---ticking---- ${timer.tick} ---- ${timer.tick*42} ----');
        for(var controller in gridsAnimControllers){
          controller?.stop();

        }
        final result = await captureScreen();
        scList.add(result);
        for(var controller in gridsAnimControllers){
          controller?.forward();
        }
      }
      else{
        print('---last tick---- ${timer.tick} --');
        timer.cancel();
      }

    });
    Future.delayed(const Duration(seconds: 10),(){
      print('-----list of sc---- ${scList.length} ----');
    });*/

  }

  Future<Uint8List> captureScreen()async{
    // Perform the screen capture and handle the image as needed
    // Example: Save the image to storage or display it in a dialog
    // Here, we just print the image size for demonstration purposes
    RenderRepaintBoundary boundary = githubMemeBoundryGlobalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await  boundary.toImage();
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    if (byteData != null) {
      //print('Captured image size: ${byteData.lengthInBytes} bytes');
      return Uint8List.fromList(byteData.buffer.asUint8List());
    }
    else{
      throw Exception();
    }
  }

}