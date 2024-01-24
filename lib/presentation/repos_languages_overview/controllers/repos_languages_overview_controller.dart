import 'package:get/get.dart';
import 'package:github_readme_beautifier/core/exceptions/exceptions.dart';
import 'package:github_readme_beautifier/core/gif_maker/i_gif_maker.dart';
import 'package:github_readme_beautifier/core/gif_optimizer/i_gif_optimizer.dart';
import 'package:github_readme_beautifier/core/screenshot_maker/i_screenshot_maker.dart';
import 'package:github_readme_beautifier/core/states/states.dart';
import 'package:github_readme_beautifier/data/repos_languages_overview/repository/i_repos_languages_overview_repository.dart';
import 'package:github_readme_beautifier/presentation/exporter/exporter_controller.dart';

class ReposLanguagesOverviewController extends GetxController {
  final repository = Get.find<IReposLanguagesOverviewRepository>();
  Rx<UIState> state = Rx<UIState>(LoadingState());
  Rx<bool> isLight = true.obs;
  IGifMaker gifMaker = Get.find<IGifMaker>();
  IScreenshotMaker screenShotMaker = Get.find();
  IGifOptimizer gifOptimizer = Get.find();
  ExporterController exporterController = Get.find();
  RxInt touchedIndex = (-1).obs;


  Future<void> getReposLanguagesOverview(String userName) async {
    try {
      final result = await repository.getReposLanguagesOverview(userName: userName);
      print('---- sssss ---- $result');
      state.value = SuccessState<Map<String, int>>(result);
    } on NetworkException catch (e) {
      state.value = FailureState(error: e.message);
    } catch (e) {
      state.value = FailureState(error: e.toString());
    }
  }



}
