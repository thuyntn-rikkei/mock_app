import 'package:base_bloc_3/data/model/authen/auth_token.dart';
import 'package:base_bloc_3/import.dart';

abstract class AuthenRepository {
  Future<Either<BaseError, AuthToken>> login(LoginRequest loginRequest);
  Future<Either<BaseError, void>> register(RegisterRequest registerRequest);
}
