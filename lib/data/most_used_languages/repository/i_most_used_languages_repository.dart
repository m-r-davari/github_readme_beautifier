
abstract class IMostLanguagesRepository{
  Future<Map<String,int>> getMostLanguages({required String userName});
}