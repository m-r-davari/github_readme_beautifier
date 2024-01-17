import 'dart:convert';

import 'package:github_readme_beautifier/core/network_manager/i_nework_manager.dart';
import 'package:github_readme_beautifier/data/git_repos/datasource/i_git_repos.dart';
import 'package:github_readme_beautifier/data/most_used_languages/datasource/i_most_used_languages_datasource.dart';
import 'package:github_readme_beautifier/data/repos_languages_overview/datasource/i_repos_languages_overview_datasource.dart';

class ReposLanguagesOverviewDatasource extends IReposLanguagesOverviewDatasource{

  final INetworkManager networkManager;
  final IGitReposRemoteDataSource reposDataSource;
  ReposLanguagesOverviewDatasource({required this.networkManager,required this.reposDataSource});

  @override
  Future<Map<String,int>> getReposLanguagesOverview({required String userName})async{
    final allRepos = await reposDataSource.getUserGitRepos(userName: userName);
    final validRepos = allRepos.where((element) => element.language != null && element.languagesUrl != null && element.languagesUrl!.isNotEmpty).toList();
    List<Future> reposLangFutures = [];

    for(int i=0; i<validRepos.length; i++){
      reposLangFutures.add(networkManager.getRequest(path: validRepos[i].languagesUrl!));
      if(i==10){
        break;
      }
    }

    // Assuming reposLangsRawData is a List<dynamic>
    List<dynamic> reposLangsRawData = (await Future.wait(reposLangFutures));
    // Convert to JSON string
    String apiResponse = jsonEncode(reposLangsRawData);
    // Now you can use the parseApiResponse function from the previous example
    List<Map<String, int>> allReposRawMapList = parseApiResponse(apiResponse);
    // generate repos langs percent list
    List<Map<String,int>> reposLangsPercentList = [];
    for (Map<String, int> repoRawMap in allReposRawMapList) {
      int sumOfvalues = repoRawMap.values.toList().fold(0, (previousValue, element) => previousValue + element);
      Map<String,int> repoPercentMap = {};
      for(final langRawMap in repoRawMap.entries.toList()){
        repoPercentMap[langRawMap.key] = (langRawMap.value / sumOfvalues * 100).toInt();
      }
      reposLangsPercentList.add(repoPercentMap);
    }
    
    //print('---repos raw data---- $reposLangsRawData ----');
    print('---repos percens data---- $reposLangsPercentList ----');

    return {'DDD':10};
    //throw UnimplementedError();
  }


  List<Map<String, int>> parseApiResponse(String apiResponse) {
    List<Map<String, int>> dataList = [];

    try {
      // Parse the JSON string
      List<dynamic> jsonList = jsonDecode(apiResponse);

      // Convert each element of the list to a Map<String, int>
      for (dynamic element in jsonList) {
        if (element is Map<String, dynamic>) {
          Map<String, int> intMap = {};
          element.forEach((key, value) {
            if (value is int) {
              intMap[key.toLowerCase()] = value;
            }
          });
          dataList.add(intMap);
        }
      }
    } catch (e) {
      print('Error parsing API response: $e');
    }

    return dataList;
  }


}