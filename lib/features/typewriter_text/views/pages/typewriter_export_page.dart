import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:github_readme_beautifier/resources/github_grid_themes.dart';
import 'package:github_readme_beautifier/features/typewriter_text/models/span_model.dart';
import 'package:github_readme_beautifier/features/typewriter_text/views/controllers/typewriter_controller.dart';
import 'package:github_readme_beautifier/utils/hex_color.dart';
import 'package:github_readme_beautifier/features/typewriter_text/views/widgets/typewriter_rich_text.dart';

class TypewriterExportPage extends StatefulWidget {
  const TypewriterExportPage({Key? key}) : super(key: key);

  @override
  State<TypewriterExportPage> createState() => _TypewriterExportPageState();
}

class _TypewriterExportPageState extends State<TypewriterExportPage> {

  List<Span> spansModelList = [];
  double structFontSize = 16;
  final _typeWriterController = Get.find<TypeWriterController>();

  @override
  void initState() {
    final json = jsonDecode(_typeWriterController.documentJson);
    spansModelList = SpanModel.fromDynamicListJson(json).spans!;
    if(spansModelList.last.insert =='\n'){
      spansModelList.removeLast();
    }
    else if (spansModelList.last.insert!.contains('\n')){
      spansModelList.last.insert = spansModelList.last.insert!.substring(0,spansModelList.last.insert!.length-1);
    }

    structFontSize = spansModelList
        .map((span) => span.attributes!.size!.toDouble())
        .reduce((currentMax, fontSize) => fontSize > currentMax ? fontSize : currentMax);

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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'replay',
            onPressed: (){
              _typeWriterController.isLight.value = !_typeWriterController.isLight.value;
              typewriterRichTextKey.currentState!.replay();
            },
            child: Icon(Icons.replay),
          ),
          FloatingActionButton(
            onPressed: (){
              _typeWriterController.export();
            },
            child: Icon(Icons.skip_next),
          ),
        ],
      ),
      body: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: const Color(0xffEDEDED),
              borderRadius: BorderRadius.circular(16)
          ),
          child: RepaintBoundary(
            key: typeWriterBoundryGlobalKey,
            child: Obx((){
              final listSpans = generateSpans(_typeWriterController.isLight.value);
              return Stack(
                children: [
                  TypewriterRichText(
                    key: typewriterRichTextKey,
                    strutStyle: StrutStyle(fontSize: structFontSize),
                    text: TextSpan(
                      text: '',
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                      children: listSpans[0],
                    ),
                    textBg: TextSpan(
                      text: '',
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                      children: listSpans[1],
                    ),
                    duration: Duration(milliseconds: _typeWriterController.documentPlainText.length*30),
                    // onType: (progress) {
                    //   debugPrint("Rich text %${(progress * 100).toStringAsFixed(0)} completed.");
                    // },
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
                      children: listSpans[0],
                    ),
                  ),
                )
                ],
              );
            }),
          )
      ),
    );
  }




  List<List<TextSpan>> generateSpans (isLight){
    List<List<TextSpan>> totalSpans = [[],[]];
    for(final spanModel in spansModelList){
      TextSpan textSpan = TextSpan(
          text: spanModel.insert ?? '',
          style: TextStyle(
            fontWeight: spanModel.attributes!.bold! ? FontWeight.bold : FontWeight.normal,
            fontStyle: spanModel.attributes!.italic! ? FontStyle.italic : FontStyle.normal,
            color: spanModel.attributes!.color! == '#FF000000' ? (isLight ? GithubGridThemes().lightTextColor : GithubGridThemes().darkTextColor) : HexColor(spanModel.attributes!.color!),//"#FF000000" - #FFFFFFFF"
            fontSize: spanModel.attributes!.size!.toDouble() ,
          )
      );
      TextSpan textSpanBg = TextSpan(
          text: spanModel.insert ?? '',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontStyle: spanModel.attributes!.italic! ? FontStyle.italic : FontStyle.normal,
              color: isLight ? GithubGridThemes().lightBgColor : GithubGridThemes().darkBgColor,
              fontSize: spanModel.attributes!.size!.toDouble(),
              shadows: [
                Shadow(color: isLight ? GithubGridThemes().lightBgColor : GithubGridThemes().darkBgColor,blurRadius: 1,offset: const Offset(0,0))
              ]
          )
      );
      totalSpans[0].add(textSpan);
      totalSpans[1].add(textSpanBg);
    }
    return totalSpans;
  }

}

