import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:github_readme_beautifier/presentation/user/user_controller.dart';
import 'package:github_readme_beautifier/widgets/primary_button.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {

  final userController = Get.find<UserController>();
  final TextEditingController textEditingController = TextEditingController();
  bool mustDispose = false;

  @override
  void initState() {
    mustDispose = userController.userName.value.isNotEmpty;
    textEditingController.text = userController.userName.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('User Page'),
      ),
      body: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xffEDEDED),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: textEditingController,
                decoration: const InputDecoration.collapsed(hintText: 'Enter Your Github UserName'),
              ),
            ),
            const SizedBox(
              height: 26,
            ),
            PrimaryButton(
              text: 'Continue',
              onTap: (){
                if (textEditingController.text.isEmpty) {
                  Get.showSnackbar(const GetSnackBar(
                    title: 'Error',
                    message: 'Username can not be empty',
                    duration: Duration(seconds: 5),
                  ));
                  return;
                }
                Get.closeCurrentSnackbar();
                userController.userName.value = textEditingController.text;
                if(mustDispose){
                  Get.back();
                }
                else{
                  Get.offNamed('/home_page');
                }
              },
              isLoading: false,
            )
          ],
        ),
      ),
    );
  }
}
