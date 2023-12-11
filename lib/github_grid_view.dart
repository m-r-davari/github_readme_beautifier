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
  final bool isRecording;
  const GithubGridView({Key? key,required this.grids,required this.themeName, required this.showDate, required this.showAuthor, required this.showProgressHint, required this.showBorder, required this.isRecording}) : super(key: key);

  @override
  State<GithubGridView> createState() => GithubGridViewState();
}



class GithubGridViewState extends State<GithubGridView> {

  GithubGridThemes themes = GithubGridThemes();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: githubMemeBoundryGlobalKey,
      child: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: widget.showBorder ? BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.8),width: 0.5,),borderRadius: const BorderRadius.only(topLeft: Radius.circular(8),topRight: Radius.circular(8))) : const BoxDecoration(),
              child: Row(
                children: [
                  widget.showDate ? Container(
                    //color: Colors.red,
                    height: 95,
                    padding: const EdgeInsets.only(top: 0,bottom: 8),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Mon',style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500)),
                        Text('Wed',style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500)),
                        Text('Fri',style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500)),
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
                        widget.showDate ? const Padding(
                          padding: EdgeInsets.only(bottom: 2,left: 10,right: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text('Dec',style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500)),
                              Text('Jan',style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500)),
                              Text('Feb',style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500)),
                              Text('Mar',style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500)),
                              Text('Apr',style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500)),
                              Text('May',style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500)),
                              Text('Jun',style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500)),
                              Text('Jul',style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500)),
                              Text('Aug',style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500)),
                              Text('Sep',style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500)),
                              Text('Oct',style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500)),
                              Text('Nov',style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500)),
                              Text('',style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500)),
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
                              const Flexible(child: Text('Github Readme Beautifier',style: TextStyle(color: Colors.black54),)),
                              widget.showAuthor && widget.showProgressHint ? const Text('By \'m-r-davari\'',style: TextStyle(color: Colors.black54),) : const SizedBox(width: 0,),
                              widget.showProgressHint ? Row(
                                children: [
                                  const Text('Less',style: TextStyle(color: Colors.black54)),
                                  const SizedBox(width: 6,),
                                  Container(width: 14,height: 14,decoration: BoxDecoration(color: themes.themeMap[widget.themeName]?[0],borderRadius: BorderRadius.circular(2)),),
                                  const SizedBox(width: 5,),
                                  Container(width: 14,height: 14,decoration: BoxDecoration(color: themes.themeMap[widget.themeName]?[1],borderRadius: BorderRadius.circular(2)),),
                                  const SizedBox(width: 5,),
                                  Container(width: 14,height: 14,decoration: BoxDecoration(color: themes.themeMap[widget.themeName]?[2],borderRadius: BorderRadius.circular(2)),),
                                  const SizedBox(width: 5,),
                                  Container(width: 14,height: 14,decoration: BoxDecoration(color: themes.themeMap[widget.themeName]?[3],borderRadius: BorderRadius.circular(2)),),
                                  const SizedBox(width: 5,),
                                  Container(width: 14,height: 14,decoration: BoxDecoration(color: themes.themeMap[widget.themeName]?[4],borderRadius: BorderRadius.circular(2)),),
                                  const SizedBox(width: 6,),
                                  const Text('More',style: TextStyle(color: Colors.black54),)
                                ],
                              ) : widget.showAuthor ? const Text('By \'m-r-davari\'',style: TextStyle(color: Colors.black54),) : const SizedBox(width: 0,),
                            ],
                          ),
                        )
                      ],
                    ),
                  )

                ],
              ),
            )
            ,
          ],
        ),
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

  final controller = Get.find<GithubMemeController>();

  @override
  void initState() {
    _utils = Utils();
    themes = GithubGridThemes();
    colorNum = widget.initialColorNum;
    isSelected = widget.initialColorNum != 0;
    initialColor = themes.themeMap[widget.themeName]?[colorNum] ?? themes.unCommitColor ;
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
      initialColor = themes.unCommitColor;
      _colorTween = ColorTween(begin: initialColor, end: initialColor.withOpacity(0.6)).animate(_animationController);
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
      initialColor = themes.themeMap[widget.themeName]?[colorNum] ?? themes.unCommitColor;
      _colorTween = ColorTween(begin: initialColor, end: initialColor.withOpacity(0.6)).animate(_animationController);
      Future.delayed(Duration(milliseconds: _utils.generateRandomNumFromRange(100, 500)),(){
        _animationController.forward();
      });
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
            color: _colorTween.value,
            borderRadius: BorderRadius.circular(6),
            child: InkWell(
              onTap: (){
                setState(() {
                  isSelected = !isSelected;
                  if(isSelected){
                    initialColor = generateRandomColor();
                    _colorTween = ColorTween(begin: initialColor, end: initialColor.withOpacity(0.6)).animate(_animationController);
                    _animationController.forward();
                    widget.onClick(colorNum);
                    controller.gridsAnimControllers.add(_animationController);
                  }
                  else{
                    initialColor = themes.unCommitColor;
                    _colorTween = ColorTween(begin: initialColor, end: initialColor.withOpacity(0.6)).animate(_animationController);
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
                decoration: BoxDecoration(border: Border.all(color: const Color(0xffdfe1e3),width: 1),borderRadius: const BorderRadius.all(Radius.circular(6))),
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
    return themes.themeMap[widget.themeName]?[colorNum] ?? themes.unCommitColor;
  }








}
