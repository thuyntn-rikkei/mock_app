import 'package:base_bloc_3/data/model/authen/auth_token.dart';
import 'package:base_bloc_3/features/authen/domain/repository/authen_repository.dart';
import 'package:base_bloc_3/import.dart';

@Injectable(as: AuthenRepository)
class AuthenRepositoryRepoImpl implements AuthenRepository {
  final AuthenService _authenService;
  AuthenRepositoryRepoImpl(
    this._authenService,
  );

  @override
  Future<Either<BaseError, AuthToken>> login(
    LoginRequest loginRequest,
  ) async {
    try {
      final result = await _authenService.login(request: loginRequest);
      return right(result);
    } on DioException catch (exception) {
      return left(exception.baseError);
    } catch (exception) {
      return left(BaseError.httpUnknownError(S.current.error_unknown));
    }
  }

  @override
  Future<Either<BaseError, void>> register(
      RegisterRequest registerRequest) async {
    try {
      final result = await _authenService.register(request: registerRequest);
      return right(result);
    } on DioException catch (exception) {
      return left(exception.baseError);
    } catch (exception) {
      return left(BaseError.httpUnknownError(S.current.error_unknown));
    }
  }
}
