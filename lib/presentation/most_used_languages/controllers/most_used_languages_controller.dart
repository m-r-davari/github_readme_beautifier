import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:github_readme_beautifier/core/gif_maker/i_gif_maker.dart';
import 'package:github_readme_beautifier/core/gif_optimizer/i_gif_optimizer.dart';
import 'package:github_readme_beautifier/core/screenshot_maker/i_screenshot_maker.dart';
import 'package:github_readme_beautifier/core/states/states.dart';
import 'package:github_readme_beautifier/data/most_used_languages/repository/i_most_used_languages_repository.dart';
import 'package:github_readme_beautifier/presentation/exporter/exporter_controller.dart';

GlobalKey mostLangsBoundryGlobalKey = GlobalKey();

class MostUsedLanguagesController extends GetxController {

  Rx<UIState> state = Rx<UIState>(LoadingState());
  final repository = Get.find<IMostLanguagesRepository>();
  Rx<bool> isLight = true.obs;
  IGifMaker gifMaker = Get.find<IGifMaker>();
  IScreenshotMaker screenShotMaker = Get.find();
  IGifOptimizer gifOptimizer = Get.find();
  ExporterController exporterController = Get.find();
  RxInt touchedIndex = (-1).obs;

  Future<void> getMostLanguages(String userName)async{
    try{
      final result = await repository.getMostLanguages(userName: userName);
      state.value = SuccessState<Map<String,int>>(result);
    }
    catch (e){
      state.value = FailureState();
    }

  }

  Future<void> export()async{
    Map<String,int> langsData = (state.value as SuccessState).data;
    exporterController.progress.value = 0.0;
    List<Uint8List> lightFrames = [];
    exporterController.fileName.value = 'most_used_language';

    //formule inyeki : tedade item ha * duration haye widget stagred / 41 k fps baeshe
    //masalan : 6ta item lang darin va duration haye delay/duration stagred 500 mili sanie hast bayad
    //(6 * 500) / 41 beshe va adadi k dar miad => 73 dar loop for gharar migire
    //chon ham ghable for va ham dakhelesh delay dasti darim meghdare b dast oomade (73) bayad menhaye delay dakhele for va bezafe delay
    // ghabl az for beshe ta dar akhare gif delay nadashte bashim
    // edame formul ((10 * 73) / 41 => 17) va (200 / 41 => 4) va dar akhar (73 - 17 + 4) => 60



    if(langsData.length==1){
      final frame = await screenShotMaker.captureScreen(key: mostLangsBoundryGlobalKey);
      lightFrames.add(frame);
    }
    else{
      touchedIndex.value = langsData.length-1;
      await Future.delayed(const Duration(milliseconds: 500));
      for(int i = 0; i < langsData.length ; i++){
        touchedIndex.value = i;
        await Future.delayed(const Duration(milliseconds: 10));
        for(int j = 0; j < 30; j++){
          final frame = await screenShotMaker.captureScreen(key: mostLangsBoundryGlobalKey);
          lightFrames.add(frame);
          exporterController.progress.value += (1/(30*langsData.length))/2;
          await Future.delayed(const Duration(milliseconds: 10));
        }
      }
    }


    exporterController.progress.value = 0.5;
    isLight.value = false;

    List<Uint8List> darkFrames = [];
    await Future.delayed(const Duration(milliseconds: 200));

    if(langsData.length==1){
      final frame = await screenShotMaker.captureScreen(key: mostLangsBoundryGlobalKey);
      darkFrames.add(frame);
    }
    else{
      for(int i = 0; i < langsData.length ; i++){
        touchedIndex.value = i;
        await Future.delayed(const Duration(milliseconds: 10));
        for(int j = 0; j < 30; j++){
          final frame = await screenShotMaker.captureScreen(key: mostLangsBoundryGlobalKey);
          darkFrames.add(frame);
          exporterController.progress.value += ((1/(30*langsData.length))/2)-0.0001;
          await Future.delayed(const Duration(milliseconds: 10));
        }
      }
    }


    exporterController.progress.value = 0.99;

    final originalTypewriterLightGif = await gifMaker.createGif(frames: lightFrames, fileName: 'most_langs_light',exportFileName: 'out_most_langs_light',frameRate: '24',exportRate: '24');
    final optimizedTypewriterLightGif = await gifOptimizer.optimizeGif(originalGif: originalTypewriterLightGif,);
    final originalTypewriterDarkGif = await gifMaker.createGif(frames: darkFrames, fileName: 'most_langs_dark',exportFileName: 'out_most_langs_dark',frameRate: '24',exportRate: '24');
    final optimizedTypewriterDarkGif = await gifOptimizer.optimizeGif(originalGif: originalTypewriterDarkGif);

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