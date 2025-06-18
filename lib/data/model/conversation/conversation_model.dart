import 'package:base_bloc_3/data/model/message/message_model_converter.dart';
import 'package:base_bloc_3/data/model/message/message_model.dart';
import 'package:base_bloc_3/data/model/user/user_model.dart';
import 'package:base_bloc_3/features/dashboard/domain/entity/conversation_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'conversation_model.freezed.dart';

part 'conversation_model.g.dart';

@freezed
class ConversationModel with _$ConversationModel {
  const factory ConversationModel(
    String conversationId, {
    int? createdTimestamp,
    int? updatedTimestamp,
    @MessageModelConverter() MessageModel? lastMessage,
    Map<String, bool>? memberIds,
  }) = _ConversationModel;

  factory ConversationModel.fromJson(Map<String, dynamic> json) =>
      _$ConversationModelFromJson(json);

  factory ConversationModel.fromEntity(ConversationEntity entity) {
    return ConversationModel(
      entity.conversationId,
      lastMessage: entity.lastMessage != null
          ? MessageModel.fromEntity(entity.lastMessage!)
          : null,
      memberIds: entity.memberIds,
    );
  }
}
