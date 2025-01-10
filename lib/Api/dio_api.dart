import 'package:dio/dio.dart';
import 'package:laundry/Api/config.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class Api {
  final Dio _dio = Dio();
  Api() {
    _dio.options.baseUrl = Config.path;
    _dio.options.headers = {
      'Content-Type': 'application/json',
    };
    _dio.options.responseType = ResponseType.plain;
    _dio.interceptors.add(
        PrettyDioLogger(requestBody: true, responseBody: true, error: true));
  }
  Dio get sendRequest => _dio;
}
