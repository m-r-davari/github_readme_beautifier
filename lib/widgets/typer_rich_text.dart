import 'dart:async';

import 'package:flutter/material.dart';

class TypeRichText extends StatefulWidget {
  const TypeRichText({
    Key? key,
    required this.text,
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
  TypeRichTextState createState() => TypeRichTextState();
}

class TypeRichTextState extends State<TypeRichText> {
  String typedText = "";

  Timer? timer;

  final currentSpans = <InlineSpan>[];

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
          }

          currentLetterIdx++;
        });
      },
    );
  }

  @override
  void didUpdateWidget(TypeRichText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration ||
        oldWidget.text != widget.text) {
      currentLetterIdx = 0;
      currentSpanIdx = -1;
      currentSpans.clear();
      refreshTargetText();
      typedText = "";
      setState(() {});
      restartTimer();
    }
  }

  TextSpan getCurrentSpan() {
    return TextSpan(
      text: currentSpanIdx == -1 ? typedText : widget.text.text,
      style: widget.text.style,
      children: currentSpans,
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
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
    );
  }
}