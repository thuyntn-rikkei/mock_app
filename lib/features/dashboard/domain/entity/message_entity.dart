import 'package:base_bloc_3/data/model/message/image_message_model.dart';
import 'package:base_bloc_3/data/model/message/message_model.dart';
import 'package:base_bloc_3/data/model/message/message_type_enum.dart';
import 'package:base_bloc_3/data/model/message/text_message_model.dart';

abstract class MessageEntity {
  String messageId;
  String conversationId;
  String senderId;
  bool isRead;
  MessageType type;

  MessageEntity({
    required this.messageId,
    required this.conversationId,
    required this.senderId,
    required this.isRead,
    required this.type,
  });
}

class TextMessageEntity extends MessageEntity {
  String text;

  TextMessageEntity({
    required String messageId,
    required String conversationId,
    required String senderId,
    required bool isRead,
    required MessageType type,
    required this.text,
  }) : super(
          messageId: messageId,
          conversationId: conversationId,
          senderId: senderId,
          isRead: isRead,
          type: type,
        );

  factory TextMessageEntity.fromModel(MessageModel textModel) {
    var model = textModel as TextMessageModel;
    return TextMessageEntity(
      messageId: model.messageId,
      conversationId: model.conversationId ?? "",
      senderId: model.senderId ?? "",
      isRead: model.isRead ?? false,
      type: MessageType.text,
      text: model.text ?? "",
    );
  }
}

class ImageMessageEntity extends MessageEntity {
  String imageUrl;

  ImageMessageEntity({
    required String messageId,
    required String conversationId,
    required String senderId,
    required bool isRead,
    required MessageType type,
    required this.imageUrl,
  }) : super(
    messageId: messageId,
    conversationId: conversationId,
    senderId: senderId,
    isRead: isRead,
    type: type,
  );

  factory ImageMessageEntity.fromModel(MessageModel imageModel) {
    var model = imageModel as ImageMessageModel;
    return ImageMessageEntity(
      messageId: model.messageId,
      conversationId: model.conversationId ?? "",
      senderId: model.senderId ?? "",
      isRead: model.isRead ?? false,
      type: MessageType.image,
      imageUrl: model.imageUrl ?? "",
    );
  }
}