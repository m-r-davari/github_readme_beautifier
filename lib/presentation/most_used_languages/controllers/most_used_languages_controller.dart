import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:github_readme_beautifier/core/gif_maker/i_gif_maker.dart';
import 'package:github_readme_beautifier/core/gif_optimizer/i_gif_optimizer.dart';
import 'package:github_readme_beautifier/core/screenshot_maker/i_screenshot_maker.dart';
import 'package:github_readme_beautifier/data/most_used_languages/repository/i_most_used_languages_repository.dart';
import 'package:github_readme_beautifier/presentation/exporter/exporter_controller.dart';

GlobalKey mostLangsBoundryGlobalKey = GlobalKey();

class MostUsedLanguagesController extends GetxController {

  RxMap<String,int> langsData = <String,int>{}.obs;
  final repository = Get.find<IMostLanguagesRepository>();
  Rx<bool> isLight = true.obs;
  IGifMaker gifMaker = Get.find<IGifMaker>();
  IScreenshotMaker screenShotMaker = Get.find();
  IGifOptimizer gifOptimizer = Get.find();
  ExporterController exporterController = Get.find();
  RxInt touchedIndex = (-1).obs;
  int staggeredDuration = 1000;
  RxBool isRecording = false.obs;
  Rx<Key> staggeredKey = UniqueKey().obs;

  Future<void> getMostLanguages(String userName)async{
    langsData.value = await repository.getMostLanguages(userName: userName);
  }

  Future<void> export()async{

    exporterController.progress.value = 0.1;
    List<Uint8List> lightFrames = [];
    double progress = 0;
    //start anims
    //isRecording.value = !isRecording.value;
    staggeredKey.value = UniqueKey();

    await Future.delayed(const Duration(milliseconds: 200));

    //formule inyeki : tedade item ha * duration haye widget stagred / 41 k fps baeshe
    //masalan : 6ta item lang darin va duration haye delay/duration stagred 500 mili sanie hast bayad
    //(6 * 500) / 41 beshe va adadi k dar miad => 73 dar loop for gharar migire
    //chon ham ghable for va ham dakhelesh delay dasti darim meghdare b dast oomade (73) bayad menhaye delay dakhele for va bezafe delay
    // ghabl az for beshe ta dar akhare gif delay nadashte bashim
    // edame formul ((10 * 73) / 41 => 17) va (200 / 41 => 4) va dar akhar (73 - 17 + 4) => 60

    for(int i = 0; i<36; i++){
      final frame = await screenShotMaker.captureScreen(key: mostLangsBoundryGlobalKey);
      lightFrames.add(frame);
      await Future.delayed(const Duration(milliseconds: 10));
    }

    for(int i = 0; i < langsData.length ; i++){
      touchedIndex.value = i;
      for(int j = 0; j < 12; j++){
        final frame = await screenShotMaker.captureScreen(key: mostLangsBoundryGlobalKey);
        lightFrames.add(frame);
        await Future.delayed(const Duration(milliseconds: 10));
      }
      await Future.delayed(const Duration(milliseconds: 50));
    }

    exporterController.progress.value = 0.5;

    isLight.value = false;

    List<Uint8List> darkFrames = [];
    staggeredKey.value = UniqueKey();
    await Future.delayed(const Duration(milliseconds: 200));

    for(int i = 0; i<36; i++){
      final frame = await screenShotMaker.captureScreen(key: mostLangsBoundryGlobalKey);
      darkFrames.add(frame);
      await Future.delayed(const Duration(milliseconds: 10));
    }

    for(int i = 0; i < langsData.length ; i++){
      touchedIndex.value = i;
      for(int j = 0; j < 12; j++){
        final frame = await screenShotMaker.captureScreen(key: mostLangsBoundryGlobalKey);
        darkFrames.add(frame);
        await Future.delayed(const Duration(milliseconds: 10));
      }
      await Future.delayed(const Duration(milliseconds: 50));
    }

    final originalTypewriterLightGif = await gifMaker.createGif(frames: lightFrames, fileName: 'most_langs_light',exportFileName: 'out_most_langs_light',frameRate: '${lightFrames.length}',exportRate: '${lightFrames.length}');
    final optimizedTypewriterLightGif = await gifOptimizer.optimizeGif(originalGif: originalTypewriterLightGif,);
    final originalTypewriterDarkGif = await gifMaker.createGif(frames: darkFrames, fileName: 'most_langs_dark',exportFileName: 'out_most_langs_dark',frameRate: '${darkFrames.length}',exportRate: '${lightFrames.length}');
    final optimizedTypewriterDarkGif = await gifOptimizer.optimizeGif(originalGif: originalTypewriterDarkGif);//

    exporterController.gifs.clear();
    exporterController.gifs.add(originalTypewriterLightGif);
    exporterController.gifs.add(optimizedTypewriterLightGif);
    exporterController.gifs.add(originalTypewriterDarkGif);
    exporterController.gifs.add(optimizedTypewriterDarkGif);
    exporterController.progress.value = 1.0;

    isLight.value = true;
    touchedIndex.value = -1;


    print('----ligh frames ---- ${lightFrames.length} ----');
    print('----dark frames ---- ${darkFrames.length} ----');

  }

}