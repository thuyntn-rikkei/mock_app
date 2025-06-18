part of 'message_list_bloc.dart';

@CopyWith()
class  MessageListState extends BaseBlocState {
  final List<ConversationEntity> conversations;
  final List<UserEntity> users;

  const  MessageListState({
    required super.status,
    super.message,
    this.conversations = const [],
    this.users = const [],
  });

  factory  MessageListState.init() {
    return const  MessageListState(
      status: BaseStateStatus.init,
      conversations: [],
    );
  }

  factory  MessageListState.success(
  {required List<ConversationEntity> newConversations}
      ) {
    return MessageListState(
      status: BaseStateStatus.success,
      conversations: newConversations,
    );
  }

  factory  MessageListState.failed(
      String message,
      ) {
    return  MessageListState(
      status: BaseStateStatus.failed,
      message: message,
    );
  }

  factory  MessageListState.loading() {
    return const  MessageListState(
      status: BaseStateStatus.loading,
    );
  }

  @override
  List get props => [status, message, conversations, users];
}