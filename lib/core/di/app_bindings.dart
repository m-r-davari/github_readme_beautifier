import 'package:ffmpeg_wasm/ffmpeg_wasm.dart';
import 'package:get/get.dart';
import 'package:github_readme_beautifier/core/network_manager/dio_network_manager_web.dart';
import 'package:github_readme_beautifier/core/network_manager/i_nework_manager.dart';
import 'package:github_readme_beautifier/presentation/exporter/exporter_controller.dart';
import 'package:github_readme_beautifier/core/downloader/downloader.dart';
import 'package:github_readme_beautifier/core/downloader/i_downloader.dart';
import 'package:github_readme_beautifier/core/gif_maker/gif_maker.dart';
import 'package:github_readme_beautifier/core/gif_maker/i_gif_maker.dart';
import 'package:github_readme_beautifier/core/gif_optimizer/gif_optimizer.dart';
import 'package:github_readme_beautifier/core/gif_optimizer/i_gif_optimizer.dart';
import 'package:github_readme_beautifier/core/screenshot_maker/i_screenshot_maker.dart';
import 'package:github_readme_beautifier/core/screenshot_maker/screenshot_maker.dart';
import 'package:github_readme_beautifier/data/git_repos/datasource/git_repos.dart';
import 'package:github_readme_beautifier/data/git_repos/datasource/i_git_repos.dart';
import 'package:github_readme_beautifier/presentation/user/user_controller.dart';
import 'package:github_readme_beautifier/utils/const_keeper.dart';

class AppBindings extends Bindings {

  @override
  Future<void> dependencies() async {
    Get.put<FFmpeg>(getFFmpeg(),permanent: true);
    Get.put<IGifMaker>(GifMaker(Get.find<FFmpeg>()),permanent: true);
    Get.put<IScreenshotMaker>(ScreenshotMaker(),permanent: true);
    Get.put<IGifOptimizer>(GifOptimizer(),permanent: true);
    Get.put<IDownloader>(Downloader());
    Get.put<ExporterController>(ExporterController(Get.find<IDownloader>()),permanent: true);
    Get.put<INetworkManager>(DioNetworkManager(baseUrl: ConstKeeper.baseUrl));
    Get.put<IGitReposRemoteDataSource>(GitReposRemoteDataSource(networkManager: Get.find<INetworkManager>()));

    Get.put(UserController(),permanent: true);

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