import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as ui;
import 'package:ffmpeg_wasm/ffmpeg_wasm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:html' as html;
import 'dart:js' as js;

import 'package:github_readme_beautifier/resources/github_grid_themes.dart';

GlobalKey githubMemeBoundryGlobalKey = GlobalKey();

class GithubMemeController extends GetxController{

  List<AnimationController?> gridsAnimControllers = [];

  bool hasAnimListener = true;

  final ffmpeg = Get.find<FFmpeg>();

  GithubGridThemes themes = GithubGridThemes();
  Rx<bool> isLight = true.obs;
  late Rx<Color> bgColor = themes.lightBg.obs;
  late Rx<Color> unCommitColor = themes.unCommitLightColor.obs;

  @override
  void onInit() {
    // bgColor.value = themes.lightBg.;
    // unCommitColor.value = themes.unCommitLightColor;
    super.onInit();
  }


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
      //todo : re active animate after generating frames and gif.
    }


    final List<Uint8List> reverseFrames = [];
    reverseFrames.addAll(List.of(frames).reversed);
    frames.addAll(reverseFrames);
    await createAnimatedGif(frames);

    //return;

/*    showDialog(
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
    );*/



  }





  Future<void> createAnimatedGif(List<Uint8List> frames)async{

    for (int i = 0; i < frames.length ; i++) {
      ffmpeg.writeFile(i < 10 ? 'github_meme_00$i.png' : 'github_meme_0$i.png', frames[i]);
      print('----writing files--png $i--');
    }

    //return;

    // for (int i = 0; i <= 18; i++) {
    //   final ByteData data = await rootBundle.load(i < 10 ? 'github_meme_00$i.png' : 'github_meme_0$i.png');
    //   final file = data.buffer.asUint8List();
    //   ffmpeg.writeFile(i < 10 ? 'github_meme_00$i.png' : 'github_meme_0$i.png', file);
    //   print('----writing files--png $i--');
    // }



    await ffmpeg.run([
      '-framerate', '24',
      '-i', 'github_meme_%03d.png',
      '-vf', 'palettegen=max_colors=256', //palettegen //palettegen=max_colors=256 //'palettegen=stats_mode=single:max_colors=256'
      'palette.png',
    ]);

    await ffmpeg.run([
      '-framerate', '24',
      '-i', 'github_meme_%03d.png',
      '-i', 'palette.png',
      '-lavfi', 'paletteuse=dither=bayer:bayer_scale=5',
      //'-filter_complex', //'[0:v][1:v]paletteuse',//'[0:v][1:v]paletteuse=dither=bayer:bayer_scale=5' // [0:v][1:v]paletteuse=dither=floyd_steinberg //[0:v][1:v]paletteuse //paletteuse
      '-t', '1',
      '-loop', '0',
      '-r', '24',
      '-f', 'gif',
      'output.gif',
    ]);
    print('----end run----');
    print('----start readFile----');
    final previewWebpData = ffmpeg.readFile('output.gif');
    print('----end readFile----');
    print('----start outing----');
    js.context.callMethod('webSaveAs', [
      html.Blob([previewWebpData]),
      'output.gif'
    ]);



    showDialog(
      context: Get.context!,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            height: 800,
            width: 1500,
            child: Container(
              color: Colors.transparent,
              height: 350,
              child: Image.memory(
                  previewWebpData
                //image.buffer.asUint8List(),
              ),
            ),
          ),
        );
      },
    );
  }




//----------------------------

  Future<Uint8List> captureScreen()async{
    // Perform the screen capture and handle the image as needed
    // Example: Save the image to storage or display it in a dialog
    // Here, we just print the image size for demonstration purposes
    RenderRepaintBoundary boundary = githubMemeBoundryGlobalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await  boundary.toImage(pixelRatio: 1.0);//min 0.8 - def 1 - max 2
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    if (byteData != null) {
      //print('Captured image size: ${byteData.lengthInBytes} bytes');
      return Uint8List.fromList(byteData.buffer.asInt8List());//byteData.buffer.asUint8List()
    }
    else{
      throw Exception();
    }
  }

}