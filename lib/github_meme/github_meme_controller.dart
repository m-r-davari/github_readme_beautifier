import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:github_readme_beautifier/utils/pausable_timer.dart';

GlobalKey githubMemeBoundryGlobalKey = GlobalKey();

class GithubMemeController extends GetxController{

  List<AnimationController?> gridsAnimControllers = List.filled(368, null);

  void generateFrames ()async{

    List<Uint8List> scList = [];
    //generates frames png
    const animDuration = 1000;

    late final PausableTimer timer;
    timer =  PausableTimer.periodic(const Duration(milliseconds: 41), ()async{
      print('---ticking---- n : ${timer.tick} ---- milSec: ${timer.tick*41} ----');
      print('-----------------vv-------------${gridsAnimControllers.where((element) => element!=null).length}');
      for(final controller in gridsAnimControllers.where((element) => element!=null)){
        print('-----stoping');
        controller?.stop();
      }
      timer.pause();
      final result = await captureScreen();
      scList.add(result);
      for(final controller in gridsAnimControllers.where((element) => element!=null)){
        print('-----starting');
        controller?.forward();
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
      print('Captured image size: ${byteData.lengthInBytes} bytes');
      return Uint8List.fromList(byteData.buffer.asUint8List());
    }
    else{
      throw Exception();
    }
  }

}