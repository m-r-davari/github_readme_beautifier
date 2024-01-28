
abstract class IMostUsedLanguagesRemoteDatasource {
  Future<Map<String,int>> getMostUsedLanguages({required String userName});
}