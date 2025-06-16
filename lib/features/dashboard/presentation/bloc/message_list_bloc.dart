import 'package:base_bloc_3/base/bloc/base_bloc.dart';
import 'package:base_bloc_3/base/bloc/base_bloc_state.dart';
import 'package:base_bloc_3/base/bloc/bloc_status.dart';
import 'package:base_bloc_3/common/external_lib.dart';
import 'package:base_bloc_3/features/dashboard/domain/entity/conversation_entity.dart';
import 'package:base_bloc_3/features/dashboard/domain/repository/conversation_repository.dart';

part 'message_list_event.dart';

part 'message_list_state.dart';

part 'message_list_bloc.freezed.dart';

part 'message_list_bloc.g.dart';

@lazySingleton
class MessageListBloc extends BaseBloc<MessageListEvent, MessageListState> {
  final ConversationRepository _conversationRepository;

  MessageListBloc(this._conversationRepository)
      : super(MessageListState.init()) {
    on<MessageListEvent>(
        (MessageListEvent event, Emitter<MessageListState> emit) async {
      await event.when(
        started: () => _onStarted(emit),
        fetch: (userId) => _onFetch(emit, userId),
      );
    });
  }

  Future<void> _onStarted(Emitter<MessageListState> emit) async {
    emit(state.copyWith(status: BaseStateStatus.init));
  }

  Future<void> _onFetch(Emitter<MessageListState> emit, String userId) async {
    emit(MessageListState.loading());

    final result = await _conversationRepository.fetchConversations(userId);

    print(result);

    result.fold(
      (l) {
        l.when(
          httpInternalServerError: (String errorBody) {
            emit(
              MessageListState.failed(errorBody),
            );
          },
          httpUnAuthorizedError: () {
            emit(
              MessageListState.failed('UnAuthorized'),
            );
          },
          httpUnknownError: (String message) {
            emit(
              MessageListState.failed(message),
            );
          },
        );
      },
      (r) {
        emit(MessageListState.success(newConversations: r));
      },
    );
  }
}
