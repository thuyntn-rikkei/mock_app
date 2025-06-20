import 'package:base_bloc_3/base/bloc/base_bloc.dart';
import 'package:base_bloc_3/base/bloc/base_bloc_state.dart';
import 'package:base_bloc_3/base/bloc/bloc_status.dart';
import 'package:base_bloc_3/base/network/errors/error.dart';
import 'package:base_bloc_3/common/external_lib.dart';
import 'package:base_bloc_3/di/di_setup.dart';
import 'package:base_bloc_3/features/dashboard/domain/entity/conversation_entity.dart';
import 'package:base_bloc_3/features/dashboard/domain/repository/conversation_repository.dart';
import 'package:base_bloc_3/features/login/domain/entity/user_entity.dart';
import 'package:base_bloc_3/features/login/domain/repository/user_repository.dart';
import 'package:base_bloc_3/features/login/presentation/bloc/login_bloc.dart';

part 'message_list_event.dart';

part 'message_list_state.dart';

part 'message_list_bloc.freezed.dart';

part 'message_list_bloc.g.dart';

@injectable
class MessageListBloc extends BaseBloc<MessageListEvent, MessageListState> {
  final ConversationRepository _conversationRepository;
  final UserRepository _userRepository;
  StreamSubscription<List<ConversationEntity>>? _conversationSubscription;

  MessageListBloc(this._conversationRepository, this._userRepository)
      : super(MessageListState.init()) {
    on<MessageListEvent>(
        (MessageListEvent event, Emitter<MessageListState> emit) async {
      await event.when(
        started: () => _onStarted(emit),
        fetch: (userId) => _onFetch(emit, userId),
        listenConversation: (userId) => _listenToConversations(emit, userId),
        addConversations: (conversations) => addConversations(emit, conversations),
        search: (query) => _search(emit, query),
        addSearchQuery: (query) => _addSearchQuery(emit, query),
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

  Future<void> _listenToConversations(
    Emitter<MessageListState> emit,
    String userId,
  ) async {
    await _conversationSubscription?.cancel();

    _conversationSubscription = _conversationRepository.listenToConversations(userId).listen(
      (conversations) async {
        add(MessageListEvent.addConversations(conversations: conversations));
      },
      onError: (error) {
        if (!emit.isDone) {
          _handleError(emit, error);
        }
      },
    );
  }

  Future<void> addConversations(
    Emitter<MessageListState> emit,
    List<ConversationEntity> conversations,
  ) async {

    Set<String> allMemberIds = {};
    for (var conversation in conversations) {
      if (conversation.memberIds != null) {
        allMemberIds.addAll(conversation.memberIds!.keys);
      }
    }

    final usersResult = await _userRepository.fetchUsersByIds(allMemberIds);

    if (emit.isDone) return;

    await usersResult.fold(
      (error) async {
        if (!emit.isDone) {
          emit(
            state.copyWith(
              status: BaseStateStatus.failed,
              conversations: conversations,
              message: error.toString(),
            ),
          );
        }
      },
      (users) async {
        if (!emit.isDone) {
          emit(
            state.copyWith(
              status: BaseStateStatus.success,
              conversations: conversations,
              users: users,
            ),
          );
          add(MessageListEvent.search(query: state.searchQuery));
        }
      },
    );
  }

  Future<void> _addSearchQuery(Emitter<MessageListState> emit, String query) async {
    emit(
      state.copyWith(
        searchQuery: query,
      ),
    );
  }

  Future<void> _search(Emitter<MessageListState> emit, String query) async {
    final searchedConversations = _searchConversationsByQuery(query);
    emit(
      state.copyWith(
        searchedConversations: searchedConversations,
      ),
    );
  }

  List<ConversationEntity> _searchConversationsByQuery(String query) {
    if (query.isEmpty) {
      return state.conversations;
    }

    final lowerCaseQuery = query.toLowerCase();

    final currentUserId = getIt<LoginBloc>().state.userId;

    return state.conversations.where((conversation) {
      final memberNames = state.users.where((user) {
        return conversation.memberIds!.keys.contains(user.userId) && user.userId != currentUserId;
      }).map((user) => user.fullName.toLowerCase()).toList();

      for (var name in memberNames) {
        if (name.contains(lowerCaseQuery)) {
          return true;
        }
      }

      return false;
    }).toList();
  }

  @override
  Future<void> close() {
    _conversationSubscription?.cancel();
    return super.close();
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
