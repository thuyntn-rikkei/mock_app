part of 'conversation_details_bloc.dart';

@freezed
class ConversationDetailsEvent with _$ConversationDetailsEvent {
  const factory ConversationDetailsEvent.started() = _Started;
  const factory ConversationDetailsEvent.loadConversationDetails({required String conversationId}) = _LoadConversationDetails;
  const factory ConversationDetailsEvent.sendMessage({required String message, required String conversationId, required String senderId}) = _SendMessage;
  const factory ConversationDetailsEvent.receivedMessage({required MessageEntity message}) = _OnReceivedMessage;
  const factory ConversationDetailsEvent.listenToMessages({required String conversationId, required String currentUserId}) = _ListenToMessages;
  const factory ConversationDetailsEvent.getConversationDetails({required String conversationId}) = _GetConversationDetails;
  const factory ConversationDetailsEvent.getMembers({required Set<String> memberIds}) = _GetMembers;
}
