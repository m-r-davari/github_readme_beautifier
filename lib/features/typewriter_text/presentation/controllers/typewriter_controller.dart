import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:github_readme_beautifier/features/common/exporter/exporter_controller.dart';
import 'package:github_readme_beautifier/core/downloader/i_downloader.dart';
import 'package:github_readme_beautifier/core/gif_maker/i_gif_maker.dart';
import 'package:github_readme_beautifier/core/gif_optimizer/i_gif_optimizer.dart';
import 'package:github_readme_beautifier/core/screenshot_maker/i_screenshot_maker.dart';
import 'package:github_readme_beautifier/features/typewriter_text/presentation/widgets/typewriter_rich_text.dart';

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
  ExporterController exporterController = Get.find();
  String loopCount = '-1';
  bool loopDelay = true;

  void replay(){
    typewriterRichTextKey.currentState!.replay();
  }

  Future<void> export()async{
    exporterController.fileName.value = 'typewriter_text';
    isLight.value = true;
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
      exporterController.progress.value = progress/2;
    }
    exporterController.progress.value = 0.5;
    print('----light frame lenght is : ---- ${lightTextFrames.length} -----');
    isLight.value = false;
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
      exporterController.progress.value = progress < 1.0 ? 0.5+progress/2 : 0.99;
    }
    print('----dark frame lenght is : ---- ${darkTextFrames.length} -----');

    //creating gif
    final originalTypewriterLightGif = await gifMaker.createGif(frames: lightTextFrames, fileName: 'typewriter_text_light',exportFileName: 'out_text_light',frameRate: '${lightTextFrames.length}',exportRate: '${lightTextFrames.length}',loopNum: loopCount, loopDelay: loopDelay);
    final optimizedTypewriterLightGif = await gifOptimizer.optimizeGif(originalGif: originalTypewriterLightGif,);
    final originalTypewriterDarkGif = await gifMaker.createGif(frames: darkTextFrames, fileName: 'typewriter_text_dark',exportFileName: 'out_text_dark',frameRate: '${darkTextFrames.length}',exportRate: '${lightTextFrames.length}',loopNum: loopCount, loopDelay: loopDelay);
    final optimizedTypewriterDarkGif = await gifOptimizer.optimizeGif(originalGif: originalTypewriterDarkGif);//

    //sfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffzzzzzzzzzzxxxc.

    print('---- json document is : --- $documentJson----');
    print('----plain text is  : ---- $documentPlainText --- txtLen is : ${documentPlainText.length} -- lighFLen is : ${lightTextFrames.length} --- darkFLen is : ${darkTextFrames.length}--');

    exporterController.gifs.clear();
    exporterController.gifs.add(originalTypewriterLightGif);
    exporterController.gifs.add(optimizedTypewriterLightGif);
    exporterController.gifs.add(originalTypewriterDarkGif);
    exporterController.gifs.add(optimizedTypewriterDarkGif);
    exporterController.progress.value = 1.0;

    progress = 0;
    isLight.value = true;
    typewriterRichTextKey.currentState!.reset();
    await Future.delayed(const Duration(milliseconds: 50));
    while(progress*100 < 100){
      progress = typewriterRichTextKey.currentState!.nextFrame();
    }

  }






}