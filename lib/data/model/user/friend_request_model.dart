
import 'package:base_bloc_3/features/conversation/domain/entity/friend_request_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'friend_request_model.freezed.dart';
part 'friend_request_model.g.dart';

@freezed
class FriendRequestModel with _$FriendRequestModel {
  const factory FriendRequestModel({
    String? friendRequestId,
    String? userId,
    String? friendRequestUserId,
    String? status,
  } ) = _FriendRequestModel;

  factory FriendRequestModel.fromJson(Map<String, dynamic> json) => _$FriendRequestModelFromJson(json);

  factory FriendRequestModel.fromEntity(FriendRequestEntity entity) {
    return FriendRequestModel(
      friendRequestId: entity.friendRequestId,
      userId: entity.userId,
      friendRequestUserId: entity.friendRequestUserId,
      status: entity.status.name,
    );
  }
}
