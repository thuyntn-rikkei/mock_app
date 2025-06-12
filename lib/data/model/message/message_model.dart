import 'package:base_bloc_3/data/model/message/message_type_enum.dart';

abstract class MessageModel {
  String? get messageId;
  String? get conversationId;
  String? get senderId;
  String? get receiverId;
  bool? get isRead;
  int? get timestamp;
  MessageType? get type;
}
