import 'package:base_bloc_3/import.dart';
part 'auth_token.freezed.dart';
part 'auth_token.g.dart';

AuthToken authTokenFromJson(String str) => AuthToken.fromJson(json.decode(str));

String authTokenToJson(AuthToken data) => json.encode(data.toJson());

@freezed
class AuthToken with _$AuthToken {
  const factory AuthToken({
    String? accessToken,
    String? refreshToken,
    String? tokenType,
    String? expiresIn,
  }) = _AuthToken;

  factory AuthToken.fromJson(Map<String, dynamic> json) => _$AuthTokenFromJson(json);
}
