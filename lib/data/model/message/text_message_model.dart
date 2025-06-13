import 'package:base_bloc_3/data/model/message/message_model.dart';
import 'package:base_bloc_3/data/model/message/message_type_enum.dart';
import 'package:base_bloc_3/features/dashboard/domain/entity/message_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'text_message_model.freezed.dart';

part 'text_message_model.g.dart';

@freezed
class TextMessageModel with _$TextMessageModel implements MessageModel {
  const factory TextMessageModel({
    required String messageId,
    String? conversationId,
    String? senderId,
    String? receiverId,
    bool? isRead,
    int? timestamp,
    String? text,
    MessageType? type,
  }) = _TextMessageModel;

  factory TextMessageModel.fromJson(Map<String, dynamic> json) =>
      _$TextMessageModelFromJson(json);

  factory TextMessageModel.fromEntity(TextMessageEntity entity) {
    return TextMessageModel(
      messageId: entity.messageId,
      conversationId: entity.conversationId,
      senderId: entity.senderId,
      receiverId: entity.receiverId,
      isRead: entity.isRead,
      text: entity.text,
      type: entity.type,
    );
  }
}
