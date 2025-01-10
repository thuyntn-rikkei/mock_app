import 'package:base_bloc_3/features/authen/presentation/bloc/auth_bloc.dart';
import 'package:base_bloc_3/import.dart';

class DioInterceptor extends Interceptor {
  final Dio? dio;

  DioInterceptor(this.dio);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handleError(err, handler);
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

  Future<void> handleError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // check connection
    if (err.type == DioExceptionType.unknown) {
      final connectivityResult =
          await getIt<Connectivity>().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        err = err.copyWith(message: S.current.no_internet_access);
        super.onError(err, handler);
      }
    }

    //check unAuthorization error
    if (StatusCode.unauthorized == err.response?.statusCode) {
      //check if request option contains retry then logout else retry
      if (err.requestOptions.extra.containsKey(KeyRequest.retry)) {
        navigateToLogin();
      } else {
        err.requestOptions.extra[KeyRequest.retry] = true;
        AuthenService? authService = getIt<AuthenService>();
        LocalStorage localStorage = getIt<LocalStorage>();
        final refreshToken =
            await localStorage.get<String>(SharePrefConstants.refreshToken);
        // if refreshToken is null, call event app_hash expired
        if (refreshToken != null && refreshToken.isNotEmpty == true) {
          authService.refreshToken(refreshToken).then((response) async {
            if (response.data != null &&
                response.status == StatusCode.success) {
              //save token
              final newToken = response.data?.accessToken;
              final newRefreshToken = response.data?.refreshToken;
              localStorage.save(SharePrefConstants.accessToken, newToken);
              localStorage.save(
                SharePrefConstants.refreshToken,
                newRefreshToken,
              );

              //retry request
              try {
                err.requestOptions.headers[KeyRequest.authorization] =
                    "${KeyRequest.bearer} $newToken";
                final responseRefresh = await dio?.fetch(err.requestOptions);
                if (responseRefresh != null) {
                  handler.resolve(responseRefresh);
                }
              } on DioException catch (e) {
                handler.reject(e);
              }
            } else {
              navigateToLogin();
            }
          }).catchError((e) {
            handler.reject(e);
          });
        } else {
          navigateToLogin();
        }
      }
    } else {
      handler.next(err);
    }
  }

  void navigateToLogin() {
    //clear token
    //go to login
    getIt<AuthBloc>().add(const AuthEvent.onLogoutEvent());
  }
}
