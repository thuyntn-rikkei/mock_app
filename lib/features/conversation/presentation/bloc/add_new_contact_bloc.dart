import 'package:base_bloc_3/base/bloc/base_bloc.dart';
import 'package:base_bloc_3/base/bloc/base_bloc_state.dart';
import 'package:base_bloc_3/base/bloc/bloc_status.dart';
import 'package:base_bloc_3/base/network/errors/error.dart';
import 'package:base_bloc_3/common/external_lib.dart';
import 'package:base_bloc_3/features/conversation/domain/entity/contact_entity.dart';
import 'package:base_bloc_3/features/conversation/domain/repository/contact_repository.dart';
import 'package:base_bloc_3/features/login/domain/entity/user_entity.dart';
import 'package:base_bloc_3/features/login/domain/repository/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_new_contact_event.dart';

part 'add_new_contact_state.dart';

part 'add_new_contact_bloc.freezed.dart';

part 'add_new_contact_bloc.g.dart';

@lazySingleton
class AddNewContactBloc
    extends BaseBloc<AddNewContactEvent, AddNewContactState> {
  final ContactRepository _contactRepository;
  final UserRepository _userRepository;

  AddNewContactBloc(this._contactRepository, this._userRepository)
      : super(AddNewContactState.init()) {
    on<AddNewContactEvent>((AddNewContactEvent event, Emitter<AddNewContactState> emit) async {
      await event.when(
        started: () => _onStarted(emit),
        addNewContact: (String userId, String contactUserId) =>
            _onAddNewContact(emit, userId, contactUserId),
        search: (String query) => _search(emit, query),
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
            status: BaseStateStatus.init,
            users: r,
            searchedUsers: r
          )
        );
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
            status: BaseStateStatus.success,
          ),
        );
      },
    );
  }

  Future<void> _search(Emitter<AddNewContactState> emit, String query) async {
    final searchedUsers = _searchUsersByQuery(query);
    emit(
      state.copyWith(
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
