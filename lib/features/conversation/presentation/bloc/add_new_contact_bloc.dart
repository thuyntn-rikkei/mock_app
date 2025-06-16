import 'package:base_bloc_3/base/bloc/base_bloc.dart';
import 'package:base_bloc_3/base/bloc/base_bloc_state.dart';
import 'package:base_bloc_3/base/bloc/bloc_status.dart';
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
      );
    });
  }

  Future<void> _onStarted(Emitter<AddNewContactState> emit) async {
    emit(AddNewContactState.loading());

    final result = await _userRepository.fetchAllUsers();

    print(result);

    result.fold(
      (l) {
        l.when(
          httpInternalServerError: (String errorBody) {
            emit(
              AddNewContactState.failed(errorBody),
            );
          },
          httpUnAuthorizedError: () {
            emit(
              AddNewContactState.failed('UnAuthorized'),
            );
          },
          httpUnknownError: (String message) {
            emit(
              AddNewContactState.failed(message),
            );
          },
        );
      },
      (r) {
        emit(AddNewContactState.loadedListUsers(r));
      },
    );
  }

  Future<void> _onAddNewContact(
    Emitter<AddNewContactState> emit,
    String userId,
    String contactUserId,
  ) async {
    emit(AddNewContactState.loading());

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
        l.when(
          httpInternalServerError: (String errorBody) {
            emit(
              AddNewContactState.failed(errorBody),
            );
          },
          httpUnAuthorizedError: () {
            emit(
              AddNewContactState.failed('UnAuthorized'),
            );
          },
          httpUnknownError: (String message) {
            emit(
              AddNewContactState.failed(message),
            );
          },
        );
      },
      (r) {
        emit(AddNewContactState.success());
      },
    );
  }
}
