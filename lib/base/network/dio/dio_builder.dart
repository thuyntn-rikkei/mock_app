import 'package:dio/dio.dart';
import 'package:base_bloc_3/base/network/dio/dio_interceptor.dart';
import 'package:base_bloc_3/common/config/default_config.dart';
import 'package:base_bloc_3/common/config/index.dart';
import 'package:base_bloc_3/common/logger/index.dart';

class DioBuilder {
  Dio? dio;

  Dio getDio() {
    if (dio == null) {
      final BaseOptions options = BaseOptions(
        baseUrl: getUrl(),
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: ApiConfig.connectTimeout),
        receiveTimeout: const Duration(seconds: ApiConfig.receiveTimeout),
        headers: {"accept": "application/json"},
      );
      dio = Dio(options);
      dio?.options.headers['content-Type'] = 'application/json';
      dio?.interceptors.addAll(
        [
          PrettyDioLogger(
            requestHeader: true,
            requestBody: true,
            responseHeader: false,
            responseBody: false,
          ),
          DioInterceptor(),
        ],
      );
    }
    return dio!;
  }

  String getUrl() {
    return DefaultConfig.getBaseUrl;
  }
}
