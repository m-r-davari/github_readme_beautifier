
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:github_readme_beautifier/github_grid_view.dart';
import 'package:github_readme_beautifier/resources/github_grid_themes.dart';


class GithubMemePage extends StatefulWidget {
  const GithubMemePage({Key? key}) : super(key: key);

  @override
  State<GithubMemePage> createState() => _GithubMemePageState();
}

GlobalKey boundryGlobalKey = GlobalKey();

class _GithubMemePageState extends State<GithubMemePage> {

  List<int> grids = List.filled(368, 0);
  String themeName = 'Default';
  GithubGridThemes themes = GithubGridThemes();
  bool showBorder = true;
  bool showAuthor = true;
  bool showProgressHint = true;
  bool showDate = true;
  bool isRecording = false;



  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GithubGridView(
          grids: grids,
          themeName: themeName,
          showBorder: showBorder,
          showAuthor: showAuthor,
          showDate: showDate,
          showProgressHint: showProgressHint,
          isRecording: isRecording,
        )
        ,
        const SizedBox(height: 16,)
        ,
        FittedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 24,)
              ,
              ElevatedButton(
                  onPressed: (){
                    grids.fillRange(0, grids.length,0);
                    setState(() {
                    });
                  },
                  child: const Text('Reset')
              )
              ,
              const SizedBox(width: 24,)
              ,
              ElevatedButton(
                  onPressed: ()async{
                    var result = await showThemePickerDialog(themes.themeMap.keys.toList(),themeName);
                    if(result!=null){
                      themeName = result;
                      setState((){});
                    }
                  },
                  child: const Text('Choose Theme')
              )
              ,
              const SizedBox(width: 24,)
              ,
              ElevatedButton(
                  onPressed: (){
                    setState(() {
                      showBorder=!showBorder;
                    });
                  },
                  child: Text(showBorder ? 'Hide Border' : 'Show Border')
              )
              ,
              const SizedBox(width: 24,)
              ,
              ElevatedButton(
                  onPressed: (){
                    setState(() {
                      showAuthor=!showAuthor;
                    });
                  },
                  child: Text(showAuthor ? 'Hide Author' : 'Show Author')
              )
              ,
              const SizedBox(width: 24,)
              ,
              ElevatedButton(
                  onPressed: (){
                    setState(() {
                      showProgressHint=!showProgressHint;
                    });
                  },
                  child: Text(showProgressHint ? 'Hide Progress Hint' : 'Show Progress Hint')
              )
              ,
              const SizedBox(width: 24,)
              ,
              ElevatedButton(
                  onPressed: (){
                    setState(() {
                      showDate=!showDate;
                    });
                  },
                  child: Text(showDate ? 'Hide Date' : 'Show Date')
              )
              ,
              const SizedBox(width: 24,)
              ,
              ElevatedButton(
                  onPressed: ()async{

                    List<Uint8List> scList = [];

                    //generates frames png
                    const animDuration = 100; //x * 5
                    Timer.periodic(const Duration(milliseconds: 42), (Timer timer)async{
                      if(timer.tick*42 <= animDuration){
                        print('---ticking---- ${timer.tick} ---- ${timer.tick*42} ----');
                        final result = await captureScreen();
                        scList.add(result);
                      }
                      else{
                        print('---last tick---- ${timer.tick} --');
                        timer.cancel();
                      }

                    });


                    Future.delayed(const Duration(seconds: 3),(){
                      print('-----list of sc---- ${scList.length} ----');
                    });


/*                    final image8List = await captureScreen();
                    // ignore: use_build_context_synchronously
                    showDialog(
                      context: context,
                      builder: (ctx) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          content: Image.memory(image8List),
                        );
                      },
                    );*/


                  },
                  child: Text(isRecording ? 'Stop Recording' : 'Start Recording')
              )
              ,
              const SizedBox(width: 24,)
            ],
          ),
        )
      ],
    );
  }


  @override
  void dispose() {
    super.dispose();
  }

  Future<Uint8List> captureScreen()async{
    // Perform the screen capture and handle the image as needed
    // Example: Save the image to storage or display it in a dialog
    // Here, we just print the image size for demonstration purposes
    RenderRepaintBoundary boundary = boundryGlobalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await  boundary.toImage();
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    if (byteData != null) {
      print('Captured image size: ${byteData.lengthInBytes} bytes');
      return Uint8List.fromList(byteData.buffer.asUint8List());
    }
    else{
      throw Exception();
    }
  }

  Future<String?> showThemePickerDialog(List<String> themes,[String? chosenTheme])async{
    return await showModalBottomSheet<String>(context: context, builder: (ctx){
      return SizedBox(
        height: 250,
        child: ListView.separated(
          itemCount: themes.length,
          padding: const EdgeInsets.only(top: 16),
          itemBuilder: (ctx,index){
            return InkWell(
              onTap: (){
                Navigator.pop(context,themes[index]);
              },
              child: Container(
                height: 50,
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${index+1}'),
                    Text(themes[index]),
                    Icon(chosenTheme == themes[index] ? Icons.check_box : Icons.check_box_outline_blank)
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (ctx,index){
            return const Divider(color: Colors.grey,thickness: 0.6,indent: 10,endIndent: 10,);
          },
        ),
      );
    });
  }



}
