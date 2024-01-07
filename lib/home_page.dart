import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:github_readme_beautifier/widgets/drawer_widget.dart';
import 'package:github_readme_beautifier/widgets/hover_effect.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'features/common/models/feature_model.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<FeatureModel> features = List.of([
    FeatureModel('Github Meme View', '', 'assets/github_meme_thumbnail.gif'),
    FeatureModel('Typewriter Text View', '', 'assets/typewriter_text_thumbnail.gif'),
    FeatureModel('Linear Commits Chart', '', 'assets/linear_chart_thumbnail.png'),
  ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Github Readme Beautifier'),
      ),
      drawer: DrawerWidget(),
      body: Container(
        padding: const EdgeInsets.all(30),
        child: ResponsiveGridView.builder(
          scrollDirection: Axis.vertical,
          itemCount: features.length,
          gridDelegate: const ResponsiveGridDelegate(
              maxCrossAxisExtent: 440, childAspectRatio: 2.5, mainAxisSpacing: 50, crossAxisSpacing: 50),
          itemBuilder: (ctx, index) {
            return FeatureCardItem(
                index: index,
                title: features[index].title,
                description: features[index].description,
                thumbnail: features[index].thumbnail);
          },
        ),
      ),
    );
  }
}

class FeatureCardItem extends StatelessWidget {
  final int index;
  final String title;
  final String description;
  final String thumbnail;

  const FeatureCardItem({Key? key, required this.index, required this.title, required this.description, required this.thumbnail})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HoverCard(
      depthColor: Colors.transparent,
      //depth: 0,
      shadow: const BoxShadow(
        color: Colors.black26,
        offset: Offset(0, 5),
        blurRadius: 10,
        spreadRadius: 1
      ),
      builder: (x, c) {
        return ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          child: Container(
            color: Colors.white,
            child: Stack(
              //clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                    bottom: index == 0 ? 20 : 3,
                    child: Image.asset(
                      thumbnail,
                      fit: index == 0 ? BoxFit.contain : BoxFit.cover,
                    )),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      height: 35,
                      alignment: Alignment.center,
                      color: Colors.black38,
                      child: Text(
                        '$title${index == 2 ? ' (Coming Soon)' : ''}',
                        maxLines: 1,
                        style: const TextStyle(color: Colors.white),
                      )),
                ),
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(16)),
                        border: Border.all(width: 0.4, color: Colors.grey),
                      ),
                      child: InkWell(
                        onTap: index == 0
                            ? () {
                                Get.toNamed('/meme_page');
                              }
                            : index == 1 ? (){
                                Get.toNamed('/typewriter_page');
                            } : null,
                        borderRadius: const BorderRadius.all(Radius.circular(16)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
