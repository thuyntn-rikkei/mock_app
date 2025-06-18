import 'package:base_bloc_3/base/bloc/base_bloc.dart';
import 'package:base_bloc_3/base/bloc/base_bloc_state.dart';
import 'package:base_bloc_3/base/bloc/bloc_status.dart';
import 'package:base_bloc_3/base/network/errors/error.dart';
import 'package:base_bloc_3/common/external_lib.dart';
import 'package:base_bloc_3/features/dashboard/domain/entity/conversation_entity.dart';
import 'package:base_bloc_3/features/dashboard/domain/repository/conversation_repository.dart';
import 'package:base_bloc_3/features/login/domain/entity/user_entity.dart';
import 'package:base_bloc_3/features/login/domain/repository/user_repository.dart';

part 'message_list_event.dart';

part 'message_list_state.dart';

part 'message_list_bloc.freezed.dart';

part 'message_list_bloc.g.dart';

@lazySingleton
class MessageListBloc extends BaseBloc<MessageListEvent, MessageListState> {
  final ConversationRepository _conversationRepository;
  final UserRepository _userRepository;

  MessageListBloc(this._conversationRepository, this._userRepository)
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
    emit(
      state.copyWith(
        status: BaseStateStatus.loading,
      ),
    );

    final result = await _conversationRepository.fetchConversations(userId);

    print(result);

    await result.fold(
      (l) async {
        _handleError(emit, l);
      },
      (r) async {
        Set<String> allMemberIds = {};
        for (var conversation in r) {
          if (conversation.memberIds != null) {
            allMemberIds.addAll(conversation.memberIds!.keys);
          }
        }

        final usersResult = await _userRepository.fetchUsersByIds(allMemberIds);
        await usersResult.fold(
          (error) async {
            _handleError(emit, error);
          },
          (users) async {
            emit(
              state.copyWith(
                status: BaseStateStatus.success,
                conversations: r,
                users: users,
              ),
            );
          },
        );
      },
    );
  }

  void _handleError(Emitter<MessageListState> emit, BaseError error) {
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
}
