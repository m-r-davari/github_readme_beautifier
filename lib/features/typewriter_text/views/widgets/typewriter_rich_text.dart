import 'dart:async';

import 'package:flutter/material.dart';

class TypewriterRichText extends StatefulWidget {
  const TypewriterRichText({
    Key? key,
    required this.text,
    required this.textBg,
    required this.duration,
    this.onType,
    this.strutStyle,
    this.textDirection,
    this.locale,
    this.textAlign = TextAlign.start,
    this.softWrap = true,
    this.overflow = TextOverflow.clip,
    this.textScaleFactor = 1.0,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis = TextWidthBasis.parent,
    this.textHeightBehavior,
  }) : super(key: key);

  final TextSpan text;
  final TextSpan textBg;

  /// Every character type callback.
  final Function(double progress)? onType;

  /// Total typing duration.
  ///
  /// Depending on the length of the `text`, the `duration` argument will be divided
  /// to calculate each character's unit time. If you use Duration.zero it will be
  /// 1 microseconds per character.
  final Duration duration;

  final StrutStyle? strutStyle;
  final TextAlign textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool softWrap;
  final TextOverflow overflow;
  final double textScaleFactor;
  final int? maxLines;
  final String? semanticsLabel;
  final TextWidthBasis textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;

  @override
  TypewriterRichTextState createState() => TypewriterRichTextState();
}

class TypewriterRichTextState extends State<TypewriterRichText> {
  String typedText = "";

  Timer? timer;

  final currentSpans = <InlineSpan>[];
  final currentSpansBg = <InlineSpan>[];

  late String targetText;

  int currentLetterIdx = 0;
  int currentSpanIdx = -1;

  @override
  void initState() {
    refreshTargetText();
    restartTimer();
    super.initState();
  }

  void refreshTargetText() {
    targetText = currentSpanIdx == -1
        ? (widget.text.text ?? "")
        : (widget.text.children?[currentSpanIdx].toPlainText() ?? "");
  }

  int getMaxLen() {
    return (widget.text.text ?? "").codeUnits.length +
        (widget.text.children ?? []).fold<int>(
            0, (previousValue, e) => previousValue + e.toPlainText().length) +
        1;
  }

  int remainingLen() {
    return (widget.text.children ?? [])
        .skip(currentSpanIdx < 0 ? 0 : currentSpanIdx)
        .fold<int>(
      0,
          (previousValue, e) => previousValue + e.toPlainText().length,
    ) +
        (currentSpanIdx < 0
            ? (widget.text.text ?? "").length - currentLetterIdx
            : -currentLetterIdx);
  }

  void restartTimer() {
    timer?.cancel();
    final ml = getMaxLen();

    timer = Timer.periodic(
      Duration(
        microseconds: widget.duration.inMicroseconds ~/ ml,
      ),
          (timer) {
        final typeTextLength = typedText.codeUnits.length;
        final targetTextLength = targetText.codeUnits.length;
        final remaining = remainingLen();
        if (remaining == 0) {
          timer.cancel();
          widget.onType?.call(1.0);
          return;
        } else if (typeTextLength == targetTextLength ||
            currentLetterIdx >= targetTextLength) {
          currentSpanIdx++;

          if (currentSpanIdx >= (widget.text.children ?? []).length) {
            timer.cancel();
            widget.onType?.call(1.0);
            return;
          }
          currentLetterIdx = 0;
          typedText = "";

          currentSpans.add(TextSpan(
            text: "",
            style: widget.text.children![currentSpanIdx].style,
          ));
          currentSpansBg.add(TextSpan(
            text: "",
            style: widget.textBg.children![currentSpanIdx].style,
          ));

          targetText = widget.text.children![currentSpanIdx].toPlainText();
        }

        widget.onType?.call((ml - remaining) / ml);

        setState(() {
          typedText +=
              String.fromCharCode(targetText.codeUnitAt(currentLetterIdx));

          if (currentSpanIdx != -1) {
            currentSpans[currentSpanIdx] = TextSpan(
              text: typedText,
              style: widget.text.children![currentSpanIdx].style,
            );
            currentSpansBg[currentSpanIdx] = TextSpan(
              text: typedText,
              style: widget.textBg.children![currentSpanIdx].style,
            );
          }

          currentLetterIdx++;
        });
      },
    );
  }

  @override
  void didUpdateWidget(TypewriterRichText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (false) {//oldWidget.duration != widget.duration || oldWidget.text != widget.text
      currentLetterIdx = 0;
      currentSpanIdx = -1;
      currentSpans.clear();
      currentSpansBg.clear();
      refreshTargetText();
      typedText = "";
      setState(() {});
      restartTimer();
    }
  }

  void reset(){
    currentLetterIdx = 0;
    currentSpanIdx = -1;
    currentSpans.clear();
    currentSpansBg.clear();
    refreshTargetText();
    typedText = "";
    setState(() {});
  }


  void replay(){
    currentLetterIdx = 0;
    currentSpanIdx = -1;
    currentSpans.clear();
    currentSpansBg.clear();
    refreshTargetText();
    typedText = "";
    setState(() {});
    restartTimer();
  }


  double nextFrame(){
    final ml = getMaxLen();
    final typeTextLength = typedText.codeUnits.length;
    final targetTextLength = targetText.codeUnits.length;
    final remaining = remainingLen();
    if (remaining == 0) {
      return 1.0;
    } else if (typeTextLength == targetTextLength ||
        currentLetterIdx >= targetTextLength) {
      currentSpanIdx++;

      if (currentSpanIdx >= (widget.text.children ?? []).length) {
        return 1.0;
      }
      currentLetterIdx = 0;
      typedText = "";

      currentSpans.add(TextSpan(
        text: "",
        style: widget.text.children![currentSpanIdx].style,
      ));
      currentSpansBg.add(TextSpan(
        text: "",
        style: widget.textBg.children![currentSpanIdx].style,
      ));

      targetText = widget.text.children![currentSpanIdx].toPlainText();
    }

    setState(() {
      typedText += String.fromCharCode(targetText.codeUnitAt(currentLetterIdx));
      if (currentSpanIdx != -1) {
        currentSpans[currentSpanIdx] = TextSpan(
          text: typedText,
          style: widget.text.children![currentSpanIdx].style,
        );
        currentSpansBg[currentSpanIdx] = TextSpan(
          text: typedText,
          style: widget.textBg.children![currentSpanIdx].style,
        );
      }
      currentLetterIdx++;
    });

    return ((ml - remaining) / ml);
  }


  void lastFrame() {
    timer?.cancel();
    final ml = getMaxLen();

    timer = Timer.periodic(
      const Duration(
        microseconds: 0,//widget.duration.inMicroseconds ~/ ml,
      ),
          (timer) {
        final typeTextLength = typedText.codeUnits.length;
        final targetTextLength = targetText.codeUnits.length;
        final remaining = remainingLen();
        if (remaining == 0) {
          timer.cancel();
          widget.onType?.call(1.0);
          return;
        } else if (typeTextLength == targetTextLength ||
            currentLetterIdx >= targetTextLength) {
          currentSpanIdx++;

          if (currentSpanIdx >= (widget.text.children ?? []).length) {
            timer.cancel();
            widget.onType?.call(1.0);
            return;
          }
          currentLetterIdx = 0;
          typedText = "";

          currentSpans.add(TextSpan(
            text: "",
            style: widget.text.children![currentSpanIdx].style,
          ));
          currentSpansBg.add(TextSpan(
            text: "",
            style: widget.textBg.children![currentSpanIdx].style,
          ));

          targetText = widget.text.children![currentSpanIdx].toPlainText();
        }

        widget.onType?.call((ml - remaining) / ml);

        setState(() {
          typedText +=
              String.fromCharCode(targetText.codeUnitAt(currentLetterIdx));

          if (currentSpanIdx != -1) {
            currentSpans[currentSpanIdx] = TextSpan(
              text: typedText,
              style: widget.text.children![currentSpanIdx].style,
            );
            currentSpansBg[currentSpanIdx] = TextSpan(
              text: typedText,
              style: widget.textBg.children![currentSpanIdx].style,
            );
          }

          currentLetterIdx++;
        });
      },
    );
  }


  TextSpan getCurrentSpan() {
    return TextSpan(
      text: currentSpanIdx == -1 ? typedText : widget.text.text,
      style: widget.text.style,
      children: currentSpans,
    );
  }

  TextSpan getCurrentSpanBg() {
    return TextSpan(
      text: currentSpanIdx == -1 ? typedText : widget.textBg.text,
      style: widget.textBg.style,
      children: currentSpansBg,
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RichText(
          key: ValueKey("rtt_bg_${currentSpansBg.length}_$typedText"),
          text: getCurrentSpanBg(),
          strutStyle: widget.strutStyle,
          textAlign: widget.textAlign,
          textDirection: widget.textDirection,
          locale: widget.locale,
          softWrap: widget.softWrap,
          overflow: widget.overflow,
          textScaleFactor: widget.textScaleFactor,
          maxLines: widget.maxLines,
          textWidthBasis: widget.textWidthBasis,
          textHeightBehavior: widget.textHeightBehavior,
        )
        ,
        RichText(
          key: ValueKey("rtt_bg2_${currentSpansBg.length}_$typedText"),
          text: getCurrentSpanBg(),
          strutStyle: widget.strutStyle,
          textAlign: widget.textAlign,
          textDirection: widget.textDirection,
          locale: widget.locale,
          softWrap: widget.softWrap,
          overflow: widget.overflow,
          textScaleFactor: widget.textScaleFactor,
          maxLines: widget.maxLines,
          textWidthBasis: widget.textWidthBasis,
          textHeightBehavior: widget.textHeightBehavior,
        )
        ,
        RichText(
          key: ValueKey("rtt_${currentSpans.length}_$typedText"),
          text: getCurrentSpan(),
          strutStyle: widget.strutStyle,
          textAlign: widget.textAlign,
          textDirection: widget.textDirection,
          locale: widget.locale,
          softWrap: widget.softWrap,
          overflow: widget.overflow,
          textScaleFactor: widget.textScaleFactor,
          maxLines: widget.maxLines,
          textWidthBasis: widget.textWidthBasis,
          textHeightBehavior: widget.textHeightBehavior,
        )
      ],
    );
  }
}