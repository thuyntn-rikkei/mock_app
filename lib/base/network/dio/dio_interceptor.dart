import 'package:dio/dio.dart';

class DioInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final Map<String, dynamic> header = {};
    header["X-RapidAPI-Key"] =
        "78d211523bmsh34d9b38775ea89bp1f0570jsn3659220c752a";
    header["X-RapidAPI-Host"] = "free-nba.p.rapidapi.com";
    options.headers.addAll(header);
    super.onRequest(options, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    // ErrorHandling.withError(error: err);
    super.onError(err, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
  }
}
