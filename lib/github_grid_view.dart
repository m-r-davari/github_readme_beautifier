import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:github_readme_beautifier/resources/github_grid_themes.dart';
import 'package:github_readme_beautifier/utils/utils.dart';
import 'github_meme/github_meme_controller.dart';

class GithubGridView extends StatefulWidget {

  final List<int> grids;
  final String themeName;
  final bool showBorder;
  final bool showAuthor;
  final bool showProgressHint;
  final bool showDate;

  const GithubGridView({Key? key,required this.grids,required this.themeName, required this.showDate, required this.showAuthor, required this.showProgressHint, required this.showBorder}) : super(key: key);

  @override
  State<GithubGridView> createState() => GithubGridViewState();
}



class GithubGridViewState extends State<GithubGridView> {

  GithubGridThemes themes = GithubGridThemes();
  final memeController = Get.find<GithubMemeController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: githubMemeBoundryGlobalKey,
      child: Obx(
          ()=>Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),//color: memeController.isLight.value ? themes.lightBg : themes.darkBg,
            decoration: widget.showBorder ? BoxDecoration(border: Border.all(color: memeController.isLight.value ? themes.lightBorderColor : themes.darkBorderColor,width: 0.5,),borderRadius: const BorderRadius.only(topLeft: Radius.circular(8),topRight: Radius.circular(8))) : const BoxDecoration(),
            child: Row(
              children: [
                widget.showDate ? Container(
                  //color: Colors.red,
                  height: 95,
                  padding: const EdgeInsets.only(top: 0,bottom: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Mon',style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500, color: memeController.isLight.value ? themes.lightTextColor : themes.darkTextColor)),
                      Text('Wed',style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500, color: memeController.isLight.value ? themes.lightTextColor : themes.darkTextColor)),
                      Text('Fri',style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500, color: memeController.isLight.value ? themes.lightTextColor : themes.darkTextColor)),
                    ],
                  ),
                ) : const SizedBox(width: 0,)
                ,
                const SizedBox(width: 1,)
                ,
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      widget.showDate ? Padding(
                        padding: const EdgeInsets.only(bottom: 2,left: 10,right: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text('Dec',style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500, color: memeController.isLight.value ? themes.lightTextColor : themes.darkTextColor)),
                            Text('Jan',style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500, color: memeController.isLight.value ? themes.lightTextColor : themes.darkTextColor)),
                            Text('Feb',style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500, color: memeController.isLight.value ? themes.lightTextColor : themes.darkTextColor)),
                            Text('Mar',style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500, color: memeController.isLight.value ? themes.lightTextColor : themes.darkTextColor)),
                            Text('Apr',style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500, color: memeController.isLight.value ? themes.lightTextColor : themes.darkTextColor)),
                            Text('May',style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500, color: memeController.isLight.value ? themes.lightTextColor : themes.darkTextColor)),
                            Text('Jun',style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500, color: memeController.isLight.value ? themes.lightTextColor : themes.darkTextColor)),
                            Text('Jul',style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500, color: memeController.isLight.value ? themes.lightTextColor : themes.darkTextColor)),
                            Text('Aug',style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500, color: memeController.isLight.value ? themes.lightTextColor : themes.darkTextColor)),
                            Text('Sep',style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500, color: memeController.isLight.value ? themes.lightTextColor : themes.darkTextColor)),
                            Text('Oct',style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500, color: memeController.isLight.value ? themes.lightTextColor : themes.darkTextColor)),
                            Text('Nov',style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500, color: memeController.isLight.value ? themes.lightTextColor : themes.darkTextColor)),
                            const Text('',style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ) : Container()
                      ,
                      FittedBox(
                        child: SizedBox(
                          height: 350,
                          child: GridView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.only(left: 16,right: 4,top: 0,bottom: 24),
                              itemCount: widget.grids.length,//371
                              shrinkWrap: true,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 7,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 5,
                              ),
                              itemBuilder: (ctx, index) {
                                return GithubGridItem(
                                  key: Key('k$index'),
                                  index: index,
                                  themeName: widget.themeName,
                                  initialColorNum: widget.grids[index],
                                  onClick: (int colorNum){
                                    widget.grids[index] = colorNum;
                                    //print(grids);
                                  },
                                );
                              }),
                        ),
                      )
                      ,
                      Padding(
                        padding: const EdgeInsets.only(left: 5,right: 42),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [


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

                            Flexible(child: Stack(
                              children: [

                                Text('Github Readme Beautifier',style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w900,),)
                                ,
                                Text('Github Readme Beautifier',style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w900,),)
                                ,
                                Text('Github Readme Beautifier',style: TextStyle(color: memeController.isLight.value ? themes.lightTextColor : themes.darkTextColor,fontSize: 14),)
                              ],
                            )),
                            //Flexible(child: Text('Github Readme Beautifier',style: TextStyle(color: memeController.isLight.value ? themes.lightTextColor : themes.darkTextColor),)),
                            widget.showAuthor && widget.showProgressHint ? Text('By \'m-r-davari\'',style: TextStyle(color: memeController.isLight.value ? themes.lightTextColor : themes.darkTextColor)) : const SizedBox(width: 0,),
                            widget.showProgressHint ? Row(
                              children: [
                                Text('Less',style: TextStyle(color: memeController.isLight.value ? themes.lightTextColor : themes.darkTextColor)),
                                const SizedBox(width: 6,),
                                Container(width: 14,height: 14,decoration: BoxDecoration(color: themes.theme(widget.themeName)[0],borderRadius: BorderRadius.circular(2)),),
                                const SizedBox(width: 5,),
                                Container(width: 14,height: 14,decoration: BoxDecoration(color: themes.theme(widget.themeName)[1],borderRadius: BorderRadius.circular(2)),),
                                const SizedBox(width: 5,),
                                Container(width: 14,height: 14,decoration: BoxDecoration(color: themes.theme(widget.themeName)[2],borderRadius: BorderRadius.circular(2)),),
                                const SizedBox(width: 5,),
                                Container(width: 14,height: 14,decoration: BoxDecoration(color: themes.theme(widget.themeName)[3],borderRadius: BorderRadius.circular(2)),),
                                const SizedBox(width: 5,),
                                Container(width: 14,height: 14,decoration: BoxDecoration(color: themes.theme(widget.themeName)[4],borderRadius: BorderRadius.circular(2)),),
                                const SizedBox(width: 6,),
                                Text('More',style: TextStyle(color: memeController.isLight.value ? themes.lightTextColor : themes.darkTextColor),)
                              ],
                            ) : widget.showAuthor ? Text('By \'m-r-davari\'',style: TextStyle(color: memeController.isLight.value ? themes.lightTextColor : themes.darkTextColor)) : const SizedBox(width: 0,),
                          ],
                        ),
                      )
                    ],
                  ),
                )

              ],
            ),
          )
      ),
    );
  }

}


class GithubGridItem extends StatefulWidget {

  final int index;
  final String themeName;
  final int initialColorNum;
  final Function(int colorNum) onClick;
  const GithubGridItem({Key? key,required this.index,required this.themeName,required this.onClick,required this.initialColorNum}) : super(key: key);

  @override
  State<GithubGridItem> createState() => _GithubGridItemState();
}

class _GithubGridItemState extends State<GithubGridItem> with SingleTickerProviderStateMixin {

  bool isSelected = false;
  int colorNum = 0;
  late AnimationController _animationController;
  late Animation _colorTween;
  late Utils _utils;
  late Color initialColor;
  late GithubGridThemes themes;
  double colorLerpPercent = 0.4;
  final controller = Get.find<GithubMemeController>();

  @override
  void initState() {
    _utils = Utils();
    themes = GithubGridThemes();
    colorNum = widget.initialColorNum;
    isSelected = widget.initialColorNum != 0;
    initialColor = themes.theme(widget.themeName)[colorNum] ?? themes.theme(widget.themeName)[0]! ;
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _colorTween = ColorTween(begin: initialColor, end: initialColor).animate(_animationController);
    super.initState();

    _animationController.addStatusListener((status) {
      if(!controller.hasAnimListener){
        return;
      }
      if(status == AnimationStatus.completed){
        _animationController.reverse();
      }
      else if (status == AnimationStatus.dismissed){
        _animationController.forward();
      }
    });

  }



@override
  void didUpdateWidget(covariant GithubGridItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    if(widget.initialColorNum==0 && widget.initialColorNum!=colorNum){
      colorNum = 0;
      isSelected = false;
      initialColor = themes.theme(widget.themeName)[0]!;
      _colorTween = ColorTween(begin: initialColor, end: Color.lerp(initialColor, themes.theme(widget.themeName)[0]!, colorLerpPercent)).animate(_animationController);
      _animationController.reset();
      _animationController.stop();
      controller.gridsAnimControllers.clear();
    }

    if(widget.themeName!=oldWidget.themeName){
      if(widget.initialColorNum == 0){
        return;
      }
      colorNum = widget.initialColorNum;
      isSelected = widget.initialColorNum != 0;
      initialColor = themes.theme(widget.themeName)[colorNum] ?? themes.theme(widget.themeName)[0]!;
      _colorTween = ColorTween(begin: initialColor, end: Color.lerp(initialColor, themes.theme(widget.themeName)[0]!, colorLerpPercent)).animate(_animationController);
      Future.delayed(Duration(milliseconds: _utils.generateRandomNumFromRange(50, 500)),(){
        _animationController.forward();
      });
    }
    else{
      _colorTween = ColorTween(begin: initialColor, end: Color.lerp(initialColor, themes.theme(widget.themeName)[0]!, colorLerpPercent)).animate(_animationController);
    }

}



  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: AnimatedBuilder(
        animation: _colorTween,
        builder: (ctx,child){
          return Material(
            color: colorNum == 0 ? themes.theme(widget.themeName)[0] : _colorTween.value,
            borderRadius: BorderRadius.circular(6),
            child: InkWell(
              onTap: (){
                setState(() {
                  isSelected = !isSelected;
                  if(isSelected){
                    initialColor = generateRandomColor();
                    _colorTween = ColorTween(begin: initialColor, end: Color.lerp(initialColor, themes.theme(widget.themeName)[0]!, colorLerpPercent)).animate(_animationController);
                    _animationController.forward();
                    widget.onClick(colorNum);
                    controller.gridsAnimControllers.add(_animationController);
                  }
                  else{
                    initialColor = themes.theme(widget.themeName)[0]!;
                    _colorTween = ColorTween(begin: initialColor, end: Color.lerp(initialColor, themes.theme(widget.themeName)[0]!, colorLerpPercent)).animate(_animationController);
                    _animationController.reset();
                    _animationController.stop();
                    colorNum = 0;
                    widget.onClick(0);
                    controller.gridsAnimControllers.remove(_animationController);
                  }
                });

              },
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(border: Border.all(color: controller.isLight.value ? themes.unCommitLightBorderColor : themes.unCommitDarkBorderColor ,width: 1),borderRadius: const BorderRadius.all(Radius.circular(6))),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color generateRandomColor(){
    colorNum = _utils.generateRandomNumFromRange(1, 4);
    return themes.theme(widget.themeName)[colorNum] ?? themes.theme(widget.themeName)[0]!;
  }








}
