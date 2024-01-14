import 'package:flutter/material.dart';

class GithubLoading extends StatelessWidget {
  const GithubLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/github_loading.gif',width: 60,height: 60,fit: BoxFit.contain,);
  }
}
