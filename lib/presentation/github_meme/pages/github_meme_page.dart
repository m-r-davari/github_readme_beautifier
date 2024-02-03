import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:github_readme_beautifier/presentation/github_meme/widgets/github_grid_view.dart';
import 'package:github_readme_beautifier/resources/github_themes.dart';
import 'package:github_readme_beautifier/utils/const_keeper.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../controllers/github_meme_controller.dart';
import 'github_meme_export_page.dart';

class GithubMemePage extends StatefulWidget {
  const GithubMemePage({Key? key}) : super(key: key);

  @override
  State<GithubMemePage> createState() => _GithubMemePageState();
}

class _GithubMemePageState extends State<GithubMemePage> {
  String themeName = 'Default';
  GithubThemes themes = GithubThemes();
  bool showBorder = true;
  bool showAuthor = true;
  bool showProgressHint = true;
  bool showDate = true;
  final memeController = Get.find<GithubMemeController>();

  @override
  Widget build(BuildContext context) {

    return ResponsiveScaledBox(width: 1038, child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Github Meme'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GithubGridView(
            grids: memeController.grids,
            themeName: themeName,
            showBorder: showBorder,
            showAuthor: showAuthor,
            showDate: showDate,
            showProgressHint: showProgressHint,
          ),
          const SizedBox(
            height: 16,
          ),
          FittedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 24,
                ),
                ElevatedButton(
                    onPressed: () {
                      memeController.grids.fillRange(0, memeController.grids.length, 0);
                      setState(() {});
                    },
                    child: const Text('Reset')),
                const SizedBox(
                  width: 24,
                ),
                ElevatedButton(
                    onPressed: () async {
                      var result = await showThemePickerDialog(themes.themesMap.keys.toList(), themeName);
                      if (result != null) {
                        themeName = result;
                        setState(() {});
                      }
                    },
                    child: const Text('Choose Theme')),
                const SizedBox(
                  width: 24,
                ),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showBorder = !showBorder;
                      });
                    },
                    child: Text(showBorder ? 'Hide Border' : 'Show Border')),
                const SizedBox(
                  width: 24,
                ),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showAuthor = !showAuthor;
                      });
                    },
                    child: Text(showAuthor ? 'Hide Author' : 'Show Author')),
                const SizedBox(
                  width: 24,
                ),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showProgressHint = !showProgressHint;
                      });
                    },
                    child: Text(showProgressHint ? 'Hide Progress Hint' : 'Show Progress Hint')),
                const SizedBox(
                  width: 24,
                ),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showDate = !showDate;
                      });
                    },
                    child: Text(showDate ? 'Hide Date' : 'Show Date')),
                const SizedBox(
                  width: 24,
                ),
                ElevatedButton(
                    onPressed: () async {
                      if(!ConstKeeper.isWeb && !ConstKeeper.isDesktop){
                        Get.showSnackbar(const GetSnackBar(
                          title: 'Error',
                          message: 'Use desktop web browser to export files.',
                          duration: Duration(seconds: 3),
                        ));
                        return;
                      }
                      showDialog(
                        context: Get.context!,
                        barrierDismissible: false,
                        builder: (context) {
                          return const AlertDialog(
                            backgroundColor: Colors.white,
                            surfaceTintColor: Colors.white,
                            content: GithubMemeExportPage(),
                          );
                        },
                      );
                    },
                    child: const Text('Export')),
                const SizedBox(
                  width: 24,
                )
              ],
            ),
          )
        ],
      ),
    ),);

  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<String?> showThemePickerDialog(List<String> themes, [String? chosenTheme]) async {
    return await showModalBottomSheet<String>(
        context: context,
        builder: (ctx) {
          return SizedBox(
            height: 250,
            child: ListView.separated(
              itemCount: themes.length,
              padding: const EdgeInsets.only(top: 16),
              itemBuilder: (ctx, index) {
                return InkWell(
                  onTap: () {
                    Navigator.pop(context, themes[index]);
                  },
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${index + 1}'),
                        Text(themes[index]),
                        Icon(chosenTheme == themes[index] ? Icons.check_box : Icons.check_box_outline_blank)
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (ctx, index) {
                return const Divider(
                  color: Colors.grey,
                  thickness: 0.6,
                  indent: 10,
                  endIndent: 10,
                );
              },
            ),
          );
        });
  }
}
