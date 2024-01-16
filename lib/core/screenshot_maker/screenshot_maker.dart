import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:github_readme_beautifier/core/screenshot_maker/i_screenshot_maker.dart';

class ScreenshotMaker extends IScreenshotMaker{

  @override
  Future<Uint8List> captureScreen({required GlobalKey key,double pixelRatio = 1.0}) async {
    // Perform the screen capture and handle the image as needed
    // Example: Save the image to storage or display it in a dialog
    // Here, we just print the image size for demonstration purposes
    RenderRepaintBoundary boundary = key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await  boundary.toImage(pixelRatio: pixelRatio);
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