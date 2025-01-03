import 'package:base_bloc_3/import.dart';

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
          TalkerDioLogger(
            talker: getIt<Talker>(),
          ),
          DioInterceptor(dio),
        ],
      );
    }
    return dio!;
  }

  String getUrl() {
    return DefaultConfig.getBaseUrl;
  }
}
