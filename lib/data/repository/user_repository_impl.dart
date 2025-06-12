import 'package:base_bloc_3/base/index.dart';
import 'package:base_bloc_3/base/network/errors/error.dart';
import 'package:base_bloc_3/common/external_lib.dart';
import 'package:base_bloc_3/data/firebase/user/user_remote_datasource.dart';
import 'package:base_bloc_3/features/login/domain/entity/user_entity.dart';
import 'package:base_bloc_3/features/login/domain/repository/user_repository.dart';
import 'package:base_bloc_3/generated/l10n.dart';

@Injectable(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDatasource _userRemoteDatasource;
  UserRepositoryImpl(this._userRemoteDatasource);

  @override
  Future<Either<BaseError, void>> addNewUser(UserEntity userEntity) async {
    try {
      final result = await _userRemoteDatasource.createUser();
      return right(result);
    } on DioException catch (exception) {
      return left(exception.baseError);
    } catch (exception) {
      return left(BaseError.httpUnknownError(S.current.error_unknown));
    }
  }

  @override
  Future<Either<BaseError, bool>> logIn(String email, String password) async {
    try {
      final result = await _userRemoteDatasource.logIn(email, password);
      return right(result);
    } on FirebaseException catch (exception) {
      return left(BaseError.httpUnknownError(exception.message ?? S.current.error_unknown));
    } catch (exception) {
      return left(BaseError.httpUnknownError(S.current.error_unknown));
    }
  }

  @override
  Future<Either<BaseError, UserEntity>> signUp(String email, String password, String fullName) async{
    try {
      final result = await _userRemoteDatasource.signUp(email, password, fullName);
      if (result == null) {
        return left(BaseError.httpUnknownError(S.current.not_found));
      }
      return right(UserEntity.fromModel(result));
    } on FirebaseException catch (exception) {
      return left(BaseError.httpUnknownError(exception.message ?? S.current.error_unknown));
    } catch (exception) {
      return left(BaseError.httpUnknownError(S.current.error_unknown));
    }
  }
}