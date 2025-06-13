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
        fetch: () => _onFetch(emit),
      );
    });
  }

  Future<void> _onStarted(Emitter<MessageListState> emit) async {
    emit(state.copyWith(status: BaseStateStatus.init));
  }

  Future<void> _onFetch(Emitter<MessageListState> emit) async {
    emit(state.copyWith(status: BaseStateStatus.loading));

    final result = await _conversationRepository.fetchConversations();

    print(result);

    result.fold(
      (l) {
        l.when(
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
                message: 'Unauthorized',
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
      },
      (r) {
        emit(state.copyWith(status: BaseStateStatus.success, conversations: r));
      },
    );
  }
}
