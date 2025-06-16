import 'package:base_bloc_3/base/bloc/base_bloc.dart';
import 'package:base_bloc_3/base/bloc/base_bloc_state.dart';
import 'package:base_bloc_3/base/bloc/bloc_status.dart';
import 'package:base_bloc_3/base/network/errors/error.dart';
import 'package:base_bloc_3/common/external_lib.dart';
import 'package:base_bloc_3/features/conversation/domain/entity/contact_entity.dart';
import 'package:base_bloc_3/features/conversation/domain/repository/contact_repository.dart';

part 'contact_list_event.dart';

part 'contact_list_state.dart';

part 'contact_list_bloc.freezed.dart';

part 'contact_list_bloc.g.dart';

@lazySingleton
class ContactListBloc extends BaseBloc<ContactListEvent, ContactListState> {
  final ContactRepository _contactRepository;

  ContactListBloc(this._contactRepository) : super(ContactListState.init()) {
    on<ContactListEvent>(
        (ContactListEvent event, Emitter<ContactListState> emit) async {
      await event.when(
        started: () => _onStarted(emit),
        loadContactList: (String userId) => _onLoadContactList(emit, userId),
      );
    });
  }

  Future<void> _onStarted(Emitter<ContactListState> emit) async {
    emit(state.copyWith(status: BaseStateStatus.init));
  }

  Future<void> _onLoadContactList(
    Emitter<ContactListState> emit,
    String userId,
  ) async {
    emit(state.copyWith(status: BaseStateStatus.loading));

    print(userId);
    final result = await _contactRepository.fetchContactsByUserId(userId);

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
        emit(state.copyWith(status: BaseStateStatus.success, contactList: r));
      },
    );
  }
}
