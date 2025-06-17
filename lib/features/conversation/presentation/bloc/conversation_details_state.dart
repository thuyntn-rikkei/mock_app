part of 'conversation_details_bloc.dart';

@CopyWith()
class ConversationDetailsState extends BaseBlocState {
  final List<MessageEntity> messages;
  final String? conversationId;

  const ConversationDetailsState({
    required super.status,
    super.message,
    this.messages = const [],
    this.conversationId,
  });

  factory ConversationDetailsState.init() {
    return const ConversationDetailsState(
      status: BaseStateStatus.init,
    );
  }

  factory ConversationDetailsState.success() {
    return const ConversationDetailsState(
      status: BaseStateStatus.success,
    );
  }

  factory ConversationDetailsState.failed(
    String message,
  ) {
    return ConversationDetailsState(
      status: BaseStateStatus.failed,
      message: message,
    );
  }

  factory ConversationDetailsState.loading() {
    return const ConversationDetailsState(
      status: BaseStateStatus.loading,
    );
  }

  factory ConversationDetailsState.loadedListMessage(
    String conversationId,
    List<MessageEntity> newMessages,
  ) {
    return ConversationDetailsState(
      status: BaseStateStatus.init,
      messages: newMessages,
      conversationId: conversationId,
    );
  }

  @override
  List get props => [status, message, messages, conversationId];
}
