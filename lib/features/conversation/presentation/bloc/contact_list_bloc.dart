import 'package:base_bloc_3/base/bloc/base_bloc.dart';
import 'package:base_bloc_3/base/bloc/base_bloc_state.dart';
import 'package:base_bloc_3/base/bloc/bloc_status.dart';
import 'package:base_bloc_3/base/network/errors/error.dart';
import 'package:base_bloc_3/common/external_lib.dart';
import 'package:base_bloc_3/features/conversation/domain/entity/contact_entity.dart';
import 'package:base_bloc_3/features/conversation/domain/repository/contact_repository.dart';
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

  ContactListBloc(this._contactRepository, this._userRepository)
      : super(ContactListState.init()) {
    on<ContactListEvent>(
        (ContactListEvent event, Emitter<ContactListState> emit) async {
      await event.when(
        started: () => _onStarted(emit),
        loadContactList: (String userId) => _onLoadContactList(emit, userId),
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
    emit(ContactListState.loading());

    print(userId);
    final result = await _contactRepository.fetchContactsByUserId(userId);

    print(result);

    await result.fold(
      (l) {
        l.when(
          httpInternalServerError: (String errorBody) {
            emit(
              ContactListState.failed(errorBody),
            );
          },
          httpUnAuthorizedError: () {
            emit(
              ContactListState.failed('UnAuthorized'),
            );
          },
          httpUnknownError: (String message) {
            emit(
              ContactListState.failed(message),
            );
          },
        );
      },
      (r) async {
        final contactUserIds = r.map((c) => c.userId).toSet();
        final contactUsersResult =
            await _userRepository.fetchUsersByIds(contactUserIds);
        contactUsersResult.fold(
          (l) {
            l.when(
              httpInternalServerError: (String errorBody) {
                emit(
                  ContactListState.failed(errorBody),
                );
              },
              httpUnAuthorizedError: () {
                emit(
                  ContactListState.failed('UnAuthorized'),
                );
              },
              httpUnknownError: (String message) {
                emit(
                  ContactListState.failed(message),
                );
              },
            );
          },
          (r) async {
            emit(ContactListState.success(userList: r));
          },
        );
      },
    );
  }
}
