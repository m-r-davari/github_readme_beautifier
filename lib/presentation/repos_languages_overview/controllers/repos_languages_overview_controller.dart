import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:github_readme_beautifier/core/exceptions/exceptions.dart';
import 'package:github_readme_beautifier/core/gif_maker/i_gif_maker.dart';
import 'package:github_readme_beautifier/core/gif_optimizer/i_gif_optimizer.dart';
import 'package:github_readme_beautifier/core/screenshot_maker/i_screenshot_maker.dart';
import 'package:github_readme_beautifier/core/states/states.dart';
import 'package:github_readme_beautifier/data/repos_languages_overview/repository/i_repos_languages_overview_repository.dart';
import 'package:github_readme_beautifier/presentation/exporter/exporter_controller.dart';


GlobalKey reposLangOverviewBoundryGlobalKey = GlobalKey();

class ReposLanguagesOverviewController extends GetxController {
  final repository = Get.find<IReposLanguagesOverviewRepository>();
  Rx<UIState> state = Rx<UIState>(LoadingState());
  Rx<bool> isLight = true.obs;
  IGifMaker gifMaker = Get.find<IGifMaker>();
  IScreenshotMaker screenShotMaker = Get.find();
  IGifOptimizer gifOptimizer = Get.find();
  ExporterController exporterController = Get.find();
  RxInt touchedIndex = (-1).obs;


  Future<void> getReposLanguagesOverview({required String userName}) async {
    try {
      final result = await repository.getReposLanguagesOverview(userName: userName);
      print('---- sssss ---- $result');
      state.value = SuccessState<Map<String, int>>(result);
    } on NetworkException catch (e) {
      state.value = FailureState(error: e.message);
    } catch (e) {
      state.value = FailureState(error: e.toString());
    }
  }



  Future<void> export({required String userName}) async {
    exporterController.gifs.clear();
    Map<String, int> langsData = (state.value as SuccessState).data;
    exporterController.progress.value = 0.0;
    List<Uint8List> lightFrames = [];
    exporterController.fileName.value = '${userName}_langs_overview';

    if (langsData.length == 1) {
      touchedIndex.value = 0;
      await Future.delayed(const Duration(milliseconds: 100));
      final frame = await screenShotMaker.captureScreen(key: reposLangOverviewBoundryGlobalKey);
      lightFrames.add(frame);
    } else {
      touchedIndex.value = langsData.length - 1;
      await Future.delayed(const Duration(milliseconds: 500));
      for (int i = 0; i < langsData.length; i++) {
        await screenShotMaker.captureScreen(key: reposLangOverviewBoundryGlobalKey); // this line must exit because for first time
        // take screen shot has much more delay than other time so we take screen shot before starting to record screen to
        // prevent delay bug
        touchedIndex.value = i;
        for (int j = 0; j < 15; j++) {
          final frame = await screenShotMaker.captureScreen(key: reposLangOverviewBoundryGlobalKey,pixelRatio: 1);
          lightFrames.add(frame);
          exporterController.progress.value += (1 / (15 * langsData.length)) / 2;
          await Future.delayed(const Duration(milliseconds: 1));
        }
      }
    }


    exporterController.progress.value = 0.5;
    isLight.value = false;
    await Future.delayed(const Duration(milliseconds: 150));

    List<Uint8List> darkFrames = [];
    await Future.delayed(const Duration(milliseconds: 150));

    if (langsData.length == 1) {
      final frame = await screenShotMaker.captureScreen(key: reposLangOverviewBoundryGlobalKey);
      darkFrames.add(frame);
    } else {
      for (int i = 0; i < langsData.length; i++) {
        touchedIndex.value = i;
        for (int j = 0; j < 15; j++) {
          final frame = await screenShotMaker.captureScreen(key: reposLangOverviewBoundryGlobalKey,pixelRatio: 1);
          darkFrames.add(frame);
          exporterController.progress.value += ((1 / (15 * langsData.length)) / 2) - 0.0001;
          await Future.delayed(const Duration(milliseconds: 1));
        }
      }
    }

    exporterController.progress.value = 0.99;

    final originalTypewriterLightGif = await gifMaker.createGif(
        frames: lightFrames,
        fileName: '${userName}_langs_overview_light',
        frameRate: '15',
        exportRate: '15');
    final optimizedTypewriterLightGif = await gifOptimizer.optimizeGif(
      originalGif: originalTypewriterLightGif,
    );
    final originalTypewriterDarkGif = await gifMaker.createGif(
        frames: darkFrames,
        fileName: '${userName}_langs_overview_light',
        frameRate: '15',
        exportRate: '15');
    final optimizedTypewriterDarkGif = await gifOptimizer.optimizeGif(originalGif: originalTypewriterDarkGif);

    exporterController.gifs.clear();
    exporterController.gifs.add(originalTypewriterLightGif);
    exporterController.gifs.add(optimizedTypewriterLightGif);
    exporterController.gifs.add(originalTypewriterDarkGif);
    exporterController.gifs.add(optimizedTypewriterDarkGif);
    exporterController.progress.value = 1.0;

    isLight.value = true;
    touchedIndex.value = -1;

    // print('----ligh frames ---- ${lightFrames.length} ----');
    // print('----dark frames ---- ${darkFrames.length} ----');
  }



}
