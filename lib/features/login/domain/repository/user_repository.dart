import 'package:base_bloc_3/base/network/errors/error.dart';
import 'package:base_bloc_3/features/login/domain/entity/user_entity.dart';
import 'package:dartz/dartz.dart';

abstract class UserRepository {
  Future<Either<BaseError, void>> addNewUser(UserEntity userEntity);
  Future<Either<BaseError, UserEntity?>> logIn(String email, String password);
  Future<Either<BaseError, UserEntity>> signUp(String email, String password, String fullName);
}
