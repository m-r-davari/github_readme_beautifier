import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:github_readme_beautifier/presentation/user/user_controller.dart';
import 'dart:js' as js;

import 'flip_effect.dart';

class DrawerWidget extends StatelessWidget {
  final userController = Get.find<UserController>();
  DrawerWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width / 1.3,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.black12,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      Align(alignment: Alignment.centerLeft,child: FlipperView(child: Image.asset('assets/logo_github_1.png',width: 80,height: 80,),)),
                      Positioned(top: 5,right: 5,child: IconButton(onPressed: ()=>Get.back(), icon: const Icon(Icons.close,size: 16,)))
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: (){
                        Get.toNamed('/user_page');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Username : ',style: TextStyle(fontWeight: FontWeight.bold),),
                              Obx(() => Text(userController.userName.value,maxLines: 1,),)
                            ],
                          )
                          ,
                          const SizedBox(width: 8,)
                          ,
                          const Padding(
                              padding: EdgeInsets.only(bottom: 2),
                              child: Icon(Icons.edit,size: 18,color: Colors.blueAccent,)
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: (){
                        js.context.callMethod('open', ['https://github.com/m-r-davari/github_readme_beautifier']);
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Github Readme Beautifier',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 4,),
                          Icon(Icons.outbond_outlined,size: 15,color: Colors.blueAccent,)
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  const Text('A web app to beautify and enhance your Github README file, that provides interesting widgets in PNG and GIF(animated) formats.',style: TextStyle(fontSize: 13),),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text('This project developed by \'MohammadReza Davari\' using Flutter web.',style: TextStyle(fontSize: 13),),
                  const SizedBox(height: 10,),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: (){
                        js.context.callMethod('open', ['mailto:m.r.davari92@gmail.com']);
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 18,height: 15,
                              decoration: const BoxDecoration(
                                  color: Colors.blueAccent,
                                  borderRadius: BorderRadius.all(Radius.circular(4))
                              ),
                              child: const Icon(Icons.mail_outline_sharp,color: Colors.white,size: 11,)
                          ),
                          const SizedBox(width: 6,),
                          const Text('m.r.davari92@gmail.com',style: TextStyle(fontSize: 13),),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: (){
                        js.context.callMethod('open', ['https://www.linkedin.com/in/m-r-davari92']);
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                              width: 18,height: 15,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.only(top: 0,bottom: 3.5,left: 0,right: 0),
                              decoration: const BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.all(Radius.circular(4))
                          ),child: const Text('in',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 11),)),
                          const SizedBox(width: 6,),
                          const Text('linkedin.com/in/m-r-davari92',style: TextStyle(fontSize: 13),),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16,left: 16,right: 16,bottom: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: (){
                        js.context.callMethod('open', ['https://github.com/m-r-davari/github_readme_beautifier']);
                      },
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Show some ❤️️ and support me with your stars ✨',style: TextStyle(fontSize: 13),),
                          Text('https://github.com/m-r-davari/github_readme_beautifier',style: TextStyle(color: Colors.blueAccent,fontSize: 13),),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8,),
                  const Text('You are welcomed to contribute, instead of copying the Idea or Code.',style: TextStyle(fontSize: 13)),
                  const SizedBox(height: 8,),//16
                  // const Text('How to use : ',style: TextStyle(fontWeight: FontWeight.bold),),
                  // const Padding(
                  //   padding: EdgeInsets.all(8),
                  //   child: Text(
                  //       '1 - Go to your desire widget page.\n'
                  //       '2 - Generate your contents.\n'
                  //       '3 - Press Export button to download contents.\n'
                  //       '4 - Upload the the dark/light content and add it your github readme.'
                  //   ),
                  // ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: (){
                        js.context.callMethod('open', ['https://github.com/m-r-davari/github_readme_beautifier']);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(0),//8
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(child: Text('How to use?',style: TextStyle(fontSize: 13))),
                            SizedBox(width: 4,),
                            Icon(Icons.outbond_outlined,size: 16,color: Colors.blueAccent,)
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const Divider(indent: 10,endIndent: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 16,right: 16,bottom: 16,top: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //const SizedBox(height: 16,),
                  const Text('My Other Repos : ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13),),
                  Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Visit my other Repos & support me with your pub.dev likes and github stars.',style: TextStyle(fontSize: 13)),
                          const SizedBox(height: 8,),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: InkWell(
                              onTap: ()async{
                                js.context.callMethod('open', ['https://pub.dev/packages/flutter_3d_controller']);
                                await Future.delayed(const Duration(milliseconds: 100));
                                js.context.callMethod('open', ['https://github.com/m-r-davari/flutter_3d_controller']);
                              },
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('Flutter 3D Controller',style: TextStyle(color: Colors.blueAccent,fontSize: 13,fontWeight: FontWeight.bold)),
                                      SizedBox(width: 4,),
                                      Icon(Icons.outbond_outlined,size: 16,color: Colors.blueAccent,)
                                    ],
                                  ),
                                  Text('A Flutter package for rendering interactive 3D models in different formats(glb, gltf, fbx, obj), with ability to control animations, textures and camera.',style: TextStyle(fontSize: 13))
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 8,),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: InkWell(
                              onTap: ()async{
                                js.context.callMethod('open', ['https://pub.dev/packages/common_utilities']);
                                await Future.delayed(const Duration(milliseconds: 100));
                                js.context.callMethod('open', ['https://github.com/m-r-davari/dart_common_utilities']);
                              },
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('Common Utilities',style: TextStyle(color: Colors.blueAccent,fontSize: 13,fontWeight: FontWeight.bold)),
                                      SizedBox(width: 4,),
                                      Icon(Icons.outbond_outlined,size: 16,color: Colors.blueAccent,)
                                    ],
                                  ),
                                  Text('A Dart language Common Utility package, that makes your code faster,easier and cleaner. contains lots of useful functions for Dart primitive types (support all Flutter platforms)',style: TextStyle(fontSize: 13))
                                ],
                              ),
                            ),
                          )
                        ],
                      )
                  )
                ],
              ),
            )

          ],
        ),
      ),
    );
  }
}
