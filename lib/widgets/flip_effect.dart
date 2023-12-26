import 'dart:math';
import 'package:flutter/material.dart';


class FlipperView extends StatefulWidget {
  final Widget child;
  const FlipperView({super.key,required this.child});

  @override
  State<StatefulWidget> createState() {
    return _FlipperViewState();
  }
}

class _FlipperViewState extends State<FlipperView> with TickerProviderStateMixin {

  //flip
  late AnimationController flipController;
  late Animation flipAnim;

  @override
  void initState() {
    super.initState();


    flipController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    flipAnim = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: flipController, curve: const Interval(0.0, 1.0, curve: Curves.linear)));

    flipAnim.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(seconds: 1),(){
          flipController.reset();
          flipController.forward();
        });
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: flipController,
        builder: (BuildContext context, Widget? child) {
          flipController.forward();
          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(2 * pi * flipAnim.value),
            alignment: Alignment.center,
            child: widget.child,
          );
        }
    );
  }


  @override
  void dispose() {
    flipController.dispose();
    super.dispose();
  }

}




