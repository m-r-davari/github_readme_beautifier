import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:github_readme_beautifier/core/di/app_bindings.dart';
import 'package:github_readme_beautifier/core/network_manager/i_nework_manager.dart';
import 'package:github_readme_beautifier/data/git_repos/datasource/i_git_repos_remote_datasource.dart';
import 'package:github_readme_beautifier/data/github_friends/datasource/github_firends_remote_datasource.dart';
import 'package:github_readme_beautifier/data/github_friends/datasource/i_github_friends_remoted_datasource.dart';
import 'package:github_readme_beautifier/data/github_friends/repository/github_firends_repository.dart';
import 'package:github_readme_beautifier/data/github_friends/repository/i_github_friends_repository.dart';
import 'package:github_readme_beautifier/data/most_used_languages/datasource/i_most_used_languages_remote_datasource.dart';
import 'package:github_readme_beautifier/data/most_used_languages/datasource/most_used_languages_remote_datasource.dart';
import 'package:github_readme_beautifier/data/most_used_languages/repository/i_most_used_languages_repository.dart';
import 'package:github_readme_beautifier/data/most_used_languages/repository/most_languages_repository.dart';
import 'package:github_readme_beautifier/data/repos_languages_overview/datasource/i_repos_languages_overview_remote_datasource.dart';
import 'package:github_readme_beautifier/data/repos_languages_overview/datasource/repos_languages_overview_remote_datasource.dart';
import 'package:github_readme_beautifier/data/repos_languages_overview/repository/i_repos_languages_overview_repository.dart';
import 'package:github_readme_beautifier/data/repos_languages_overview/repository/repos_languages_overview_repository.dart';
import 'package:github_readme_beautifier/presentation/github_friends/controllers/github_friends_controller.dart';
import 'package:github_readme_beautifier/presentation/github_meme/controllers/github_meme_controller.dart';
import 'package:github_readme_beautifier/presentation/github_meme/pages/github_meme_page.dart';
import 'package:github_readme_beautifier/home_page.dart';
import 'package:github_readme_beautifier/presentation/most_used_languages/controllers/most_used_languages_controller.dart';
import 'package:github_readme_beautifier/presentation/most_used_languages/pages/most_used_languages_pages.dart';
import 'package:github_readme_beautifier/presentation/repos_languages_overview/controllers/repos_languages_overview_controller.dart';
import 'package:github_readme_beautifier/presentation/repos_languages_overview/pages/repos_languages_overview_page.dart';
import 'package:github_readme_beautifier/presentation/user/user_page.dart';
import 'package:github_readme_beautifier/splash_page.dart';
import 'package:github_readme_beautifier/presentation/typewriter_text/controllers/typewriter_controller.dart';
import 'package:github_readme_beautifier/presentation/typewriter_text/pages/typewriter_export_page.dart';
import 'package:github_readme_beautifier/presentation/typewriter_text/pages/typewriter_text_page.dart';

import 'presentation/github_friends/pages/github_friends_list_page.dart';

void main()async{
  AppBindings appBindings = AppBindings();
  runApp(MyApp(appBindings: appBindings,));
}

class MyApp extends StatelessWidget {
  MyApp({super.key,required this.appBindings});
  final AppBindings appBindings;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Github Readme Beautifier',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      getPages: [
        GetPage(
            name: "/splash_page",
            page: () => const SplashPage(),
            transition: Transition.fade,
        ),
        GetPage(
          name: "/user_page",
          page: () => const UserPage(),
          transition: Transition.fade,
        ),
        GetPage(
          name: "/home_page",
          page: () => const HomePage(),
          transition: Transition.fade,
        )
        ,
        GetPage(
          name: "/meme_page",
          page: () => const GithubMemePage(),
          transition: Transition.fade,
          binding: BindingsBuilder(() {
            Get.put(GithubMemeController());
          }),
        )
        ,
        GetPage(
          name: "/typewriter_page",
          page: () => const TypewriterTextPage(),
          transition: Transition.fade,
          binding: BindingsBuilder(() {
            Get.put(TypeWriterController());
          }),
        )
        ,
        GetPage(
          name: "/typewriter_export_page",
          page: () => const TypewriterExportPage(),
          transition: Transition.fade,
          // binding: BindingsBuilder(() {
          //   Get.put(TypeWriterController());
          // }),
        )
        ,
        GetPage(
          name: "/most_used_languages_page",
          page: () => const MostUsedLanguagesPage(),
          transition: Transition.fade,
          binding: BindingsBuilder(() {
            Get.put<IMostUsedLanguagesRemoteDatasource>(MostUsedLanguagesRemoteDatasource(networkManager: Get.find<INetworkManager>(), reposDataSource: Get.find<IGitReposRemoteDataSource>()));
            Get.put<IMostLanguagesRepository>(MostLanguagesRepository(datasource: Get.find<IMostUsedLanguagesRemoteDatasource>()));
            Get.put<MostUsedLanguagesController>(MostUsedLanguagesController());
          }),
        )
        ,
        GetPage(
          name: "/repos_languages_overview_page",
          page: () => const ReposLanguagesOverviewPage(),
          transition: Transition.fade,
          binding: BindingsBuilder(() {
            Get.put<IReposLanguagesOverviewRemoteDatasource>(ReposLanguagesOverviewRemoteDatasource(networkManager: Get.find<INetworkManager>(), reposDataSource: Get.find<IGitReposRemoteDataSource>()));
            Get.put<IReposLanguagesOverviewRepository>(ReposLanguagesOverviewRepository(datasource: Get.find<IReposLanguagesOverviewRemoteDatasource>()));
            Get.put<ReposLanguagesOverviewController>(ReposLanguagesOverviewController());
          }),
        )
        ,
        GetPage(
          name: "/github_friends_list_page",
          page: () => const GithubFriendsListPage(),
          transition: Transition.fade,
          binding: BindingsBuilder(() {
            Get.put<IGithubFriendsRemoteDatasource>(GithubFriendsRemoteDatasource(networkManager: Get.find<INetworkManager>()));
            Get.put<IGithubFriendsRepository>(GithubFriendsRepository(datasource: Get.find<IGithubFriendsRemoteDatasource>()));
            Get.put(GithubFriendsController());
          }),
        )

      ],
      initialRoute: "/splash_page",
      initialBinding: appBindings,
      //home: const SplashPage(),

    );
  }

}