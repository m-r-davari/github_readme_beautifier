import 'dart:math';

import 'package:flutter/material.dart';
import 'package:github_readme_beautifier/utils/utils.dart';

class GithubGridView extends StatefulWidget {
  const GithubGridView({Key? key}) : super(key: key);

  @override
  State<GithubGridView> createState() => _GithubGridViewState();
}



class _GithubGridViewState extends State<GithubGridView> {

  List<int> grids = List.filled(368, 0);//368

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          FittedBox(
            child: SizedBox(
              height: 350,
              child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(24),
                  itemCount: grids.length,//371
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                  ),
                  itemBuilder: (ctx, index) {
                    return const GithubGridItem();
                  }),
            ),
          ),
          const SizedBox(height: 16,),
          ElevatedButton(
              onPressed: (){},
              child: const Text('Play')
          )
        ],
      ),
    );
  }
}


class GithubGridItem extends StatefulWidget {
  const GithubGridItem({Key? key}) : super(key: key);

  @override
  State<GithubGridItem> createState() => _GithubGridItemState();
}

class _GithubGridItemState extends State<GithubGridItem> with SingleTickerProviderStateMixin {

  bool isSelected = false;
  late AnimationController _animationController;
  late Animation _colorTween;
  late Utils _utils;

  Color initialColor = const Color(0xffebedf0);

  @override
  void initState() {
    _utils = Utils();
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

  Map<int,Color> githubThemeColor = {
    0 : const Color(0xff9be9a8),
    1 : const Color(0xff40c463),
    2 : const Color(0xff30a14e),
    3 : const Color(0xff216e39),
  };

  Map<int,Color> flutterThemeColor = {
    0 : const Color(0xff81ddf9),
    1 : const Color(0xff13b9fd),
    2 : const Color(0xff027dfd),
    3 : const Color(0xff0468d7),
  };

  Color generateRandomColor(String theme){
    return flutterThemeColor[_utils.generateRandomNum()] ?? const Color(0xffebedf0);
  }


  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: AnimatedBuilder(
        animation: _colorTween,
        builder: (ctx,child){
          return Material(
            color: _colorTween.value,//isSelected ? Colors.green : const Color(0xffededf0),
            borderRadius: BorderRadius.circular(6),
            child: InkWell(
              onTap: (){
                setState(() {
                  isSelected = !isSelected;
                  if(isSelected){
                    initialColor = generateRandomColor('github');
                    _colorTween = ColorTween(begin: initialColor, end: initialColor.withOpacity(0.6)).animate(_animationController);
                    _animationController.forward();
                  }
                  else{
                    initialColor = const Color(0xffebedf0);
                    _colorTween = ColorTween(begin: initialColor, end: initialColor.withOpacity(0.6)).animate(_animationController);
                    _animationController.reset();
                    _animationController.stop();
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
}
