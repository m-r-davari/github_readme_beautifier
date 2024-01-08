import 'dart:typed_data';
import 'package:flutter/material.dart';

abstract class IScreenshotMaker  {

  Future<Uint8List> captureScreen({required GlobalKey key});

}