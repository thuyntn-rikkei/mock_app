import 'package:base_bloc_3/common/constants/friend_request_status.dart';
import 'package:base_bloc_3/data/model/user/friend_request_model.dart';

class FriendRequestEntity{
  String friendRequestId;
  String userId;
  String friendRequestUserId;
  FriendRequestStatus status;


  FriendRequestEntity({
    required this.friendRequestId,
    required this.userId,
    required this.friendRequestUserId,
    required this.status,
  });

  factory FriendRequestEntity.fromModel(FriendRequestModel model) {
    return FriendRequestEntity(
      friendRequestId: model.friendRequestId ?? "",
      userId: model.userId ?? "",
      friendRequestUserId: model.friendRequestUserId ?? "",
      status: FriendRequestStatus.values.firstWhere((element) => element.name == model.status),
    );
  }
}