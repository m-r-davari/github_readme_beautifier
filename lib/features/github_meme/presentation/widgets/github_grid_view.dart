import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:github_readme_beautifier/features/github_meme/presentation/widgets/github_meme_text.dart';
import 'package:github_readme_beautifier/resources/github_themes.dart';
import 'package:github_readme_beautifier/utils/utils.dart';
import '../controllers/github_meme_controller.dart';

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

  GithubThemes themes = GithubThemes();
  final memeController = Get.find<GithubMemeController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      //print('---- build grid view -----');
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: RepaintBoundary(
          key: githubMemeBoundryGlobalKey,
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(16),//color: memeController.isLight.value ? themes.lightBgColor : themes.darkBgColor,////
            decoration: widget.showBorder ? BoxDecoration(border: Border.all(color: memeController.isLight.value ? themes.lightBorderColor : themes.darkBorderColor,width: 1,),borderRadius: const BorderRadius.only(topLeft: Radius.circular(8),topRight: Radius.circular(8))) : const BoxDecoration(),
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
                      GithubMemeText(str :'Mon', isLight: memeController.isLight.value,fontSize: 13,),
                      GithubMemeText(str :'Wed', isLight: memeController.isLight.value,fontSize: 13,),
                      GithubMemeText(str :'Fri', isLight: memeController.isLight.value,fontSize: 13,),
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
                            GithubMemeText(str :'Dec', isLight: memeController.isLight.value,fontSize: 13,),
                            GithubMemeText(str :'Jan', isLight: memeController.isLight.value,fontSize: 13,),
                            GithubMemeText(str :'Feb', isLight: memeController.isLight.value,fontSize: 13,),
                            GithubMemeText(str :'Mar', isLight: memeController.isLight.value,fontSize: 13,),
                            GithubMemeText(str :'Apr', isLight: memeController.isLight.value,fontSize: 13,),
                            GithubMemeText(str :'May', isLight: memeController.isLight.value,fontSize: 13,),
                            GithubMemeText(str :'Jun', isLight: memeController.isLight.value,fontSize: 13,),
                            GithubMemeText(str :'Jul', isLight: memeController.isLight.value,fontSize: 13,),
                            GithubMemeText(str :'Aug', isLight: memeController.isLight.value,fontSize: 13,),
                            GithubMemeText(str :'Sep', isLight: memeController.isLight.value,fontSize: 13,),
                            GithubMemeText(str :'Oct', isLight: memeController.isLight.value,fontSize: 13,),
                            GithubMemeText(str :'Nov', isLight: memeController.isLight.value,fontSize: 13,),
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

                            Flexible(child: GithubMemeText(str: 'Github Readme Beautifier',isLight: memeController.isLight.value,)),
                            widget.showAuthor && widget.showProgressHint ? GithubMemeText(str: 'By \'m-r-davari\'',isLight: memeController.isLight.value,) : const SizedBox(width: 0,),
                            widget.showProgressHint ? Row(
                              children: [
                                GithubMemeText(str :'Less', isLight: memeController.isLight.value,),
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
                                GithubMemeText(str :'More', isLight: memeController.isLight.value,),
                              ],
                            ) : widget.showAuthor ? GithubMemeText(str :'By \'m-r-davari\'', isLight: memeController.isLight.value,) : const SizedBox(width: 0,),
                          ],
                        ),
                      )
                    ],
                  ),
                )

              ],
            ),
          ),
        ),
      );
    });
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
  late GithubThemes themes;
  double colorLerpPercent = 0.4;
  final controller = Get.find<GithubMemeController>();

  @override
  void initState() {
    _utils = Utils();
    themes = GithubThemes();
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
    //print('---- build grid item -----');
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
