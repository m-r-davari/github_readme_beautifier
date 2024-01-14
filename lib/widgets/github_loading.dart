import 'package:flutter/material.dart';

class GithubLoading extends StatelessWidget {
  const GithubLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset('assets/github_loading.gif',width: 50,height: 50,fit: BoxFit.contain,)
        ,
        const SizedBox(height: 8,)
        ,
        const Text('One moment please...',style: TextStyle(fontSize: 13),)
      ],
    );
  }
}
