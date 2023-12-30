import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:github_readme_beautifier/typewriter_text/span_model.dart';
import 'package:github_readme_beautifier/widgets/type_rich_text.dart';

class TypewriterExportPage extends StatefulWidget {
  final String jsonTxt;
  const TypewriterExportPage({Key? key,required this.jsonTxt}) : super(key: key);

  @override
  State<TypewriterExportPage> createState() => _TypewriterExportPageState();
}

class _TypewriterExportPageState extends State<TypewriterExportPage> {
  List<TextSpan> textSpans = [];

  @override
  void initState() {
    final json = jsonDecode(widget.jsonTxt);
    final spansList = SpanModel.fromDynamicListJson(json).spans;
    for(final spanModel in spansList!){
      print('----object---- ${spanModel.insert}');
      TextSpan textSpan = TextSpan(
          text: spanModel.insert ?? '',
          style: TextStyle(fontWeight: FontWeight.normal)//spanModel.attributes?.bold == null ? FontWeight.normal : spanModel.attributes.bold ? FontWeight.bold : FontWeight.normal
      );
      textSpans.add(textSpan);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 700),
      child: TypeRichText(
        text: TextSpan(
          text: 'Hello ',
          style: const TextStyle(
            color: Colors.black,
          ),
          children: textSpans,
        ),
        duration: const Duration(seconds: 1),
        onType: (progress) {
          debugPrint("Rich text %${(progress * 100).toStringAsFixed(0)} completed.");
        },
      )
    );
  }
}
