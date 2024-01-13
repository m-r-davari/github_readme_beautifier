import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:github_readme_beautifier/presentation/exporter/exporter_controller.dart';
import 'package:github_readme_beautifier/resources/github_themes.dart';

class ExporterDialog extends GetView<ExporterController> {
  const ExporterDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (()async=>false),
      child: Obx((){
        return AnimatedContainer(
            //width: !controller.isFFmpegLoaded.value ? 120 : controller.progress.value < 1.0 ? 500 : null,//MediaQuery.of(context).size.width/1.2,
            //height: !controller.isFFmpegLoaded.value ? 120 : controller.progress.value < 1.0 ? 120 : 600,
            duration: const Duration(milliseconds: 600),
            child: !controller.isFFmpegLoaded.value ? Container(
              width: 120,height: 120,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 8,),
                  CircularProgressIndicator(),
                  SizedBox(height: 24,),
                  Text('Preparing...',style: TextStyle(fontWeight: FontWeight.bold),),
                  SizedBox(height: 8,),
                ],
              ),
            )
                :
            controller.progress.value < 1.0 ?
            Container(
              width: 500,
              height: 120,
              child: Column(
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
                        value: controller.progress.value,
                      )
                      ,
                      Text('${(controller.progress.value*100).toInt()}%',style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)
                    ],
                  ),
                  const SizedBox(height: 16,),
                  const Text('Please Wait',style: TextStyle(fontWeight: FontWeight.bold),)
                ],
              ),
            )
                :
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Align(alignment: Alignment.centerLeft,child: Text('Gifs Preview :',style: TextStyle(fontWeight: FontWeight.bold))),
                    IconButton(onPressed: ()=>Get.back(), icon: const Icon(Icons.close))
                  ],
                ),
                const SizedBox(height: 8,),
                const Align(alignment: Alignment.centerLeft,child: Text('You can download exported Gifs file for both Light and Dark theme.')),
                const SizedBox(height: 16,),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const Align(alignment: Alignment.centerLeft,child: Text(' Light Gif')),
                        const SizedBox(height: 2,),
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(color: GithubThemes().lightBgColor,borderRadius: const BorderRadius.only(topLeft: Radius.circular(8),topRight: Radius.circular(8), bottomRight: Radius.circular(8),bottomLeft: Radius.circular(8))),
                          child: Image.memory(
                              Uint8List.fromList(controller.gifs[1])
                          ),
                        ),
                        const SizedBox(height: 16,),//
                        FittedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                  onPressed: (){
                                    controller.downloadGif(gif: controller.gifs[0], typeName: 'original', fileName: controller.fileName.value, themeName: 'light');
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text('Original Light Gif'),
                                      const SizedBox(width: 8,),
                                      const Icon(Icons.cloud_download_outlined,size: 19,),
                                      const SizedBox(width: 8,),
                                      Text('${controller.gifs[0].lengthInBytes~/1024} kb',style: const TextStyle(color: Colors.grey,fontSize: 12),),
                                    ],
                                  )
                              ),
                              const SizedBox(width: 16,),
                              ElevatedButton(
                                  onPressed: (){
                                    controller.downloadGif(gif: controller.gifs[1], typeName: 'optimized', fileName: controller.fileName.value, themeName: 'light');
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text('Optimized Light Gif'),
                                      const SizedBox(width: 8,),
                                      const Icon(Icons.cloud_download_outlined,size: 19,),
                                      const SizedBox(width: 8,),
                                      Text('${controller.gifs[1].lengthInBytes~/1024} kb',style: const TextStyle(color: Colors.green,fontSize: 12),),
                                    ],
                                  )
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16,),
                        const Align(alignment: Alignment.centerLeft,child: Text(' Dark Gif')),
                        const SizedBox(height: 2,),
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(color: GithubThemes().darkBgColor,borderRadius: const BorderRadius.only(topLeft: Radius.circular(8),topRight: Radius.circular(8), bottomRight: Radius.circular(8),bottomLeft: Radius.circular(8))),
                          child: Image.memory(
                              Uint8List.fromList(controller.gifs[3])
                          ),
                        ),
                        const SizedBox(height: 16,),
                        FittedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                  onPressed: (){
                                    controller.downloadGif(gif: controller.gifs[2], typeName: 'original', fileName: controller.fileName.value, themeName: 'dark');
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text('Original Dark Gif'),
                                      const SizedBox(width: 8,),
                                      const Icon(Icons.cloud_download,size: 19,),
                                      const SizedBox(width: 8,),
                                      Text('${controller.gifs[2].lengthInBytes~/1024} kb',style: const TextStyle(color: Colors.grey,fontSize: 12),),
                                    ],
                                  )
                              ),
                              const SizedBox(width: 16,),
                              ElevatedButton(
                                  onPressed: (){
                                    controller.downloadGif(gif: controller.gifs[3], typeName: 'optimized', fileName: controller.fileName.value, themeName: 'dark');
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text('Optimized Dark Gif'),
                                      const SizedBox(width: 8,),
                                      const Icon(Icons.cloud_download,size: 19,),
                                      const SizedBox(width: 8,),
                                      Text('${controller.gifs[3].lengthInBytes~/1024} kb',style: const TextStyle(color: Colors.green,fontSize: 12),),
                                    ],
                                  )
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8,),
                      ],
                    ),
                  ),
                ),
              ],
            )
        );
      }),
    );
  }



}