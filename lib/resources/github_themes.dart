import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GithubThemes {

  static Rx<bool> isLight = true.obs;
  Color lightBgColor = const Color(0xffffffff);
  Color darkBgColor = const Color(0xff0d1117);
  Color lightBorderColor = const Color(0xffd0d7de);
  Color darkBorderColor = const Color(0xff30363d);
  Color lightTextColor = const Color(0xff1f2328);
  Color darkTextColor = const Color(0xffe6edf0);
  Color unCommitLightColor = const Color(0xffebedf0);
  Color unCommitDarkColor = const Color(0xff161b22);
  Color unCommitLightBorderColor = const Color(0xffdfe1e3);
  Color unCommitDarkBorderColor = const Color(0xff151a22);



  Map<int,Color> theme(String themeName){
    final themeMap = {
      0 : isLight.value ? unCommitLightColor : unCommitDarkColor,
    };
    themeMap.addAll(themesMap[themeName]!);
    return themeMap;
  }



  Map<String,Map<int,Color>> themesMap = {
    'Default' : {
      1 : const Color(0xff9be9a8),
      2 : const Color(0xff40c463),
      3 : const Color(0xff30a14e),
      4 : const Color(0xff216e39),
    }
    ,
    'Flutter' : {
      1 : const Color(0xff81ddf9),
      2 : const Color(0xff13b9fd),
      3 : const Color(0xff027dfd),
      4 : const Color(0xff0468d7),
    }
    ,
    'Halloween' : {
      1 : const Color(0xfffdf156),
      2 : const Color(0xffffc722),
      3 : const Color(0xffff9711),
      4 : const Color(0xff04001b),
    }
    ,
    'Barbie' : {
      1 : const Color(0xfffaafe1),
      2 : const Color(0xfffb6dcc),
      3 : const Color(0xfffa3fbc),
      4 : const Color(0xffff00ab),
    }
    ,
    'Moon' : {
      1 : const Color(0xff6bcdff),
      2 : const Color(0xff00a1f3),
      3 : const Color(0xff48009a),
      4 : const Color(0xff4f2266),
    }
    ,
    'Summer' : {
      1 : const Color(0xffeae374),
      2 : const Color(0xfff9d62e),
      3 : const Color(0xfffc913a),
      4 : const Color(0xffff4e50),
    }
    ,
    'Sunset' : {
      1 : const Color(0xfffed800),
      2 : const Color(0xffff6f01),
      3 : const Color(0xfffd2f24),
      4 : const Color(0xff811d5e),
    }
    ,
    'Amber' : {
      1 : const Color(0xffffecb3),
      2 : const Color(0xffffd54f),
      3 : const Color(0xffffb300),
      4 : const Color(0xffff6f00),
    }
    ,
    'Blue' : {
      1 : const Color(0xffbbdefb),
      2 : const Color(0xff64b5f6),
      3 : const Color(0xff1e88e5),
      4 : const Color(0xff0d47a1),
    }
    ,
    'BlueGrey' : {
      1 : const Color(0xffcfd8dc),
      2 : const Color(0xff90a4ae),
      3 : const Color(0xff546e7a),
      4 : const Color(0xff263238),
    }
    ,
    'Brown' : {
      1 : const Color(0xffd7ccc8),
      2 : const Color(0xffa1887f),
      3 : const Color(0xff6d4c41),
      4 : const Color(0xff3e2723),
    }
    ,
    'Cyan' : {
      1 : const Color(0xffb2ebf2),
      2 : const Color(0xff4dd0e1),
      3 : const Color(0xff00acc1),
      4 : const Color(0xff006064),
    }
    ,
    'DarkOrange' : {
      1 : const Color(0xffffccbc),
      2 : const Color(0xffff8a65),
      3 : const Color(0xfff4511e),
      4 : const Color(0xffbf360c),
    }
    ,
    'DarkPurple  ' : {
      1 : const Color(0xffd1c4e9),
      2 : const Color(0xff9575cd),
      3 : const Color(0xff5e35b1),
      4 : const Color(0xff311b92),
    }
    ,
    'Green' : {
      1 : const Color(0xffc8e6c9),
      2 : const Color(0xff81c784),
      3 : const Color(0xff43a047),
      4 : const Color(0xff1b5e20),
    }
    ,
    'Grey' : {
      1 : const Color(0xffe0e0e0),
      2 : const Color(0xff9e9e9e),
      3 : const Color(0xff616161),
      4 : const Color(0xff212121),
    }
    ,
    'Indigo' : {
      1 : const Color(0xffc5cae9),
      2 : const Color(0xff7986cb),
      3 : const Color(0xff3949ab),
      4 : const Color(0xff1a237e),
    }
    ,
    'LightBlue' : {
      1 : const Color(0xffb3e5fc),
      2 : const Color(0xff4fc3f7),
      3 : const Color(0xff039be5),
      4 : const Color(0xff01579b),
    }
    ,
    'LightGreen' : {
      1 : const Color(0xffdcedc8),
      2 : const Color(0xffaed581),
      3 : const Color(0xff7cb342),
      4 : const Color(0xff33691e),
    }
    ,
    'Lime' : {
      1 : const Color(0xfff0f4c3),
      2 : const Color(0xffdce775),
      3 : const Color(0xffc0ca33),
      4 : const Color(0xff827717),
    }
    ,
    'Orange' : {
      1 : const Color(0xffffe0b2),
      2 : const Color(0xffffb74d),
      3 : const Color(0xfffb8c00),
      4 : const Color(0xffe65100),
    }
    ,
    'Pink' : {
      1 : const Color(0xfff8bbd0),
      2 : const Color(0xfff06292),
      3 : const Color(0xffe91e63),
      4 : const Color(0xff880e4f),
    }
    ,
    'Purple' : {
      1 : const Color(0xffe1bee7),
      2 : const Color(0xffba68c8),
      3 : const Color(0xff8e24aa),
      4 : const Color(0xff4a148c),
    }
    ,
    'Red' : {
      1 : const Color(0xffffcdd2),
      2 : const Color(0xffe57373),
      3 : const Color(0xffe53935),
      4 : const Color(0xffb71c1c),
    }
    ,
    'Teal' : {
      1 : const Color(0xffb2dfdb),
      2 : const Color(0xff4db6ac),
      3 : const Color(0xff00897b),
      4 : const Color(0xff004d40),
    }
    ,
    'YellowMid' : {
      1 : const Color(0xfffff9c4),
      2 : const Color(0xfffff176),
      3 : const Color(0xffffd835),
      4 : const Color(0xfff57f17),
    }
    ,

    'Unicorn' : {
      1 : const Color(0xff6dc5fb),
      2 : const Color(0xfff6f68c),
      3 : const Color(0xff8affa4),
      4 : const Color(0xfff283d1),
    }
    ,
    'Yellow' : {
      1 : const Color(0xffd7d7a2),
      2 : const Color(0xffd4d462),
      3 : const Color(0xffe0e03f),
      4 : const Color(0xffffff00),
    }
    ,
  };


}