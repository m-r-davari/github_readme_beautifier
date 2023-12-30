import 'package:ffmpeg_wasm/ffmpeg_wasm.dart';
import 'package:get/get.dart';
import 'package:github_readme_beautifier/utils/const_keeper.dart';

class AppBindings extends Bindings {

  @override
  Future<void> dependencies() async {
    Get.put<FFmpeg>(createFFmpeg(
      CreateFFmpegParam(
        log: true,
        corePath: "https://unpkg.com/@ffmpeg/core@0.11.0/dist/ffmpeg-core.js",

      ),
    )..load()..setLogger((logger) {
      if(logger.message=='ffmpeg-core loaded'){
        ConstKeeper.isFFmpegLoaded.value = true;
      }
    }), permanent: true,);

  }





}