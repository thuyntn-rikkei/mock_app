import 'package:base_bloc_3/base/network/errors/error.dart';
import 'package:base_bloc_3/features/conversation/domain/entity/friend_request_entity.dart';
import 'package:dartz/dartz.dart';

abstract class FriendRequestRepository {
  Future<Either<BaseError, FriendRequestEntity>> createFriendRequest(FriendRequestEntity friendRequestEntity);
  Future<Either<BaseError, List<FriendRequestEntity>>> fetchFriendRequestsByUserId(String userId);
  Future<Either<BaseError, FriendRequestEntity>> updateFriendRequest(String friendRequestId, FriendRequestEntity friendRequestEntity);
}