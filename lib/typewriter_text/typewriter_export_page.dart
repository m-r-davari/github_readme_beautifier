import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:github_readme_beautifier/resources/github_grid_themes.dart';
import 'package:github_readme_beautifier/typewriter_text/span_model.dart';
import 'package:github_readme_beautifier/typewriter_text/typewriter_controller.dart';
import 'package:github_readme_beautifier/utils/hex_color.dart';
import 'package:github_readme_beautifier/widgets/type_rich_text.dart';

class TypewriterExportPage extends StatefulWidget {
  const TypewriterExportPage({Key? key}) : super(key: key);

  @override
  State<TypewriterExportPage> createState() => _TypewriterExportPageState();
}

class _TypewriterExportPageState extends State<TypewriterExportPage> {
  List<TextSpan> textSpans = [];
  final _typeWriterController = Get.find<TypeWriterController>();

  @override
  void initState() {
    super.initState();

    final json = jsonDecode(_typeWriterController.documentJson);
    final spansList = SpanModel.fromDynamicListJson(json).spans;
    for(final spanModel in spansList!){
      TextSpan textSpan = TextSpan(
          text: spanModel.insert ?? '',
          style: TextStyle(
            fontWeight: spanModel.attributes!.bold! ? FontWeight.bold : FontWeight.normal,
            fontStyle: spanModel.attributes!.italic! ? FontStyle.italic : FontStyle.normal,
            color: spanModel.attributes!.color! == 'FF000000' ? GithubGridThemes().lightTextColor : HexColor(spanModel.attributes!.color!),//"#FF000000" - #FFFFFFFF"
            fontSize: spanModel.attributes!.size!.toDouble() ,
          )
      );
      textSpans.add(textSpan);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: const Color(0xffEDEDED),
              borderRadius: BorderRadius.circular(16)
          ),
          child: TypeRichText(
            text: TextSpan(
              text: '',
              style: const TextStyle(
                color: Colors.black,
              ),
              children: textSpans,
            ),
            duration: const Duration(milliseconds: 1000),
            onType: (progress) {
              debugPrint("Rich text %${(progress * 100).toStringAsFixed(0)} completed.");
            },
          )
      ),
    );
  }
}
