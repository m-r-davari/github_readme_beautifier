import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:github_readme_beautifier/resources/github_themes.dart';
import 'package:github_readme_beautifier/data/typewriter/models/span_model.dart';
import 'package:github_readme_beautifier/presentation/typewriter_text/controllers/typewriter_controller.dart';
import 'package:github_readme_beautifier/utils/const_keeper.dart';
import 'package:github_readme_beautifier/utils/hex_color.dart';
import 'package:github_readme_beautifier/presentation/typewriter_text/widgets/typewriter_rich_text.dart';
import 'package:github_readme_beautifier/presentation/exporter/exporter_view.dart';

class TypewriterExportPage extends StatefulWidget {
  const TypewriterExportPage({Key? key}) : super(key: key);

  @override
  State<TypewriterExportPage> createState() => _TypewriterExportPageState();
}

class _TypewriterExportPageState extends State<TypewriterExportPage> {

  List<Span> spansModelList = [];
  double structFontSize = 16;
  final _typeWriterController = Get.find<TypeWriterController>();
  String dropdownValue = '0';
  Map<String,String> loopMode = {
    '0' : '-1',
    '1' : '1',
    '2' : '2',
    '3' : '3',
    'Infinite' : '0'
  };
  bool loopDelay = true;

  @override
  void initState() {
    _typeWriterController.loopCount = loopMode[dropdownValue]!;
    _typeWriterController.loopDelay = loopDelay;
    final json = jsonDecode(_typeWriterController.documentJson);
    spansModelList = SpanModel.fromDynamicListJson(json).spans!;
    if(spansModelList.last.insert =='\n'){
      spansModelList.last.insert = ' ';
    }
    else if (spansModelList.last.insert!.contains('\n')){
      spansModelList.last.insert = spansModelList.last.insert!.trimRight();
      spansModelList.last.insert = '${spansModelList.last.insert!} ';
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
        automaticallyImplyLeading: false,
        centerTitle: false,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Typewriter Text Export'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
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
            const SizedBox(height: 24,),
            Row(
              children: [
                ElevatedButton(
                    onPressed: (){
                      _typeWriterController.replay();
                    },
                    child: const Row(
                      children: [
                        Text('Replay'),
                        SizedBox(width: 4,),
                        Icon(Icons.play_arrow,size: 16,)
                      ],
                    )
                )
                ,
                const SizedBox(width: 16,)
                ,
                ElevatedButton(
                    onPressed: ()async{
                      showDialog(
                        context: Get.context!,
                        barrierDismissible: false,
                        builder: (context) {
                          return const AlertDialog(
                            backgroundColor: Colors.white,
                            surfaceTintColor: Colors.white,

                            content: ExporterDialog(),
                          );
                        },
                      );
                      if(ConstKeeper.isFFmpegLoaded.value){
                        await _typeWriterController.export();
                      }
                      else{
                        await ConstKeeper.isFFmpegLoaded.stream.firstWhere((loaded) => loaded == true);
                        await _typeWriterController.export();
                      }
                    },
                    child: const Row(
                      children: [
                        Text('Export'),
                        SizedBox(width: 8,),
                        Icon(Icons.save_alt,size: 16,)
                      ],
                    )
                )
                ,
                const SizedBox(width: 16,)
                ,
                Container(
                  height: 35,
                  padding: EdgeInsets.only(left: 8,right: 8),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(16),border: Border.all(color: Colors.deepPurpleAccent,width: 1)),
                  child: Row(
                    children: [
                      const Text('Loop Count : ',style: TextStyle(color: Colors.deepPurple),),
                      const SizedBox(width: 8,),
                      DropdownButton<String>(
                        value: dropdownValue,
                        icon: const Icon(Icons.arrow_drop_down,size: 17,color: Colors.deepPurple,),
                        elevation: 16,
                        style: const TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 0.1,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (String? value) {
                          setState(() {
                            dropdownValue = value!;
                            _typeWriterController.loopCount = loopMode[value]!;
                          });
                        },
                        items: loopMode.keys.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      )
                    ],
                  ),
                )
                ,
                const SizedBox(width: 16,)
                ,
                Container(
                  height: 35,
                  padding: const EdgeInsets.only(left: 8,),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(16),border: Border.all(color: Colors.deepPurpleAccent,width: 1)),
                  child: Row(
                    children: [
                      const Text('Loop Delay : ',style: TextStyle(color: Colors.deepPurple),),
                      const SizedBox(width: 8,),
                      Switch(
                          value: loopDelay,
                          onChanged: (value){
                            _typeWriterController.loopDelay = value;
                            setState(() {
                              loopDelay = value;
                            });
                          }
                      )
                    ],
                  ),
                )

              ],
            )
          ],
        ),
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
            color: spanModel.attributes!.color! == '#FF000000' ? (isLight ? GithubThemes().lightTextColor : GithubThemes().darkTextColor) : HexColor(spanModel.attributes!.color!),//"#FF000000" - #FFFFFFFF"
            fontSize: spanModel.attributes!.size!.toDouble() ,
          )
      );
      TextSpan textSpanBg = TextSpan(
          text: spanModel.insert ?? '',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontStyle: spanModel.attributes!.italic! ? FontStyle.italic : FontStyle.normal,
              color: isLight ? GithubThemes().lightBgColor : GithubThemes().darkBgColor,
              fontSize: spanModel.attributes!.size!.toDouble(),
              shadows: [
                Shadow(color: isLight ? GithubThemes().lightBgColor : GithubThemes().darkBgColor,blurRadius: 1,offset: const Offset(0,0))
              ]
          )
      );
      totalSpans[0].add(textSpan);
      totalSpans[1].add(textSpanBg);
    }
    return totalSpans;
  }

}

