import 'package:base_bloc_3/base/network/errors/error.dart';
import 'package:base_bloc_3/common/external_lib.dart';
import 'package:base_bloc_3/data/firebase/user/friend_request_remote_datasource.dart';
import 'package:base_bloc_3/data/model/user/friend_request_model.dart';
import 'package:base_bloc_3/features/conversation/domain/entity/friend_request_entity.dart';
import 'package:base_bloc_3/features/conversation/domain/repository/friend_request_repository.dart';
import 'package:base_bloc_3/generated/l10n.dart';

@Injectable(as: FriendRequestRepository)
class FriendRequestRepositoryImpl implements FriendRequestRepository {
  final FriendRequestRemoteDatasource _friendRequestRemoteDatasource;
  FriendRequestRepositoryImpl(this._friendRequestRemoteDatasource);

  @override
  Future<Either<BaseError, FriendRequestEntity>> createFriendRequest(FriendRequestEntity friendRequestEntity) async {
    try {
      final result = await _friendRequestRemoteDatasource.createFriendRequest(FriendRequestModel.fromEntity(friendRequestEntity));
      if (result == null) {
        return left(BaseError.httpUnknownError(S.current.not_found));
      }
      return right(FriendRequestEntity.fromModel(result));
    } on FirebaseException catch (exception) {
      return left(BaseError.httpUnknownError(exception.message ?? S.current.error_unknown));
    } catch (exception) {
      return left(BaseError.httpUnknownError(S.current.error_unknown));
    }
  }

  @override
  Future<Either<BaseError, List<FriendRequestEntity>>> fetchFriendRequestsByUserId(String userId) async {
    try {
      final result = await _friendRequestRemoteDatasource.fetchFriendRequestsByUserId(userId);
      return right(result.map((e) => FriendRequestEntity.fromModel(e)).toList());
    } on FirebaseException catch (exception) {
      return left(BaseError.httpUnknownError(exception.message ?? S.current.error_unknown));
    } catch (exception) {
      return left(BaseError.httpUnknownError(S.current.error_unknown));
    }
  }

  @override
  Future<Either<BaseError, FriendRequestEntity>> updateFriendRequest(String friendRequestId, FriendRequestEntity friendRequestEntity) async {
    try {
      final result = await _friendRequestRemoteDatasource.updateFriendRequest(friendRequestId, FriendRequestModel.fromEntity(friendRequestEntity));
      if (result == null) {
        return left(BaseError.httpUnknownError(S.current.not_found));
      }
      return right(FriendRequestEntity.fromModel(result));
    } on FirebaseException catch (exception) {
      return left(BaseError.httpUnknownError(exception.message ?? S.current.error_unknown));
    } catch (exception) {
      return left(BaseError.httpUnknownError(S.current.error_unknown));
    }
  }
}