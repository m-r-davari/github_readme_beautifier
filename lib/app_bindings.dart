import 'package:ffmpeg_wasm/ffmpeg_wasm.dart';
import 'package:get/get.dart';
import 'package:github_readme_beautifier/features/common/exporter/exporter_controller.dart';
import 'package:github_readme_beautifier/core/downloader/downloader.dart';
import 'package:github_readme_beautifier/core/downloader/i_downloader.dart';
import 'package:github_readme_beautifier/core/gif_maker/gif_maker.dart';
import 'package:github_readme_beautifier/core/gif_maker/i_gif_maker.dart';
import 'package:github_readme_beautifier/core/gif_optimizer/gif_optimizer.dart';
import 'package:github_readme_beautifier/core/gif_optimizer/i_gif_optimizer.dart';
import 'package:github_readme_beautifier/core/screenshot_maker/i_screenshot_maker.dart';
import 'package:github_readme_beautifier/core/screenshot_maker/screenshot_maker.dart';
import 'package:github_readme_beautifier/utils/const_keeper.dart';

class AppBindings extends Bindings {

  @override
  Future<void> dependencies() async {
    Get.put<FFmpeg>(getFFmpeg(),permanent: true);
    Get.put<IGifMaker>(GifMaker(Get.find<FFmpeg>()),permanent: true);
    Get.put<IScreenshotMaker>(ScreenshotMaker(),permanent: true);
    Get.put<IGifOptimizer>(GifOptimizer(),permanent: true);
    Get.put<IDownloader>(Downloader());
    Get.lazyPut(() => ExporterController(Get.find<IDownloader>()));
  }

  FFmpeg getFFmpeg (){
    return createFFmpeg(
      CreateFFmpegParam(
        log: true,
        corePath: "https://unpkg.com/@ffmpeg/core@0.11.0/dist/ffmpeg-core.js",
      ),
    )..load()..setLogger((logger) {
      if(logger.message=='ffmpeg-core loaded'){
        ConstKeeper.isFFmpegLoaded.value = true;
      }
    });
  }



}