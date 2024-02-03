import 'package:get/get.dart';

class ConstKeeper{

  static RxBool isFFmpegLoaded = RxBool(false);
  static String baseUrl = 'https://api.github.com/';

  static bool isTablet = Get.context!.isTablet;
  static bool isPhone = Get.context!.isPhone;
  static bool isAndroid = GetPlatform.isAndroid;
  static bool isIos = GetPlatform.isIOS;
  static bool isMacOs = GetPlatform.isMacOS;
  static bool isWindows = GetPlatform.isWindows;
  static bool isLinux = GetPlatform.isLinux;
  static bool isFuchsia = GetPlatform.isFuchsia;
  static bool isMobile = GetPlatform.isMobile;
  static bool isWeb = GetPlatform.isWeb;
  static bool isDesktop = GetPlatform.isDesktop;
  static bool isLandScape = Get.context!.isLandscape;
  static bool isPortrait = Get.context!.isPortrait;


}