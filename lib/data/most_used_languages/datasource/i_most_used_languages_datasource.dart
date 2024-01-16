
abstract class IMostUsedLanguagesDatasource {
  Future<Map<String,int>> getMostUsedLanguages({required String userName});
}