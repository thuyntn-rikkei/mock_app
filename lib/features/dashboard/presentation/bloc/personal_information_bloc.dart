import 'package:base_bloc_3/base/bloc/base_bloc.dart';
import 'package:base_bloc_3/base/bloc/base_bloc_state.dart';
import 'package:base_bloc_3/base/bloc/bloc_status.dart';
import 'package:base_bloc_3/base/network/errors/error.dart';
import 'package:base_bloc_3/common/external_lib.dart';
import 'package:base_bloc_3/features/login/domain/entity/user_entity.dart';
import 'package:base_bloc_3/features/login/domain/repository/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'personal_information_event.dart';

part 'personal_information_state.dart';

part 'personal_information_bloc.freezed.dart';

part 'personal_information_bloc.g.dart';

@injectable
class PersonalInformationBloc
    extends BaseBloc<PersonalInformationEvent, PersonalInformationState> {
  final UserRepository _userRepository;

  PersonalInformationBloc(this._userRepository)
      : super(PersonalInformationState.init()) {
    on<PersonalInformationEvent>((
      PersonalInformationEvent event,
      Emitter<PersonalInformationState> emit,
    ) async {
      await event.when(
        started: () => _onStarted(emit),
        loadUser: (userId) => _onLoadUser(userId, emit),
      );
    });
  }

  Future<void> _onStarted(Emitter<PersonalInformationState> emit) async {
    emit(state.copyWith(status: BaseStateStatus.init));
  }

  Future<void> _onLoadUser(
      String userId, Emitter<PersonalInformationState> emit) async {
    final usersResult = await _userRepository.fetchUsersByIds(
      {userId},
    );
    await usersResult.fold(
      (error) async {
        _handleError(emit, error);
      },
      (users) async {
        emit(
          state.copyWith(
            status: BaseStateStatus.success,
            user: users.first,
          ),
        );
      },
    );
  }

  void _handleError(Emitter<PersonalInformationState> emit, BaseError error) {
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
