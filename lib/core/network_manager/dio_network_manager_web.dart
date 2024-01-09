import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'i_nework_manager.dart';


class DioNetworkManager extends INetworkManager {

  final _connectionTimeout = 30000;
  final _receiveTimeout = 30000;
  late Dio _dio;
  BaseOptions? options;
  String baseUrl;

  DioNetworkManager({required this.baseUrl}) {
    options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: Duration(milliseconds: _connectionTimeout),
      receiveTimeout: Duration(milliseconds: _receiveTimeout),
      sendTimeout: Duration(milliseconds: _receiveTimeout),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'accept-charset': 'UTF-8',
      },
    );
    _dio = Dio(options);
    setInterceptor();
  }

  void setInterceptor() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, handler) async {
          return handler.next(options);
        },
        onResponse: (Response response, handler) async {
          return handler.next(response);
        },
        onError: (DioException err, handler) async {
          print("Error on dio ${err.response}");
          switch (err.type) {
            case DioExceptionType.receiveTimeout ://DioErrorType.receiveTimeout:
              return handler.next(DioError(
                requestOptions: err.requestOptions,
                response: err.response,
                error: "Connection Problem",
              ));
              break;
            case DioExceptionType.connectionTimeout:
              return handler.next(DioException(
                requestOptions: err.requestOptions,
                response: err.response,
                error: "Connection Problem",
              ));
              break;
            case DioExceptionType.sendTimeout:
              return handler
                  .next(DioException(requestOptions: err.requestOptions, response: err.response, error: "Check Internet Connection"));
              break;
            case DioExceptionType.unknown:
              return handler.next(
                  DioException(requestOptions: err.requestOptions, response: err.response, error: "Failed to Connect to Server"));
              break;
            case DioExceptionType.cancel:
              return handler.next(DioException(
                requestOptions: err.requestOptions,
                response: err.response,
                error: "Request has been canceled",
              ));
              break;
            default :
              return handler.next(DioException(
              requestOptions: err.requestOptions,
              response: err.response,
              error: "Something went wrong",
            ));
          }
          return handler.next(err);
        },
      ), //
    );
    _dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: true,
        error: true,
        compact: true,
        maxWidth: 90));
  }

  @override
  Future<dynamic> getRequest(
      {required String path, Map<String, dynamic>? parameters,  Map<String, String>? headers}) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: parameters,
        options: Options(headers: headers),
      );
      return response.data;
    } on DioException catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> postRequest(
      {required String path, Map<String, String>? parameters, body, Map<String, String>? headers}) async {
    try {
      final response = await _dio.post(
        path,
        data: body,
        options: Options(headers: headers),
      );
      return response.data;
    } on DioException catch (e) {
      rethrow;
    }
  }

}
