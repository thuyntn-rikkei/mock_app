import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:base_bloc_3/base/network/constants/constants.dart';
import 'package:base_bloc_3/base/network/errors/error.dart';
import 'package:base_bloc_3/base/network/errors/error_response.dart';

extension DioErrorMessage on DioException {
  BaseError get baseError {
    BaseError errorMessage = BaseError.httpUnknownError("error_system".tr());
    switch (type) {
      case DioExceptionType.cancel:
        errorMessage = BaseError.httpUnknownError("dio_cancel_request".tr());
        break;
      case DioExceptionType.connectionTimeout:
        errorMessage = BaseError.httpUnknownError("dio_cancel_request".tr());
        break;
      case DioExceptionType.unknown:
        if (error != null && error is SocketException) {
          errorMessage =
              BaseError.httpInternalServerError('no_internet_access'.tr());
        }
        break;
      case DioExceptionType.receiveTimeout:
        errorMessage = BaseError.httpUnknownError("dio_cancel_request".tr());
        break;
      case DioExceptionType.sendTimeout:
        errorMessage = BaseError.httpUnknownError("dio_cancel_request".tr());
        break;
      case DioExceptionType.badResponse:
        try {
          ErrorResponse errorResponse = ErrorResponse.fromJson(response?.data);
          final code = errorResponse.data?.errors?.first.errorCode;
          if (code == StatusCodeEnum.unauthorized) {
            errorMessage = const BaseError.httpUnAuthorizedError();

            ///Call event app_hash expired
          } else {
            errorMessage = code?.message ??
                BaseError.httpInternalServerError("error_system".tr());
          }
        } catch (e) {
          errorMessage = BaseError.httpInternalServerError("error_system".tr());
        }

        //handle refresh Token
        // if (error.type == StatusCode.refreshToken){
        //   await refreshToken(error);
        //   return;
        // }
        break;
      default:
        errorMessage = BaseError.httpUnknownError("error_system".tr());
        break;
    }
    return errorMessage;
  }
}

extension BaseErrorMessage on BaseError {
  String get getErrorString {
    if (this is HttpInternalServerError) {
      return (this as HttpInternalServerError).errorBody;
    } else if (this is HttpUnAuthorizedError) {
      return "error_system".tr();
    } else if (this is HttpUnknownError) {
      return (this as HttpUnknownError).message;
    }
    return "error_system".tr(); //todo: specify error string
  }
}
