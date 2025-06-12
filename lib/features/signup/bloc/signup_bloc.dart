import 'package:base_bloc_3/base/bloc/base_bloc.dart';
import 'package:base_bloc_3/base/bloc/base_bloc_state.dart';
import 'package:base_bloc_3/base/bloc/bloc_status.dart';
import 'package:base_bloc_3/common/external_lib.dart';
import 'package:base_bloc_3/features/login/domain/entity/user_entity.dart';
import 'package:base_bloc_3/features/login/domain/repository/user_repository.dart';

part 'signup_event.dart';

part 'signup_state.dart';

part 'signup_bloc.freezed.dart';

part 'signup_bloc.g.dart';

@lazySingleton
class SignupBloc extends BaseBloc<SignupEvent, SignupState> {
  final UserRepository _userRepository;

  SignupBloc(this._userRepository) : super(SignupState.init()) {
    on<SignupEvent>((SignupEvent event, Emitter<SignupState> emit) async {
      await event.when(
        started: () => _onStarted(emit),
        signup: (String email, String password, String fullName) =>
            _onSignup(emit, email, password, fullName),
        agreeWithTerms: (bool isAgreeWithTerms) =>
            _onAgreeWithTerms(emit, isAgreeWithTerms),
      );
    });
  }

  Future<void> _onStarted(Emitter<SignupState> emit) async {
    emit(state.copyWith(status: BaseStateStatus.init));
  }

  Future<void> _onAgreeWithTerms(
    Emitter<SignupState> emit,
    bool isAgreeWithTerms,
  ) async {
    emit(state.copyWith(isAgreeWithTerms: isAgreeWithTerms));
  }

  Future<void> _onSignup(
    Emitter<SignupState> emit,
    String email,
    String password,
    String fullName,
  ) async {
    emit(state.copyWith(status: BaseStateStatus.loading));

    final result = await _userRepository.signUp(email, password, fullName);

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
        emit(state.copyWith(status: BaseStateStatus.success, user: r));
      },
    );
  }
}
