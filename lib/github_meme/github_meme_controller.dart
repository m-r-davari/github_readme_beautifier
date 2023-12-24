import 'dart:async';
import 'dart:html';
import 'dart:typed_data';
import 'dart:ui';
import 'package:ffmpeg_wasm/ffmpeg_wasm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:js/js.dart';
import 'dart:html' as html;
import 'dart:js' as js;
import 'package:js/js_util.dart' as jsUtil;
import 'package:github_readme_beautifier/resources/github_grid_themes.dart';
import 'package:github_readme_beautifier/utils/utils.dart';

GlobalKey githubMemeBoundryGlobalKey = GlobalKey();

@JS('optimizeGifAndReturn')
external dynamic optimizeGifAndReturn(blob);

class GithubMemeController extends GetxController{

  List<int> grids = List.filled(368, 0);
  List<AnimationController?> gridsAnimControllers = [];
  bool hasAnimListener = true;
  final ffmpeg = Get.find<FFmpeg>();
  GithubGridThemes themes = GithubGridThemes();
  Rx<bool> isLight = true.obs;
  final Utils _utils = Utils();
  RxDouble exportProgressValue = 0.0.obs;

  Future<Uint8List> _createAnimatedGif()async{

    final frames = await _generateFrames();

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
    // '-r' is the frame rate of export it must be 24 and it effects the size of gif higher -r will cause higher size. 20~24 is good.


    await ffmpeg.run([
      '-framerate', '50',
      '-i', 'github_meme_%03d.png',
      '-vf', 'palettegen=max_colors=200', //palettegen //palettegen=max_colors=256 //'palettegen=stats_mode=single:max_colors=256'
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
      '-r', '20',
      '-f', 'gif',
      'output.gif',
    ]);
    final gifData = ffmpeg.readFile('output.gif');
    ffmpeg.unlink('output.gif');
    return gifData;

  }

  Future<List<Uint8List>> _generateFrames()async{
    List<Uint8List> frames = [];//frames list
    const int exportDuration = 1000; //milSec
    //exportDuration / 41 = 24 fps
    for(var controller in gridsAnimControllers){
      controller?.stop();
    }
    await Future.delayed(Duration.zero);
    for(int i = 0 ; i < exportDuration/41 ; i++){
      for(var controller in gridsAnimControllers){
        if (controller!.status == AnimationStatus.forward){
          controller.value += 0.041;
        }
        else if (controller.status == AnimationStatus.completed){
          controller.reverse();
        }
        else if (controller.status == AnimationStatus.reverse){
          controller.value -= 0.041;
        }
        else if (controller.status == AnimationStatus.dismissed){
          controller.forward() ;
        }
      }
      await Future.delayed(Duration.zero);
      final frame = await _captureScreen();
      frames.add(frame);
      exportProgressValue.value += (1.98/100).toDouble();
    }

    final List<Uint8List> reverseFrames = [];
    reverseFrames.addAll(List.of(frames).reversed);
    frames.addAll(reverseFrames);
    return frames;

  }

  Future<Uint8List> _captureScreen()async{
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



  Future<List<Uint8List>> exportGifs()async{
    hasAnimListener = false ;
    final originalLightGif = await _createAnimatedGif();
    dynamic jsOptimizedLightGif = await jsUtil.promiseToFuture(optimizeGifAndReturn(html.Blob([originalLightGif])));
    final html.FileReader reader = html.FileReader();
    reader.readAsArrayBuffer(jsOptimizedLightGif[0]);
    await reader.onLoad.first;
    final Uint8List optimizedLightGif = Uint8List.fromList(reader.result as List<int>);
    exportProgressValue.value = (50/100).toDouble();
    isLight.value = !isLight.value;
    GithubGridThemes.isLight.value = !GithubGridThemes.isLight.value;
    await Future.delayed(const Duration(milliseconds: 700));
    final originalDarkGif= await _createAnimatedGif();
    dynamic jsOptimizedDarkGif = await jsUtil.promiseToFuture(optimizeGifAndReturn(html.Blob([originalDarkGif])));
    final html.FileReader reader2 = html.FileReader();
    reader2.readAsArrayBuffer(jsOptimizedDarkGif[0]);
    await reader2.onLoad.first;
    final Uint8List optimizedDarkGif = Uint8List.fromList(reader2.result as List<int>);
    exportProgressValue.value = (100/100).toDouble();
    isLight.value = !isLight.value;
    GithubGridThemes.isLight.value = !GithubGridThemes.isLight.value;
    hasAnimListener = true;
    for(final gridAnimController in gridsAnimControllers){
      Future.delayed(Duration(milliseconds: _utils.generateRandomNumFromRange(50, 500)),(){
        gridAnimController!.forward();
      });
    }
    return List.of([originalLightGif,optimizedLightGif,originalDarkGif,optimizedDarkGif]);
  }


  void downloadGif(Uint8List gif,{String typeName='',required String themeName})async{

    js.context.callMethod('webSaveAs', [
      html.Blob([gif]),
      '${typeName}github_meme_$themeName.gif'
    ]);

  }




}