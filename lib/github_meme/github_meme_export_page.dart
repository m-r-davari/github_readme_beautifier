import 'dart:typed_data';

import 'package:ffmpeg_wasm/ffmpeg_wasm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:github_readme_beautifier/github_meme/github_meme_controller.dart';
import 'package:github_readme_beautifier/utils/const_keeper.dart';

class GithubMemeExportPage extends StatefulWidget {
  const GithubMemeExportPage({Key? key}) : super(key: key);
  @override
  State<GithubMemeExportPage> createState() => _GithubMemeExportPageState();
}

class _GithubMemeExportPageState extends State<GithubMemeExportPage> with TickerProviderStateMixin {

  final controller = Get.find<GithubMemeController>();
  final ffmpeg = Get.find<FFmpeg>();
  List<Uint8List> gifs = [];

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero,()async{
      if(ConstKeeper.isFFmpegLoaded.value){
        gifs = await controller.exportGifs();
      }
      else{
        if(!controller.hasAnimListener){//it means its exporting so do not export again
        }
        await ConstKeeper.isFFmpegLoaded.stream.firstWhere((loaded) => loaded == true);
        gifs = await controller.exportGifs();
      }
    });


  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (()async=>false),
      child: Obx((){
        return AnimatedContainer(
            //margin: const EdgeInsets.all(100),
            width: !ConstKeeper.isFFmpegLoaded.value ? 120 : controller.exportProgressValue.value < 1.0 ? 500 : MediaQuery.of(context).size.width/1.2,
            height: !ConstKeeper.isFFmpegLoaded.value ? 120 : controller.exportProgressValue.value < 1.0 ? 120 : 700,
            duration: const Duration(milliseconds: 600),
            child: !ConstKeeper.isFFmpegLoaded.value ? const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 8,),
                CircularProgressIndicator(),
                SizedBox(height: 24,),
                Text('Preparing...',style: TextStyle(fontWeight: FontWeight.bold),),
                SizedBox(height: 8,),
              ],
            )
                :
            controller.exportProgressValue.value < 1.0 ?
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16,),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    LinearProgressIndicator(
                      backgroundColor: Colors.grey,
                      color: Colors.blue,
                      minHeight: 15,
                      borderRadius: BorderRadius.circular(8),
                      value: controller.exportProgressValue.value,
                    )
                    ,
                    Text('${(controller.exportProgressValue.value*100).toInt()}%',style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)
                  ],
                ),
                const SizedBox(height: 16,),
                const Text('Please Wait',style: TextStyle(fontWeight: FontWeight.bold),)
              ],
            )
                :
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Align(alignment: Alignment.centerLeft,child: Text('Gifs Preview :',style: TextStyle(fontWeight: FontWeight.bold))),
                const SizedBox(height: 8,),
                const Align(alignment: Alignment.centerLeft,child: Text('You can download exported Gifs file for both Light and Dark theme.')),
                const SizedBox(height: 16,),
                const Align(alignment: Alignment.centerLeft,child: Text('- Gif 1')),
                Image.memory(
                    Uint8List.fromList(gifs[0])
                ),
                const SizedBox(height: 16,)
                ,
                const Align(alignment: Alignment.centerLeft,child: Text('- Gif 2')),
                Image.memory(
                    Uint8List.fromList(gifs[1])
                ),
                const SizedBox(height: 16,)
                ,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: (){
                          controller.downloadGifs(gifs[0], gifs[1]);
                        },
                        child: const Row(
                          children: [
                            Text('Download'),
                            SizedBox(width: 8,),
                            Icon(Icons.download)
                          ],
                        )
                    ),
                    const SizedBox(width: 16,),
                    ElevatedButton(
                        onPressed: (){
                          Get.back();
                        },
                        child: const Row(
                          children: [
                            Text('Close'),
                            SizedBox(width: 8,),
                            Icon(Icons.close)
                          ],
                        )
                    ),
                  ],
                )
              ],
            )
        );
      }),
    );
  }


  @override
  void dispose() {
    controller.exportProgressValue.value = 0.0;
    super.dispose();
  }

}
