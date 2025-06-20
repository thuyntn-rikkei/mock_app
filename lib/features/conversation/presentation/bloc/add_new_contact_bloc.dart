import 'package:base_bloc_3/base/bloc/base_bloc.dart';
import 'package:base_bloc_3/base/bloc/base_bloc_state.dart';
import 'package:base_bloc_3/base/bloc/bloc_status.dart';
import 'package:base_bloc_3/base/network/errors/error.dart';
import 'package:base_bloc_3/common/constants/friend_request_status.dart';
import 'package:base_bloc_3/common/external_lib.dart';
import 'package:base_bloc_3/di/di_setup.dart';
import 'package:base_bloc_3/features/conversation/domain/entity/contact_entity.dart';
import 'package:base_bloc_3/features/conversation/domain/entity/friend_request_entity.dart';
import 'package:base_bloc_3/features/conversation/domain/repository/contact_repository.dart';
import 'package:base_bloc_3/features/conversation/domain/repository/friend_request_repository.dart';
import 'package:base_bloc_3/features/login/domain/entity/user_entity.dart';
import 'package:base_bloc_3/features/login/domain/repository/user_repository.dart';
import 'package:base_bloc_3/features/login/presentation/bloc/login_bloc.dart';

part 'add_new_contact_event.dart';

part 'add_new_contact_state.dart';

part 'add_new_contact_bloc.freezed.dart';

part 'add_new_contact_bloc.g.dart';

@injectable
class AddNewContactBloc
    extends BaseBloc<AddNewContactEvent, AddNewContactState> {
  final ContactRepository _contactRepository;
  final UserRepository _userRepository;
  final FriendRequestRepository _friendRequestRepository;

  AddNewContactBloc(this._contactRepository, this._userRepository, this._friendRequestRepository)
      : super(AddNewContactState.init()) {
    on<AddNewContactEvent>(
        (AddNewContactEvent event, Emitter<AddNewContactState> emit) async {
      await event.when(
        started: () => _onStarted(emit),
        addNewContact: (String userId, String contactUserId) =>
            _onAddNewContact(emit, userId, contactUserId),
        search: (String query) => _search(emit, query),
        loadContactList: (String userId) => _onLoadContactList(emit, userId),
        addMyself: () => _onAddMyself(emit),
        addExistingContact: (String userName) => _onAddExistingContact(emit, userName),
        loadFriendRequestList: (String userId) => _onLoadFriendRequestList(emit, userId),
        addFriendRequest: (String userId, String contactUserId) => _onAddFriendRequest(emit, userId, contactUserId),
      );
    });
  }

  Future<void> _onStarted(Emitter<AddNewContactState> emit) async {
    emit(
      state.copyWith(
        status: BaseStateStatus.loading,
      ),
    );

    final result = await _userRepository.fetchAllUsers();

    print(result);

    result.fold(
      (l) {
        _handleError(emit, l);
      },
      (r) {
        emit(
          state.copyWith(
            status: BaseStateStatus.success,
            users: r,
            searchedUsers: r,
          ),
        );
        final currentUserId = getIt<LoginBloc>().state.userId;
        add(AddNewContactEvent.loadContactList(userId: currentUserId));
      },
    );
  }

  Future<void> _onAddNewContact(
    Emitter<AddNewContactState> emit,
    String userId,
    String contactUserId,
  ) async {
    emit(
      state.copyWith(
        status: BaseStateStatus.loading,
      ),
    );

    print(userId);
    final result = await _contactRepository.createContact(
      ContactEntity(
        contactId: '',
        userId: userId,
        contactUserId: contactUserId,
      ),
    );

    print(result);

    result.fold(
      (l) {
        _handleError(emit, l);
      },
      (r) {
        emit(
          state.copyWith(
            status: BaseStateStatus.redirecting,
          ),
        );
      },
    );
  }

  Future<void> _search(Emitter<AddNewContactState> emit, String query) async {
    final searchedUsers = _searchUsersByQuery(query);
    emit(
      state.copyWith(
        status: BaseStateStatus.success,
        searchedUsers: searchedUsers,
      ),
    );
  }

  List<UserEntity> _searchUsersByQuery(String query) {
    if (query.isEmpty) {
      return state.users;
    }

    final lowerCaseQuery = query.toLowerCase();

    return state.users.where(
      (user) {
        if (user.fullName.toLowerCase().contains(lowerCaseQuery)) return true;
        return false;
      },
    ).toList();
  }

  Future<void> _onLoadContactList(
    Emitter<AddNewContactState> emit,
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
        emit(
          state.copyWith(
            status: BaseStateStatus.success,
            contacts: r,
          ),
        );
        add(AddNewContactEvent.loadFriendRequestList(userId: userId));
      },
    );
  }

  Future<void> _onAddMyself(Emitter<AddNewContactState> emit) async {
    emit(
      state.copyWith(
        status: BaseStateStatus.failed,
        message: 'You cannot add yourself',
      ),
    );
  }

  Future<void> _onAddExistingContact(Emitter<AddNewContactState> emit, String userName) async {
    emit(
      state.copyWith(
        status: BaseStateStatus.failed,
        message: '$userName is already in your contact list. You cannot add existing contact',
      ),
    );
  }

  Future<void> _onLoadFriendRequestList(Emitter<AddNewContactState> emit, String userId) async {
    emit(
      state.copyWith(
        status: BaseStateStatus.loading,
      ),
    );

    final result = await _friendRequestRepository.fetchFriendRequestsByUserId(userId);

    print(result);

    await result.fold(
          (l) {
        _handleError(emit, l);
      },
          (r) async {
        emit(
          state.copyWith(
            status: BaseStateStatus.success,
            friendRequests: r,
          ),
        );
      },
    );
  }

  Future<void> _onAddFriendRequest(Emitter<AddNewContactState> emit, String userId, String contactUserId) async {
    emit(
      state.copyWith(
        status: BaseStateStatus.loading,
      ),
    );

    print(userId);
    final result = await _friendRequestRepository.createFriendRequest(
      FriendRequestEntity(
        friendRequestId: '',
        userId: userId,
        friendRequestUserId: contactUserId,
        status: FriendRequestStatus.pending,
      ),
    );

    print(result);

    result.fold(
          (l) {
        _handleError(emit, l);
      },
          (r) {
        add(AddNewContactEvent.loadFriendRequestList(userId: userId));
      },
    );
  }

  void _handleError(Emitter<AddNewContactState> emit, BaseError error) {
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
