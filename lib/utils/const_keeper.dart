import 'package:get/get.dart';

class ConstKeeper{

  static RxBool isFFmpegLoaded = RxBool(false);
  static String baseUrl = 'https://api.github.com/';
  static bool isWeb = GetPlatform.isWeb;
  static bool isDesktop = GetPlatform.isDesktop;

}