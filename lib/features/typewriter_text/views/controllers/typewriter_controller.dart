import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:github_readme_beautifier/core/downloader/i_downloader.dart';
import 'package:github_readme_beautifier/core/gif_maker/i_gif_maker.dart';
import 'package:github_readme_beautifier/core/gif_optimizer/i_gif_optimizer.dart';
import 'package:github_readme_beautifier/core/screenshot_maker/i_screenshot_maker.dart';
import 'package:github_readme_beautifier/features/typewriter_text/views/widgets/typewriter_rich_text.dart';

GlobalKey<TypewriterRichTextState> typewriterRichTextKey = GlobalKey();
GlobalKey typeWriterBoundryGlobalKey = GlobalKey();

class TypeWriterController extends GetxController {

  String documentJson = '{}';
  String documentPlainText = '';
  Rx<bool> isLight = true.obs;
  IGifMaker gifMaker = Get.find<IGifMaker>();
  IScreenshotMaker screenShotMaker = Get.find();
  IDownloader downloader = Get.find();
  IGifOptimizer gifOptimizer = Get.find();



  Future<void> export()async{
    List<Uint8List> lightTextFrames = [];
    double progress = 0;
    typewriterRichTextKey.currentState!.reset();
    await Future.delayed(const Duration(milliseconds: 200));
    while(progress*100 < 100){
      print('----capture frame --- $progress ---');
      final frame = await screenShotMaker.captureScreen(key: typeWriterBoundryGlobalKey);
      lightTextFrames.add(frame);
      progress = typewriterRichTextKey.currentState!.nextFrame();
      await Future.delayed(Duration.zero);
    }
    print('----light frame lenght is : ---- ${lightTextFrames.length} -----');

    isLight.value = !isLight.value;
    typewriterRichTextKey.currentState!.reset();
    List<Uint8List> darkTextFrames = [];
    progress = 0;
    await Future.delayed(const Duration(milliseconds: 200));
    while(progress*100 < 100){
      print('----capture frame --- $progress ---');
      final frame = await screenShotMaker.captureScreen(key: typeWriterBoundryGlobalKey);
      darkTextFrames.add(frame);
      progress = typewriterRichTextKey.currentState!.nextFrame();
      await Future.delayed(Duration.zero);
    }
    print('----dark frame lenght is : ---- ${darkTextFrames.length} -----');

    //creating gif
    final originalTypewriterLightGif = await gifMaker.createGif(frames: lightTextFrames, fileName: 'typewriter_text_light',frameRate: '${lightTextFrames.length}',exportRate: '${lightTextFrames.length}',loopNum: '-1');
    final optimizedTypewriterLightGif = await gifOptimizer.optimizeGif(originalGif: originalTypewriterLightGif,);
    final originalTypewriterDarkGif = await gifMaker.createGif(frames: darkTextFrames, fileName: 'typewriter_text_dark',frameRate: '${darkTextFrames.length}',exportRate: '${lightTextFrames.length}',loopNum: '-1');
    final optimizedTypewriterDarkGif = await gifOptimizer.optimizeGif(originalGif: originalTypewriterDarkGif);//

    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          content: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Image.memory(lightTextFrames.last), const SizedBox(height: 16,),
                Image.memory(originalTypewriterLightGif), const SizedBox(height: 16,),
                Image.memory(optimizedTypewriterLightGif), const SizedBox(height: 16,),
                Image.memory(originalTypewriterDarkGif), const SizedBox(height: 16,),
                Image.memory(optimizedTypewriterDarkGif), const SizedBox(height: 16,),
              ],
            ),
          ),
        );
      },
    );

  }

}