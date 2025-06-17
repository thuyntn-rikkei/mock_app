import 'package:base_bloc_3/base/bloc/base_bloc.dart';
import 'package:base_bloc_3/base/bloc/base_bloc_state.dart';
import 'package:base_bloc_3/base/bloc/bloc_status.dart';
import 'package:base_bloc_3/base/network/errors/error.dart';
import 'package:base_bloc_3/common/external_lib.dart';
import 'package:base_bloc_3/data/model/message/message_type_enum.dart';
import 'package:base_bloc_3/features/conversation/domain/repository/message_repository.dart';
import 'package:base_bloc_3/features/dashboard/domain/entity/message_entity.dart';
import 'package:base_bloc_3/features/dashboard/domain/repository/conversation_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'conversation_details_event.dart';

part 'conversation_details_state.dart';

part 'conversation_details_bloc.freezed.dart';

part 'conversation_details_bloc.g.dart';

@lazySingleton
class ConversationDetailsBloc
    extends BaseBloc<ConversationDetailsEvent, ConversationDetailsState> {
  final MessageRepository _messageRepository;

  ConversationDetailsBloc(this._messageRepository)
      : super(ConversationDetailsState.init()) {
    on<ConversationDetailsEvent>((event, emit) async {
      await event.when(
        started: () => _onStarted(emit),
        loadConversationDetails: (String conversationId) =>
            _onLoadConversationDetails(emit, conversationId),
        sendMessage: (String message, String conversationId, String senderId) =>
            _onSendMessage(emit, message, conversationId, senderId),
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
    emit(ConversationDetailsState.loading());
    print('conversationId: $conversationId');
    final result = await _messageRepository.fetchMessagesByConversationId(conversationId);
    result.fold((l) {
      _handleError(emit, l);
    }, (r) {
      emit(ConversationDetailsState.loadedListMessage(conversationId, r));
    });
  }

  void _handleError(Emitter<ConversationDetailsState> emit, BaseError error) {
    error.when(
      httpInternalServerError: (String errorBody) {
        emit(
          ConversationDetailsState.failed(errorBody),
        );
      },
      httpUnAuthorizedError: () {
        emit(
          ConversationDetailsState.failed('UnAuthorized'),
        );
      },
      httpUnknownError: (String message) {
        emit(
          ConversationDetailsState.failed(message),
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
    emit(ConversationDetailsState.loading());

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
            messages: [...state.messages, newMessage],
          ),
        );
      },
    );
  }
}
