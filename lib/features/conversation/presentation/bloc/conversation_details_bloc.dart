import 'package:base_bloc_3/base/bloc/base_bloc.dart';
import 'package:base_bloc_3/base/bloc/base_bloc_state.dart';
import 'package:base_bloc_3/base/bloc/bloc_status.dart';
import 'package:base_bloc_3/base/network/errors/error.dart';
import 'package:base_bloc_3/common/external_lib.dart';
import 'package:base_bloc_3/data/model/message/message_type_enum.dart';
import 'package:base_bloc_3/features/conversation/domain/repository/message_repository.dart';
import 'package:base_bloc_3/features/dashboard/domain/entity/message_entity.dart';

part 'conversation_details_event.dart';

part 'conversation_details_state.dart';

part 'conversation_details_bloc.freezed.dart';

part 'conversation_details_bloc.g.dart';

@injectable
class ConversationDetailsBloc
    extends BaseBloc<ConversationDetailsEvent, ConversationDetailsState> {
  final MessageRepository _messageRepository;

  StreamSubscription<MessageEntity>? messageSubscription;

  ConversationDetailsBloc(this._messageRepository)
      : super(ConversationDetailsState.init()) {
    on<ConversationDetailsEvent>((event, emit) async {
      await event.when(
        started: () => _onStarted(emit),
        loadConversationDetails: (String conversationId) =>
            _onLoadConversationDetails(emit, conversationId),
        sendMessage: (String message, String conversationId, String senderId) =>
            _onSendMessage(emit, message, conversationId, senderId),
        receivedMessage: (MessageEntity message) =>
            _onReceivedMessage(emit, message),
        listenToMessages: (String conversationId, String currentUserId) =>
            _listenToMessages(emit, conversationId, currentUserId),
      );
    });
  }

  Future<void> _onStarted(Emitter<ConversationDetailsState> emit) async {
    emit(ConversationDetailsState.init());
  }

  Future<void> _onLoadConversationDetails(
    Emitter<ConversationDetailsState> emit,
    String conversationId,
  ) async {
    emit(
      state.copyWith(
        status: BaseStateStatus.loading,
      ),
    );
    print('conversationId: $conversationId');
    final result =
        await _messageRepository.fetchMessagesByConversationId(conversationId);
    result.fold(
      (l) {
        _handleError(emit, l);
      },
      (r) {
        r.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        emit(
          state.copyWith(
            status: BaseStateStatus.init,
            conversationId: conversationId,
            messages: r,
          ),
        );
      },
    );
  }

  void _handleError(Emitter<ConversationDetailsState> emit, BaseError error) {
    error.when(
      httpInternalServerError: (String errorBody) {
        emit(
          state.copyWith(
            status: BaseStateStatus.failed,
            message: errorBody,
          ),
        );
      },
      httpUnAuthorizedError: () {
        emit(
          state.copyWith(
            status: BaseStateStatus.failed,
            message: 'UnAuthorized',
          ),
        );
      },
      httpUnknownError: (String message) {
        emit(
          state.copyWith(
            status: BaseStateStatus.failed,
            message: message,
          ),
        );
      },
    );
  }

  Future<void> _onSendMessage(
    Emitter<ConversationDetailsState> emit,
    String message,
    String conversationId,
    String senderId,
  ) async {
    emit(
      state.copyWith(
        status: BaseStateStatus.loading,
      ),
    );

    MessageEntity newMessage = TextMessageEntity(
      messageId: '',
      conversationId: conversationId,
      senderId: senderId,
      isRead: false,
      type: MessageType.text,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      text: message,
    );

    final result = await _messageRepository.sendMessage(newMessage);
    result.fold(
      (l) {
        _handleError(emit, l);
      },
      (r) {
        emit(
          state.copyWith(
            status: BaseStateStatus.success,
          ),
        );
      },
    );
  }

  Future<void> _onReceivedMessage(
    Emitter<ConversationDetailsState> emit,
    MessageEntity message,
  ) async {
    final updatedMessages = [...state.messages, message];
    updatedMessages.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    emit(
      state.copyWith(messages: updatedMessages),
    );
  }

  Future<void> _listenToMessages(
    Emitter<ConversationDetailsState> emit,
    String conversationId,
    String currentUserId,
  ) async {
    await messageSubscription?.cancel();

    messageSubscription = _messageRepository
        .listenToMessages(conversationId, currentUserId)
        .listen(
      (message) {
        add(
          ConversationDetailsEvent.receivedMessage(message: message),
        );
      },
    );
  }

  @override
  Future<void> close() {
    messageSubscription?.cancel();
    return super.close();
  }
}
