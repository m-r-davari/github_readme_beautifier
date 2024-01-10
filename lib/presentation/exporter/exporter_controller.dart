import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:github_readme_beautifier/core/downloader/i_downloader.dart';
import 'package:github_readme_beautifier/utils/const_keeper.dart';

class ExporterController extends GetxController {

  final IDownloader downloader;
  ExporterController(this.downloader);

  RxString fileName = ''.obs;
  RxBool isFFmpegLoaded = ConstKeeper.isFFmpegLoaded;
  RxDouble progress = 0.0.obs;
  RxList<Uint8List> gifs = <Uint8List>[].obs;



  void downloadGif({required Uint8List gif,required String typeName,required String fileName,required String themeName}){
    downloader.download(gif: gif, typeName: typeName, fileName: fileName, themeName: themeName);
  }


}