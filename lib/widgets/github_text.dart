import 'package:flutter/material.dart';
import 'package:github_readme_beautifier/resources/github_themes.dart';

class GithubText extends StatelessWidget {

  final String str;
  final double fontSize;
  final bool isLight;
  final isBold;

  const GithubText({super.key,required this.str,this.fontSize=14,required this.isLight,this.isBold=false});

  @override
  Widget build(BuildContext context) {

    final bgColor = isLight ? GithubThemes().lightBgColor : GithubThemes().darkBgColor;
    final txtColor = isLight ? GithubThemes().lightTextColor : GithubThemes().darkTextColor;

    //The gif images could not have semi-transparent color(transparent color with percent).
    //all of gif images pixel mus be either full transparent or colored pixel with full transparency
    //Due to anti aliasing in flutter Text(Widgets) the edge of Alphabets turns to colors with transparency to
    //have smoothest display and it cause the Gif not showing Text properly.
    //therefor we must have solid background for our text to show good in gifs
    //we have three options :
    //1 - give solid background color to whole widget, its good but it make problem in different readme bg colors.
    //since github user may use different dark/light theme and even every dark/light theme may have different
    // bg colors so we could not cover all these different bg colors, we only can determine dark or light theme.
    //
    //2 - give solid background colors to Texts , its better than solution 1 but it has still problem because the
    // space between chars will fill with solid colors and it may shown in different theme
    //
    //3 - use over lay texts in stack, it is better than previous solutions, the first Text widget in stack play
    //role as bg color and it only covers the Alphabets area, the first text color must be equals to theme color.
    //the second text will play the main text role and the color must be text color of the desire dark/ligh theme.
    //note : may be the first text that plays bg role for us must be bigger that our main text to ensure that all
    //the area of our main text covers with first bg text.

    return Stack(
      children: [
        Text(str,style: TextStyle(color: bgColor,fontSize: fontSize,fontWeight: isBold ? FontWeight.bold : FontWeight.w900,shadows: [
          Shadow(color: bgColor,blurRadius: 1,offset: const Offset(0,0))
        ]),)
        ,
        Text(str,style: TextStyle(color: bgColor,fontSize: fontSize,fontWeight: isBold ? FontWeight.bold : FontWeight.w900,),)
        ,
        Text(str,style: TextStyle(color: txtColor,fontSize: fontSize,fontWeight: isBold ? FontWeight.bold : null),)
      ],
    );
  }
}
