import 'dart:js' as js;
import 'dart:typed_data';
import 'dart:html' as html;

abstract class IDownloader {

  void download({required Uint8List gif,required String typeName, required String fileName,required String themeName});

}