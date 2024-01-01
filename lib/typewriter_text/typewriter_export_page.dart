import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:github_readme_beautifier/resources/github_grid_themes.dart';
import 'package:github_readme_beautifier/typewriter_text/span_model.dart';
import 'package:github_readme_beautifier/typewriter_text/typewriter_controller.dart';
import 'package:github_readme_beautifier/utils/hex_color.dart';
import 'package:github_readme_beautifier/typewriter_text/typewriter_rich_text.dart';

class TypewriterExportPage extends StatefulWidget {
  const TypewriterExportPage({Key? key}) : super(key: key);

  @override
  State<TypewriterExportPage> createState() => _TypewriterExportPageState();
}

class _TypewriterExportPageState extends State<TypewriterExportPage> {

  List<TextSpan> textSpans = [];
  List<TextSpan> textSpansBg = [];
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
      TextSpan textSpanBg = TextSpan(
          text: spanModel.insert ?? '',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontStyle: spanModel.attributes!.italic! ? FontStyle.italic : FontStyle.normal,
            color: Colors.red,//spanModel.attributes!.color! == 'FF000000' ? GithubGridThemes().lightBgColor : HexColor(spanModel.attributes!.color!),//"#FF000000" - #FFFFFFFF"
            fontSize: spanModel.attributes!.size!.toDouble(),
            shadows: [//GithubGridThemes().lightBgColor
              Shadow(color: Colors.red,blurRadius: 1,offset: const Offset(0,0))
            ]
          )
      );
      textSpans.add(textSpan);
      textSpansBg.add(textSpanBg);
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
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          setState(() {

          });
        },
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
              TypewriterRichText(
                strutStyle: StrutStyle(fontSize: structFontSize),
                text: TextSpan(
                  text: '',
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  children: textSpans,
                ),
                textBg: TextSpan(
                  text: '',
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  children: textSpansBg,
                ),
                duration: Duration(milliseconds: _typeWriterController.documentPlainText.length*30),
                onType: (progress) {
                  debugPrint("Rich text %${(progress * 100).toStringAsFixed(0)} completed.");
                },
              )
              ,
              Opacity(// this for place holer to have the text container size for recording
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
