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

  @override
  void initState() {
    textEditingController.text = '0x48415a484952';
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
                    message: 'UserName can not be empty',
                  ));
                  return;
                }
                userController.userName = textEditingController.text;
                Get.toNamed('/home_page');
              },
              isLoading: false,
            )
          ],
        ),
      ),
    );
  }
}
