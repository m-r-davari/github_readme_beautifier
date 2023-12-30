import 'package:flutter/material.dart';
import 'package:github_readme_beautifier/widgets/type_rich_text.dart';

class TypewriterExportPage extends StatefulWidget {
  final String text;
  const TypewriterExportPage({Key? key,required this.text}) : super(key: key);

  @override
  State<TypewriterExportPage> createState() => _TypewriterExportPageState();
}

class _TypewriterExportPageState extends State<TypewriterExportPage> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 700),
      child: TypeRichText(
        text: TextSpan(
          //text: widget.text,
          style: TextStyle(
            color: Colors.black,
          ),
          children: <TextSpan>[
            TextSpan(
              text: 'bold',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.red),
            ),
            TextSpan(
              text: ' world!',
              style: TextStyle(color: Colors.blue),
            ),
          ],
        ),
        duration: const Duration(seconds: 1),
        onType: (progress) {
          debugPrint("Rich text %${(progress * 100).toStringAsFixed(0)} completed.");
        },
      )
    );
  }
}
