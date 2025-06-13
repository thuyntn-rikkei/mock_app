part of 'message_list_bloc.dart';

@CopyWith()
class  MessageListState extends BaseBlocState {
  final List<ConversationEntity> conversations;

  const  MessageListState({
    required super.status,
    super.message,
    this.conversations = const [],
  });

  factory  MessageListState.init() {
    return const  MessageListState(
      status: BaseStateStatus.init,
      conversations: [],
    );
  }

  factory  MessageListState.success() {
    return const  MessageListState(
      status: BaseStateStatus.success,
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
  List get props => [status, message, conversations];
}