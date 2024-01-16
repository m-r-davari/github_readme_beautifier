import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final bool isLoading;
  final String text;
  final Function()? onTap;
  const PrimaryButton({Key? key,this.isLoading=false,required this.text,this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onTap,
        child: isLoading ? const SizedBox(width: 15,height: 15,child: CircularProgressIndicator(strokeWidth: 3,),) : Text(text)
    );
  }
}
