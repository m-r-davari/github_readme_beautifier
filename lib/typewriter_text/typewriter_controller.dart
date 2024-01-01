import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:github_readme_beautifier/typewriter_text/typewriter_rich_text.dart';


GlobalKey<TypewriterRichTextState> typewriterRichTextKey = GlobalKey();

class TypeWriterController extends GetxController {

  String documentJson = '{}';
  String documentPlainText = '';

  void export(){
    var spans = typewriterRichTextKey.currentState!.currentSpans;
    //typewriterKey.currentState!.replay();
    typewriterRichTextKey.currentState!.reset();
    print('-----prrr----- ${spans.length} -----');
  }

}