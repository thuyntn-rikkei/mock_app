part of 'message_list_bloc.dart';

@freezed
class MessageListEvent with _$MessageListEvent {
  const factory MessageListEvent.started() = _Started;
  const factory MessageListEvent.fetch({required String userId}) = _Fetch;
  const factory MessageListEvent.listenConversation({required String userId}) = _ListenConversation;
  const factory MessageListEvent.addConversations({required List<ConversationEntity> conversations}) = _AddConversations;
  const factory MessageListEvent.addSearchQuery({required String query}) = _AddSearchQuery;
  const factory MessageListEvent.search({required String query}) = _Search;
}
