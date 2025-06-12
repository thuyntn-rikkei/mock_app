import 'package:base_bloc_3/common/external_lib.dart';
import 'package:base_bloc_3/data/model/message/image_message_model.dart';
import 'package:base_bloc_3/data/model/message/message_model.dart';
import 'package:base_bloc_3/data/model/message/message_type_enum.dart';
import 'package:base_bloc_3/data/model/message/text_message_model.dart';

class MessageModelConverter implements JsonConverter<MessageModel, Map<String, dynamic>> {
  const MessageModelConverter();

  @override
  MessageModel fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case MessageType.text:
        return TextMessageModel(
          messageId: json['messageId'],
          conversationId: json['conversationId'],
          senderId: json['senderId'],
          receiverId: json['receiverId'],
          isRead: json['isRead'],
          timestamp: json['timestamp'],
          text: json['text'],
        );
      case MessageType.image:
        return ImageMessageModel(
          messageId: json['messageId'],
          conversationId: json['conversationId'],
          senderId: json['senderId'],
          receiverId: json['receiverId'],
          isRead: json['isRead'],
          timestamp: json['timestamp'],
          imageUrl: json['imageUrl'],
        );
      default:
        throw UnimplementedError('Unknown message type: ${json['type']}');
    }
  }

  @override
  Map<String, dynamic> toJson(MessageModel object){
    switch (object.runtimeType) {
      case TextMessageModel:
        return (object as TextMessageModel).toJson();
      case ImageMessageModel:
        return (object as ImageMessageModel).toJson();
      default:
        throw UnimplementedError('Unknown message type: ${object.runtimeType}');
    }
  }
}