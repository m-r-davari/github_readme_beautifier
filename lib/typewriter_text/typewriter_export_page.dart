import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:github_readme_beautifier/resources/github_grid_themes.dart';
import 'package:github_readme_beautifier/typewriter_text/span_model.dart';
import 'package:github_readme_beautifier/typewriter_text/typewriter_controller.dart';
import 'package:github_readme_beautifier/utils/hex_color.dart';
import 'package:github_readme_beautifier/widgets/type_rich_text.dart';
import 'package:collection/collection.dart';

class TypewriterExportPage extends StatefulWidget {
  const TypewriterExportPage({Key? key}) : super(key: key);

  @override
  State<TypewriterExportPage> createState() => _TypewriterExportPageState();
}

class _TypewriterExportPageState extends State<TypewriterExportPage> {

  List<TextSpan> textSpans = [];
  final _typeWriterController = Get.find<TypeWriterController>();
  double structFontSize = 16;

  @override
  void initState() {
    final json = jsonDecode(_typeWriterController.documentJson);
    final spansList = SpanModel.fromDynamicListJson(json).spans;
    if(spansList!.last.insert =='\n'){
      spansList.removeLast();
    }
    else if (spansList.last.insert!.contains('\n')){
      spansList.last.insert = spansList.last.insert!.substring(0,spansList.last.insert!.length-2);
    }

    structFontSize = spansList
        .map((span) => span.attributes!.size!.toDouble())
        .reduce((currentMax, fontSize) => fontSize > currentMax ? fontSize : currentMax);

    print('----max size --- $structFontSize ---');

    for(final spanModel in spansList){
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Typewriter Text Export'),
      ),
      body: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: const Color(0xffEDEDED),
              borderRadius: BorderRadius.circular(16)
          ),
          child: Stack(
            children: [
              Positioned(
                //top: 0,
                //bottom: 0,
                child: TypeRichText(
                  strutStyle: StrutStyle(fontSize: structFontSize),
                  text: TextSpan(
                    text: '',
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    children: textSpans,
                  ),
                  duration: Duration(seconds: 4),//Duration(milliseconds: _typeWriterController.documentPlainText.length*30),
                  onType: (progress) {
                    debugPrint("Rich text %${(progress * 100).toStringAsFixed(0)} completed.");
                  },
                ),
              )
              ,
              Opacity(
                opacity: 0.0,
                child: RichText(
                  text: TextSpan(
                    text: '',
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    children: textSpans,
                  ),

                ),
              )
            ],
          )

      ),
    );
  }
}
