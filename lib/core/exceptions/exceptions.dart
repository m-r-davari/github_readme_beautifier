abstract class BaseException implements Exception {
  String message;
  BaseException({required this.message});
}

class GeneralException extends BaseException {
  GeneralException({required String? message}) : super(message: message ?? 'Something Went Wrong');
  @override
  String get message => super.message;

  @override
  set message(String _message) {
    super.message = _message;
  }
}


class NetworkException extends BaseException {
  int? code;
  NetworkException({this.code,required String? message}) : super(message: message ?? 'Network Failure');

  @override
  set message(String _message) {
    super.message = _message;
  }
  @override
  String get message => super.message;
}