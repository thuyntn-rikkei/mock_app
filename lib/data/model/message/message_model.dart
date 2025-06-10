abstract class MessageModel {
  String? get messageId;
  String? get conversationId;
  String? get senderId;
  String? get receiverId;
  bool? get isRead;
  int? get timestamp;
}
