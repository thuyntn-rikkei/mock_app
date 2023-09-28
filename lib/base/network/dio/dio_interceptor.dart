import 'package:dio/dio.dart';

class DioInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // ErrorHandling.withError(error: err);
    super.onError(err, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    ///valid response
    if (response.statusCode == 200 &&
        response.data != null &&
        response.data is Map &&
        response.data["data"] != null) {
      //if response has any error
      if (response.data["data"] is Map &&
          response.data["data"]["errors"] != null) {
        return handler.reject(
          DioException(
            type: DioExceptionType.badResponse,
            requestOptions: response.requestOptions,
            response: response,
          ),
        );
      }
    }
    super.onResponse(response, handler);
  }
}
