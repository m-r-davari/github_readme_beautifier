import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:github_readme_beautifier/typewriter_text/typewriter_rich_text.dart';


GlobalKey<TypewriterRichTextState> typewriterRichTextKey = GlobalKey();
GlobalKey typeWriterBoundryGlobalKey = GlobalKey();

class TypeWriterController extends GetxController {

  String documentJson = '{}';
  String documentPlainText = '';
  Rx<bool> isLight = true.obs;

  Future<void> export()async{
    List<Uint8List> lightTextFrames = [];
    double progress = 0;
    typewriterRichTextKey.currentState!.reset();
    await Future.delayed(const Duration(milliseconds: 200));
    while(progress*100 < 100){
      print('----capture frame --- $progress ---');
      final frame = await _captureScreen();
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
      final frame = await _captureScreen();
      darkTextFrames.add(frame);
      progress = typewriterRichTextKey.currentState!.nextFrame();
      await Future.delayed(Duration.zero);
    }
    print('----dark frame lenght is : ---- ${darkTextFrames.length} -----');


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
            child: ListView.separated(
                itemCount: lightTextFrames.length,
                itemBuilder: (ctx,index){
                  return Container(
                    color: Colors.white,
                    height: 100,
                    child: Row(
                      children: [
                        Image.memory(lightTextFrames[index],),Image.memory(darkTextFrames[index],)
                      ],
                    ),
                  );
                },
              separatorBuilder: (ctx,index){
                  return const Divider(height: 1,color: Colors.grey);
              },
            ),
          ),
        );
      },
    );

  }




  Future<Uint8List> _captureScreen()async{
    // Perform the screen capture and handle the image as needed
    // Example: Save the image to storage or display it in a dialog
    // Here, we just print the image size for demonstration purposes
    RenderRepaintBoundary boundary = typeWriterBoundryGlobalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await  boundary.toImage(pixelRatio: 1.0);//min 0.8 - def 1 - max 2
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    if (byteData != null) {
      //print('Captured image size: ${byteData.lengthInBytes} bytes');
      return Uint8List.fromList(byteData.buffer.asInt8List());
    }
    else{
      throw Exception();
    }
  }


}