import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'dart:typed_data';
import 'dart:js' as js;
import 'dart:html' as htmlz;

GlobalKey githubMemeBoundryGlobalKey = GlobalKey();

class GithubMemeController extends GetxController{

  List<AnimationController?> gridsAnimControllers = [];

  bool hasAnimListener = true;

  var animVal = 0.0;

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


    // Create animated GIF using JavaScript
    createAnimatedGif(frames);

    print('Animated GIF created successfully!');


    //createGifJSInterop(frames);

    //var gif = await createTransparentGifUI(frames);
    // showDialog(
    //   context: Get.context!,
    //   builder: (context) {
    //     return AlertDialog(
    //       content: SizedBox(
    //         height: 800,
    //         width: 1500,
    //         child: Container(
    //           color: Colors.transparent,
    //           height: 350,
    //           child: Image.memory(
    //               gif
    //             //image.buffer.asUint8List(),
    //           ),
    //         ),
    //       ),
    //     );
    //   },
    // );





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







  void createGifJSInterop(List<Uint8List> frames){
    // Convert Uint8List frames to base64 strings
    final List<String> base64Frames = frames.map((frame) => base64Encode(frame)).toList();
    js.context.callMethod('createAnimatedGif', [base64Frames]);

  }

  void createAnimatedGif(List<Uint8List> pngFrames) {
    final js.JsObject gifEncoder = js.context.callMethod('createGifEncoder',[pngFrames[0]]);

    print('----gif.js instance--- $gifEncoder');

    for (Uint8List frame in pngFrames) {
      js.context.callMethod('addFrame', [gifEncoder, frame]);
    }

    final Uint8List gifBytes = js.context.callMethod('finishGif', [gifEncoder]);

    //print('-----jsRdata----$gifBytes');
    //saveAsGif(gifBytes);
  }

  void saveAsGif(Uint8List gifBytes) {
    final blob = htmlz.Blob([gifBytes]);
    final url = htmlz.Url.createObjectUrlFromBlob(blob);
    //final html.AnchorElement(href: url)..target = 'blank'..download = 'output.gif'..click();
    htmlz.Url.revokeObjectUrl(url);
  }

  Future<List<Uint8List>> loadPngFrames() async {
    // Replace this with your actual logic to load PNG frames
    List<Uint8List> frames = [];
    for (int i = 1; i <= 5; i++) {
      final htmlz.HttpRequest request = await htmlz.HttpRequest.request('assets/frame_$i.png', responseType: 'arraybuffer');
      frames.add(Uint8List.fromList(request.response as List<int>));
    }
    return frames;
  }




  void createAnimatedGifCallback(String base64String) {
    final gifBytes = Uint8List.fromList(base64.decode(base64String));
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
                  gifBytes
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
    final image = await  boundary.toImage();
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    if (byteData != null) {
      //print('Captured image size: ${byteData.lengthInBytes} bytes');
      return Uint8List.fromList(byteData.buffer.asUint8List());
    }
    else{
      throw Exception();
    }
  }

}