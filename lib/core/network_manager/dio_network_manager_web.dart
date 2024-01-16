import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:github_readme_beautifier/core/exceptions/exceptions.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'i_nework_manager.dart';

class DioNetworkManager extends INetworkManager {
  final _connectionTimeout = 5000;
  final _receiveTimeout = 5000;
  final _sendTimeout = 5000;
  late Dio _dio;
  late BaseOptions options;
  String baseUrl;

  DioNetworkManager({required this.baseUrl}) {
    options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: Duration(milliseconds: _connectionTimeout),
      receiveTimeout: Duration(milliseconds: _receiveTimeout),
      sendTimeout: Duration(milliseconds: _sendTimeout),
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
          print("Error on dio ${err.response}, ${err.type}");
          switch (err.type) {
            case DioExceptionType.receiveTimeout:
              return handler.next(DioException(
                requestOptions: err.requestOptions,
                response: err.response,
                message: "Receive Connection Timeout",
              ));
              break;
            case DioExceptionType.connectionTimeout:
              return handler.next(DioException(
                requestOptions: err.requestOptions,
                response: err.response,
                message: "Connection Timeout",
              ));
            case DioExceptionType.sendTimeout:
              return handler.next(DioException(
                requestOptions: err.requestOptions,
                response: err.response,
                message: "Send Connection Timeout",
              ));
            case DioExceptionType.cancel:
              return handler.next(DioException(
                requestOptions: err.requestOptions,
                response: err.response,
                message: "Request has been canceled",
              ));
            case DioExceptionType.badResponse:
              return handler.next(DioException(
                requestOptions: err.requestOptions,
                response: err.response,
                message: '${err.response?.data['message'] ?? err.message}'//err.response?.statusMessage,
              ));
            default:
              return handler.next(DioException(
                requestOptions: err.requestOptions,
                response: err.response,
                message: "Unknown Network Error",
              ));
          }
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
  Future<dynamic> getRequest({required String path, Map<String, dynamic>? parameters, Map<String, String>? headers}) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: parameters,
        options: Options(headers: headers),
      );
      return response.data;
    } on DioException catch (e) {
      throw NetworkException(code: e.response?.statusCode, message: e.message);
    }
  }

  @override
  Future<dynamic> postRequest({required String path, Map<String, String>? parameters, body, Map<String, String>? headers}) async {
    try {
      final response = await _dio.post(
        path,
        data: body,
        options: Options(headers: headers),
      );
      return response.data;
    } on DioException catch (e) {
      throw NetworkException(code: e.response?.statusCode, message: e.message);
    }
  }



}
