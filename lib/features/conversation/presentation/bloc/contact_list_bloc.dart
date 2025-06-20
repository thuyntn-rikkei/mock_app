import 'package:base_bloc_3/base/bloc/base_bloc.dart';
import 'package:base_bloc_3/base/bloc/base_bloc_state.dart';
import 'package:base_bloc_3/base/bloc/bloc_status.dart';
import 'package:base_bloc_3/base/network/errors/error.dart';
import 'package:base_bloc_3/common/external_lib.dart';
import 'package:base_bloc_3/features/conversation/domain/entity/contact_entity.dart';
import 'package:base_bloc_3/features/conversation/domain/repository/contact_repository.dart';
import 'package:base_bloc_3/features/dashboard/domain/repository/conversation_repository.dart';
import 'package:base_bloc_3/features/login/domain/entity/user_entity.dart';
import 'package:base_bloc_3/features/login/domain/repository/user_repository.dart';

part 'contact_list_event.dart';

part 'contact_list_state.dart';

part 'contact_list_bloc.freezed.dart';

part 'contact_list_bloc.g.dart';

@lazySingleton
class ContactListBloc extends BaseBloc<ContactListEvent, ContactListState> {
  final ContactRepository _contactRepository;
  final UserRepository _userRepository;
  final ConversationRepository _conversationRepository;

  ContactListBloc(
    this._contactRepository,
    this._userRepository,
    this._conversationRepository,
  ) : super(ContactListState.init()) {
    on<ContactListEvent>(
        (ContactListEvent event, Emitter<ContactListState> emit) async {
      await event.when(
        started: () => _onStarted(emit),
        loadContactList: (String userId) => _onLoadContactList(emit, userId),
        openConversation: (String userId1, String userId2) =>
            _onOpenConversation(emit, userId1, userId2),
        search: (String query) => _search(emit, query),
      );
    });
  }

  Future<void> _onStarted(Emitter<ContactListState> emit) async {
    emit(ContactListState.init());
  }

  Future<void> _onLoadContactList(
    Emitter<ContactListState> emit,
    String userId,
  ) async {
    emit(
      state.copyWith(
        status: BaseStateStatus.loading,
      ),
    );

    print(userId);
    final result = await _contactRepository.fetchContactsByUserId(userId);

    print(result);

    await result.fold(
      (l) {
        _handleError(emit, l);
      },
      (r) async {
        final contactUserIds = r
            .map((c) => (c.userId == userId) ? c.contactUserId : c.userId)
            .toSet();
        final contactUsersResult =
            await _userRepository.fetchUsersByIds(contactUserIds);
        contactUsersResult.fold(
          (l) {
            _handleError(emit, l);
          },
          (r) async {
            emit(
              state.copyWith(
                status: BaseStateStatus.success,
                userList: r,
                searchedUserList: r,
              ),
            );
            print(state.toString());
          },
        );
      },
    );
  }

  Future<void> _onOpenConversation(
    Emitter<ContactListState> emit,
    String userId1,
    String userId2,
  ) async {
    emit(
      state.copyWith(
        status: BaseStateStatus.loading,
      ),
    );

    final result =
        await _conversationRepository.createIfNotExists(userId1, userId2);

    result.fold((l) {
      _handleError(emit, l);
    }, (r) {
      if (r != null) {
        emit(
          state.copyWith(
            status: BaseStateStatus.redirecting,
            conversationId: r.conversationId,
          ),
        );
        print(state.toString());
      } else {
        state.copyWith(
          status: BaseStateStatus.failed,
          message: 'Conversation not found',
        );
      }
    });
  }

  Future<void> _search(Emitter<ContactListState> emit, String query) async {
    final searchedUsers = _searchUsersByQuery(query);
    emit(
      state.copyWith(
        status: BaseStateStatus.success,
        searchedUserList: searchedUsers,
      ),
    );
  }

  List<UserEntity> _searchUsersByQuery(String query) {
    if (query.isEmpty) {
      return state.userList;
    }

    final lowerCaseQuery = query.toLowerCase();

    return state.userList.where(
      (user) {
        if (user.fullName.toLowerCase().contains(lowerCaseQuery)) return true;
        return false;
      },
    ).toList();
  }

  void _handleError(Emitter<ContactListState> emit, BaseError error) {
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
