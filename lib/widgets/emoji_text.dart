import 'package:flutter/material.dart';

class EmojiText extends StatelessWidget {

  const EmojiText({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController(text: 'ssssssss🤣sssssss'),
    );
  }


}