import 'package:base_bloc_3/data/model/authen/index.dart';
import 'package:base_bloc_3/import.dart';

abstract class AuthenRepository {
  Future<Either<BaseError, LoginSuccessModel>> login(LoginRequest loginRequest);
  Future<Either<BaseError, void>> register(RegisterRequest registerRequest);
}
