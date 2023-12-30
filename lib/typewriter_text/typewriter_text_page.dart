import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class TypewriterTextPage extends StatefulWidget {
  const TypewriterTextPage({Key? key}) : super(key: key);

  @override
  State<TypewriterTextPage> createState() => _TypewriterTextPageState();
}

class _TypewriterTextPageState extends State<TypewriterTextPage> {
  TextEditingController textEditingController = TextEditingController();
  final QuillController _controller = QuillController.basic();
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
                controller: _controller,
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
                  controller: _controller,
                  readOnly: false,
                ),
              ),
            ),
          )
          ,
          Padding(
            padding: const EdgeInsets.only(left: 16,right: 16,bottom: 16),
            child: ElevatedButton(onPressed: (){}, child: const Text('Preview')),
          )
        ],
      )
    );
  }
}