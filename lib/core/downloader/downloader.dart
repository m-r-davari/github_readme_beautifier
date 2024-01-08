import 'dart:js' as js;
import 'dart:typed_data';
import 'dart:html' as html;
import 'package:github_readme_beautifier/core/downloader/i_downloader.dart';

class Downloader extends IDownloader {

  @override
  void download({required Uint8List gif,required String typeName, required String fileName,required String themeName})async{

    js.context.callMethod('webSaveAs', [
      html.Blob([gif]),
      '${typeName}_${fileName}_$themeName.gif'
    ]);

  }

}