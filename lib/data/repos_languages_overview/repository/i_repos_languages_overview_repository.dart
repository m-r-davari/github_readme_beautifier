
abstract class IReposLanguagesOverviewRepository{
  Future<Map<String,int>> getReposLanguagesOverview({required String userName});
}