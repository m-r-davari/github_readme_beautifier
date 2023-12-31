import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:github_readme_beautifier/typewriter_text/typewriter_controller.dart';
import 'package:github_readme_beautifier/typewriter_text/typewriter_export_page.dart';

class TypewriterTextPage extends StatefulWidget {
  const TypewriterTextPage({Key? key}) : super(key: key);

  @override
  State<TypewriterTextPage> createState() => _TypewriterTextPageState();
}

class _TypewriterTextPageState extends State<TypewriterTextPage> {
  final _typeWriterController = Get.find<TypeWriterController>();
  final QuillController _quillController = QuillController.basic();//..selectFontSize('20')..setContents(Delta.fromJson([{"insert":"hh\n"}]))

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Typewriter Text'),
      ),
      body:  Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: const Color(0xffEDEDED),
            child: QuillToolbar.simple(
              configurations: QuillSimpleToolbarConfigurations(
                showSuperscript: false,
                showSubscript: false,
                showListCheck: false,
                showCodeBlock: false,
                showInlineCode: false,
                showStrikeThrough: false,
                showUnderLineButton: false,
                showIndent: false,
                showLink: false,
                showSearchButton: false,
                showQuote: false,
                showFontFamily: false,
                showListNumbers: false,
                showListBullets: false,
                showHeaderStyle: false,
                showBackgroundColorButton: false,
                showClearFormat: false,
                controller: _quillController,
                toolbarSectionSpacing: 0,
                sectionDividerSpace: 0,
                fontSizesValues: const {'16':'16','20': '20', '25': '25', '30': '30','35': '35', '40': '40', '45': '45','50': '50', '55': '55', '60': '60'}
              ),
            ),
          )
          ,
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                  color: Color(0xffEDEDED),
                  borderRadius: BorderRadius.all(Radius.circular(8))
              ),
              padding: const EdgeInsets.all(16),
              child: QuillEditor.basic(
                configurations: QuillEditorConfigurations(
                  showCursor: true,
                  controller: _quillController,
                  readOnly: false,
                ),
              ),
            ),
          )
          ,
          Padding(
            padding: const EdgeInsets.only(left: 16,right: 16,bottom: 16),
            child: ElevatedButton(onPressed: (){
              final json = jsonEncode(_quillController.document.toDelta().toJson());
              _typeWriterController.documentJson = json;
              // final json2 = jsonDecode(r'{"insert":"hello\n"}');
              // final vvvv = _controller.document = Document.fromJson(json2);
              print('${json}');
              Get.toNamed('/typewriter_export_page');
            }, child: const Text('Preview')),
          )
        ],
      )
    );
  }
}
