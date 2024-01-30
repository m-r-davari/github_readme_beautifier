import 'dart:typed_data';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:github_readme_beautifier/core/exceptions/exceptions.dart';
import 'package:github_readme_beautifier/core/gif_maker/i_gif_maker.dart';
import 'package:github_readme_beautifier/core/gif_optimizer/i_gif_optimizer.dart';
import 'package:github_readme_beautifier/core/screenshot_maker/i_screenshot_maker.dart';
import 'package:github_readme_beautifier/core/states/states.dart';
import 'package:github_readme_beautifier/data/github_friends/models/github_firend_model.dart';
import 'package:github_readme_beautifier/data/github_friends/repository/i_github_friends_repository.dart';
import 'package:github_readme_beautifier/presentation/exporter/exporter_controller.dart';

GlobalKey githubFriendsGlobalKey = GlobalKey();

class GithubFriendsController extends GetxController {

  Rx<UIState> state = Rx<UIState>(LoadingState());
  IGithubFriendsRepository repository = Get.find();
  List<GithubFriendModel> selectedFriends = [];
  final maxFriendsNum = 5;
  Rx<bool> isLight = true.obs;
  ExporterController exporterController = Get.find();
  IGifMaker gifMaker = Get.find<IGifMaker>();
  IScreenshotMaker screenShotMaker = Get.find();
  IGifOptimizer gifOptimizer = Get.find();
  final CarouselController carouselController = CarouselController();

  Future<void> getGithubFriends({required String userName})async{
    try {
      final result = await repository.getGithubFriends(userName: userName);
      state.value = SuccessState<List<GithubFriendModel>>(result);
    }
    on NetworkException catch(e){
      state.value = FailureState(error: e.message);
    }
    catch (e) {
      state.value = FailureState(error: e.toString());
    }

  }


  Future<void> export({required String userName}) async {

    exporterController.progress.value = 0.0;
    List<Uint8List> lightFrames = [];
    exporterController.fileName.value = '${userName}_github_friends';

    await screenShotMaker.captureScreen(key: githubFriendsGlobalKey); // this line must exit because for first time
    // take screen shot has much more delay than other time so we take screen shot before starting to record screen to
    // prevent delay bug
    carouselController.jumpToPage(selectedFriends.length - 1);
    await Future.delayed(const Duration(milliseconds: 500));
    for (int i = 0; i < selectedFriends.length; i++) {
      carouselController.animateToPage(i,duration: const Duration(milliseconds: 250));
      for (int j = 0; j < 15; j++) {
        final frame = await screenShotMaker.captureScreen(key: githubFriendsGlobalKey);
        lightFrames.add(frame);
        exporterController.progress.value += (1 / (15 * selectedFriends.length)) / 2;
        await Future.delayed(const Duration(milliseconds: 1));
      }
    }


    exporterController.progress.value = 0.5;
    isLight.value = false;

    List<Uint8List> darkFrames = [];
    await Future.delayed(const Duration(milliseconds: 150));
    for (int i = 0; i < selectedFriends.length; i++) {
      carouselController.animateToPage(i,duration: const Duration(milliseconds: 250));
      for (int j = 0; j < 15; j++) {
        final frame = await screenShotMaker.captureScreen(key: githubFriendsGlobalKey);
        darkFrames.add(frame);
        exporterController.progress.value += ((1 / (15 * selectedFriends.length)) / 2) - 0.0001;
        await Future.delayed(const Duration(milliseconds: 1));
      }
    }

    exporterController.progress.value = 0.99;

    final originalTypewriterLightGif = await gifMaker.createGif(
        frames: lightFrames,
        fileName: '${userName}_github_friends_light',
        frameRate: '15',
        exportRate: '15',
        bayer: '1',
    );
    final optimizedTypewriterLightGif = await gifOptimizer.optimizeGif(
      originalGif: originalTypewriterLightGif,
    );
    final originalTypewriterDarkGif = await gifMaker.createGif(
        frames: darkFrames,
        fileName: '${userName}_github_friends_dark',
        frameRate: '15',
        exportRate: '15',
        bayer: '1',
    );
    final optimizedTypewriterDarkGif = await gifOptimizer.optimizeGif(originalGif: originalTypewriterDarkGif);

    exporterController.gifs.clear();
    exporterController.gifs.add(originalTypewriterLightGif);
    exporterController.gifs.add(optimizedTypewriterLightGif);
    exporterController.gifs.add(originalTypewriterDarkGif);
    exporterController.gifs.add(optimizedTypewriterDarkGif);
    exporterController.progress.value = 1.0;

    isLight.value = true;

  }


}