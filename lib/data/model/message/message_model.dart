import 'package:base_bloc_3/data/model/message/image_message_model.dart';
import 'package:base_bloc_3/data/model/message/message_type_enum.dart';
import 'package:base_bloc_3/data/model/message/text_message_model.dart';
import 'package:base_bloc_3/features/dashboard/domain/entity/message_entity.dart';

abstract class MessageModel {
  String? get messageId;
  String? get conversationId;
  String? get senderId;
  bool? get isRead;
  int? get timestamp;
  MessageType? get type;

  factory MessageModel.fromEntity(MessageEntity entity) {
    switch (entity.type) {
      case MessageType.text:
        return TextMessageModel.fromEntity(entity as TextMessageEntity);
      case MessageType.image:
        return ImageMessageModel.fromEntity(entity as ImageMessageEntity);
    }
  }


}

