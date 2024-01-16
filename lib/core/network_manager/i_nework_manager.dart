abstract class INetworkManager {

  Future<dynamic> getRequest(
      {required String path,
        Map<String, String>? parameters,
        Map<String, String>? headers});

  Future<dynamic> postRequest(
      {required String path,
        Map<String, String>? parameters,
        dynamic body,
        Map<String, String>? headers});

}