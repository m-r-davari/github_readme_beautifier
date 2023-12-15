import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'package:ffmpeg_wasm/ffmpeg_wasm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:html' as html;
import 'dart:js' as js;

import 'package:github_readme_beautifier/resources/github_grid_themes.dart';
import 'package:github_readme_beautifier/utils/utils.dart';

GlobalKey githubMemeBoundryGlobalKey = GlobalKey();

class GithubMemeController extends GetxController{

  RxList<int> grids = List.filled(368, 0).obs;
  List<AnimationController?> gridsAnimControllers = [];

  bool hasAnimListener = true;
  final ffmpeg = Get.find<FFmpeg>();

  GithubGridThemes themes = GithubGridThemes();
  Rx<bool> isLight = true.obs;

  final Utils _utils = Utils();


  Future<void> generateFrames()async{
    hasAnimListener = false ;
    List<Uint8List> frames = [];//frames list
    const int exportDuration = 1000; //milSec
    //exportDuration / 41 = 24 fps
    for(var controller in gridsAnimControllers){
      controller?.stop();
    }
    await Future.delayed(Duration.zero);
    for(int i = 0 ; i<= exportDuration/41 ; i++){
      for(var controller in gridsAnimControllers){
        if (controller!.status == AnimationStatus.forward){
          controller.value += 0.1;
        }
        else if (controller.status == AnimationStatus.completed){
          controller.reverse();
        }
        else if (controller.status == AnimationStatus.reverse){
          controller.value -= 0.1;
        }
        else if (controller.status == AnimationStatus.dismissed){
          controller.forward() ;
        }
      }
      await Future.delayed(Duration.zero);
      final frame = await captureScreen();
      frames.add(frame);

    }

    final List<Uint8List> reverseFrames = [];
    print('----org frames --- ${frames.length}');
    reverseFrames.addAll(List.of(frames).reversed);
    frames.addAll(reverseFrames);
    print('----rev frames --- ${reverseFrames.length}');
    print('----all frames --- ${frames.length}');
    await createAnimatedGif(frames);

    for(final gridAnimController in gridsAnimControllers){
      hasAnimListener = true;
      // gridAnimController!.value = _utils.generateUniqueRandomDouble(0.01, 1.0);.
      // gridAnimController.forward();
      Future.delayed(Duration(milliseconds: _utils.generateRandomNumFromRange(50, 500)),(){
        gridAnimController!.forward();
      });
    }

  }


  Future<void> createAnimatedGif(List<Uint8List> frames)async{

    for (int i = 0; i < frames.length ; i++) {
      ffmpeg.writeFile(i < 10 ? 'github_meme_00$i.png' : 'github_meme_0$i.png', frames[i]);
    }

    //frame rate changes from 24 to 50
    //because with reverse frames we have total 50 frames and if we want to use 24 fps export it will deduct frames and cause the
    //non equal start and end frame of our frame list when we set the frame rate to 50 , in export the start and end frame wil
    //the same, but it will increase the gif size, we could make lower frame rate on frames for generator to make sure both
    // forward and reverse frames to gether will be around 50 frames so we need to have around 12 org frames and then
    // with 12 reverse frames the total frames will be 24 and ir will fix the gif size but may have effect on animation smoothness

    //another idea for make start and end frame equals is to make two gif, first with 24 frames and then
    //make the created gif reversed, and then concat two gif to each other,
    // below is the sample code for this idea, it should be test


    await ffmpeg.run([
      '-framerate', '50',
      '-i', 'github_meme_%03d.png',
      '-vf', 'palettegen=max_colors=128', //palettegen //palettegen=max_colors=256 //'palettegen=stats_mode=single:max_colors=256'
      'palette.png',
    ]);

    await ffmpeg.run([
      '-framerate', '50',
      '-i', 'github_meme_%03d.png',
      '-i', 'palette.png',
      '-lavfi', 'paletteuse=dither=bayer:bayer_scale=5',
      //'-filter_complex', //'[0:v][1:v]paletteuse',//'[0:v][1:v]paletteuse=dither=bayer:bayer_scale=5' // [0:v][1:v]paletteuse=dither=floyd_steinberg //[0:v][1:v]paletteuse //paletteuse
      '-t', '1',
      '-loop', '0',
      '-r', '50',
      '-f', 'gif',
      'output.gif',
    ]);
    final previewWebpData = ffmpeg.readFile('output.gif');
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