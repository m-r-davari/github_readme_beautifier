import 'dart:async';

import 'package:flutter/material.dart';

class TypeText extends StatefulWidget {
  const TypeText(
      this.text, {
        Key? key,
        required this.duration,
        this.onType,
        this.style,
        this.strutStyle,
        this.textAlign,
        this.textDirection,
        this.locale,
        this.softWrap,
        this.overflow,
        this.textScaleFactor,
        this.maxLines,
        this.semanticsLabel,
        this.textWidthBasis,
        this.textHeightBehavior,
      }) : super(key: key);

  final String text;

  /// Every character type callback.
  final Function(double progress)? onType;

  /// Total typing duration.
  ///
  /// Depending on the length of the `text`, the `duration` argument will be divided
  /// to calculate each character's unit time. If you use Duration.zero it will be
  /// 1 microseconds per character.
  final Duration duration;

  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final double? textScaleFactor;
  final int? maxLines;
  final String? semanticsLabel;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;

  @override
  TypeTextState createState() => TypeTextState();
}

class TypeTextState extends State<TypeText> {
  String typedText = "";
  Timer? timer;
  int currentIdx = 0;

  @override
  void initState() {
    restartTimer();
    super.initState();
  }

  void restartTimer() {
    timer?.cancel();
    timer = Timer.periodic(
      Duration(
        microseconds:
        widget.duration.inMicroseconds ~/ widget.text.codeUnits.length + 1,
      ),
          (timer) {
        final typeTextLength = typedText.codeUnits.length;
        final widgetTextLength = widget.text.codeUnits.length;
        if (typeTextLength == widgetTextLength ||
            currentIdx >= widgetTextLength) {
          timer.cancel();
          widget.onType?.call(1.0);
          return;
        }
        widget.onType?.call(typeTextLength / widgetTextLength);
        setState(() {
          typedText += String.fromCharCode(widget.text.codeUnitAt(currentIdx));
          currentIdx++;
        });
      },
    );
  }

  @override
  void didUpdateWidget(TypeText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration ||
        oldWidget.text != widget.text) {
      currentIdx = 0;
      typedText = "";
      setState(() {});
      restartTimer();
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      typedText,
      style: widget.style,
      strutStyle: widget.strutStyle,
      textAlign: widget.textAlign,
      textDirection: widget.textDirection,
      locale: widget.locale,
      softWrap: widget.softWrap,
      overflow: widget.overflow,
      textScaleFactor: widget.textScaleFactor,
      maxLines: widget.maxLines,
      semanticsLabel: widget.semanticsLabel,
      textWidthBasis: widget.textWidthBasis,
      textHeightBehavior: widget.textHeightBehavior,
    );
  }
}