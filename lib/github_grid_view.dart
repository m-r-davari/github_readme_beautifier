import 'dart:html';

import 'package:flutter/material.dart';
import 'package:github_readme_beautifier/resources/github_grid_themes.dart';
import 'package:github_readme_beautifier/utils/utils.dart';

class GithubGridView extends StatefulWidget {
  const GithubGridView({Key? key}) : super(key: key);

  @override
  State<GithubGridView> createState() => _GithubGridViewState();
}



class _GithubGridViewState extends State<GithubGridView> {

  List<int> grids = List.filled(368, 0);
  String themeName = 'Default';
  GithubGridThemes themes = GithubGridThemes();
  bool showBorder = true;
  bool showAuthor = true;
  bool showProgressHint = true;
  bool showDate = true;

  @override
  Widget build(BuildContext context) {
    //print('---------p---------');
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: showBorder ? BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.8),width: 0.5,),borderRadius: const BorderRadius.only(topLeft: Radius.circular(8),topRight: Radius.circular(8))) : const BoxDecoration(),
          child: Row(
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              showDate ? Container(
                color: Colors.red,
                padding: const EdgeInsets.only(top: 5,bottom: 6),
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
                    showDate ? const Padding(
                      padding: EdgeInsets.only(bottom: 2,left: 10,right: 88),
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
                            itemCount: grids.length,//371
                            shrinkWrap: true,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 7,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5,
                            ),
                            itemBuilder: (ctx, index) {
                              return GithubGridItem(
                                index: index,
                                themeName: themeName,
                                initialColorNum: grids[index],
                                onClick: (int colorNum){
                                  //print('----index : $index ---- colorNum : $colorNum');
                                  grids[index] = colorNum;
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
                          Flexible(child: Text('Github Readme Beautifier ${showAuthor ? '\'Author : M.R.Davari\'' : ''}',style: const TextStyle(color: Colors.black54),)),
                          showProgressHint ? Row(
                            children: [
                              const Text('Less',style: TextStyle(color: Colors.black54)),
                              const SizedBox(width: 6,),
                              Container(width: 14,height: 14,decoration: BoxDecoration(color: themes.themeMap[themeName]?[0],borderRadius: BorderRadius.circular(2)),),
                              const SizedBox(width: 5,),
                              Container(width: 14,height: 14,decoration: BoxDecoration(color: themes.themeMap[themeName]?[1],borderRadius: BorderRadius.circular(2)),),
                              const SizedBox(width: 5,),
                              Container(width: 14,height: 14,decoration: BoxDecoration(color: themes.themeMap[themeName]?[2],borderRadius: BorderRadius.circular(2)),),
                              const SizedBox(width: 5,),
                              Container(width: 14,height: 14,decoration: BoxDecoration(color: themes.themeMap[themeName]?[3],borderRadius: BorderRadius.circular(2)),),
                              const SizedBox(width: 5,),
                              Container(width: 14,height: 14,decoration: BoxDecoration(color: themes.themeMap[themeName]?[4],borderRadius: BorderRadius.circular(2)),),
                              const SizedBox(width: 6,),
                              const Text('More',style: TextStyle(color: Colors.black54),)
                            ],
                          ) : const SizedBox(width: 0,),
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
        const SizedBox(height: 16,)
        ,
        FittedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 24,)
              ,
              ElevatedButton(
                  onPressed: (){
                    grids.fillRange(0, grids.length,0);
                    //print('-------aftch---${grids[0]}---');
                    setState(() {
                      //List.filled(368, 0);
                    });
                  },
                  child: const Text('Reset')
              )
              ,
              const SizedBox(width: 24,)
              ,
              ElevatedButton(
                  onPressed: ()async{
                    var result = await showThemePickerDialog(themes.themeMap.keys.toList(),themeName);
                    if(result!=null){
                      themeName = result;
                      //print('--------tht-- $themeName -- $result -- ');
                      setState((){});
                    }
                  },
                  child: const Text('Choose Theme')
              )
              ,
              const SizedBox(width: 24,)
              ,
              ElevatedButton(
                  onPressed: (){
                    setState(() {
                      showBorder=!showBorder;
                    });
                  },
                  child: Text(showBorder ? 'Hide Border' : 'Show Border')
              )
              ,
              const SizedBox(width: 24,)
              ,
              ElevatedButton(
                  onPressed: (){
                    setState(() {
                      showAuthor=!showAuthor;
                    });
                  },
                  child: Text(showAuthor ? 'Hide Author' : 'Show Author')
              )
              ,
              const SizedBox(width: 24,)
              ,
              ElevatedButton(
                  onPressed: (){
                    setState(() {
                      showProgressHint=!showProgressHint;
                    });
                  },
                  child: Text(showProgressHint ? 'Hide Progress Hint' : 'Show Progress Hint')
              )
              ,
              const SizedBox(width: 24,)
              ,
              ElevatedButton(
                  onPressed: (){
                    setState(() {
                      showDate=!showDate;
                    });
                  },
                  child: Text(showDate ? 'Hide Date' : 'Show Date')
              )
              ,
              const SizedBox(width: 24,)
            ],
          ),
        )
      ],
    );
  }

  Future<String?> showThemePickerDialog(List<String> themes,[String? chosenTheme])async{
    return await showModalBottomSheet<String>(context: context, builder: (ctx){
      return SizedBox(
        height: 250,
        child: ListView.separated(
          itemCount: themes.length,
          padding: const EdgeInsets.only(top: 16),
          itemBuilder: (ctx,index){
            return InkWell(
              onTap: (){
                Navigator.pop(context,themes[index]);
              },
              child: Container(
                height: 50,
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${index+1}'),
                    Text(themes[index]),
                    Icon(chosenTheme == themes[index] ? Icons.check_box : Icons.check_box_outline_blank)
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (ctx,index){
            return const Divider(color: Colors.grey,thickness: 0.6,indent: 10,endIndent: 10,);
          },
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

class _GithubGridItemState extends State<GithubGridItem> with TickerProviderStateMixin {


  bool isSelected = false;
  int colorNum = 0;
  late AnimationController _animationController;
  late Animation _colorTween;
  late Utils _utils;
  late Color initialColor;
  late GithubGridThemes themes;

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
      //print('-------must reset----- index : ${widget.index}-----');
      colorNum = 0;
      isSelected = false;
      initialColor = themes.unCommitColor;
      _colorTween = ColorTween(begin: initialColor, end: initialColor.withOpacity(0.6)).animate(_animationController);
      _animationController.reset();
      _animationController.stop();
    }

    if(widget.themeName!=oldWidget.themeName){
      //print('---------must update--------');
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
    //print('-----grider-----');
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
                    initialColor = generateRandomColor('github');
                    _colorTween = ColorTween(begin: initialColor, end: initialColor.withOpacity(0.6)).animate(_animationController);
                    _animationController.forward();
                    widget.onClick(colorNum);
                  }
                  else{
                    initialColor = themes.unCommitColor;
                    _colorTween = ColorTween(begin: initialColor, end: initialColor.withOpacity(0.6)).animate(_animationController);
                    _animationController.reset();
                    _animationController.stop();
                    colorNum = 0;
                    widget.onClick(0);
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

  Color generateRandomColor(String theme){
    colorNum = _utils.generateRandomNumFromRange(1, 4);
    return themes.themeMap[widget.themeName]?[colorNum] ?? themes.unCommitColor;
  }








}
