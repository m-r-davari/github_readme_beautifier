import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Github Readme Beautifier'),
      ),
      body: Container(
        padding: const EdgeInsets.all(30),
        child: ResponsiveScaledBox(
          width: 1300,
          child: GridView.count(
            crossAxisCount: 4,
            scrollDirection: Axis.vertical,
            childAspectRatio: 2.2,
            children: const [FeatureCardItem()],
          ),
        ),
      ),
    );
  }
}

class FeatureCardItem extends StatelessWidget {
  const FeatureCardItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      child: Stack(
        //clipBehavior: Clip.none,
        children: [
          Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Image.asset(
                'assets/github_meme_sc.png',
                fit: BoxFit.fill,
              )),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                height: 35,
                alignment: Alignment.center,
                color: Colors.black38,
                child: const Text(
                  'Github Meme View',
                  maxLines: 1,
                  style: TextStyle(color: Colors.white),
                )),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                  border: Border.all(width: 1, color: Colors.grey),
                ),
                child: InkWell(
                  onTap: () {
                    Get.toNamed('/meme_page');
                  },
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
