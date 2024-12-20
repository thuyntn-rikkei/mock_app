import 'package:easy_localization/easy_localization.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:base_bloc_3/base/network/errors/error.dart';

class StatusCode {
  static const int verifyOtpError = 117;
  static const int error = 400;
  static const int unauthorized = 401;
  static const int notFound = 404;
  static const int permissionDenied = 403;
}

enum StatusCodeEnum {
  @JsonValue(StatusCode.verifyOtpError)
  verifyOtpError,
  @JsonValue(StatusCode.error)
  error,
  @JsonValue(StatusCode.unauthorized)
  unauthorized,
  @JsonValue(StatusCode.notFound)
  notFound,
  @JsonValue(StatusCode.permissionDenied)
  permissionDenied;
}

extension StatusCodeEnumExtension on StatusCodeEnum {
  BaseError get message {
    switch (this) {
      case StatusCodeEnum.verifyOtpError:
        return BaseError.httpInternalServerError("invalid_otp".tr());
      case StatusCodeEnum.error:
        return BaseError.httpInternalServerError("error_system".tr());
      case StatusCodeEnum.unauthorized:
        return const BaseError.httpUnAuthorizedError();
      case StatusCodeEnum.notFound:
        return BaseError.httpInternalServerError("not_found".tr());
      case StatusCodeEnum.permissionDenied:
        return BaseError.httpInternalServerError("permission_denied".tr());
    }
  }
}
