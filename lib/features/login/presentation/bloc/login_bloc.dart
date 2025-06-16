import 'package:base_bloc_3/base/bloc/base_bloc.dart';
import 'package:base_bloc_3/base/bloc/base_bloc_state.dart';
import 'package:base_bloc_3/base/bloc/bloc_status.dart';
import 'package:base_bloc_3/base/network/errors/error.dart';
import 'package:base_bloc_3/common/external_lib.dart';
import 'package:base_bloc_3/features/login/domain/repository/user_repository.dart';

part 'login_event.dart';

part 'login_state.dart';

part 'login_bloc.freezed.dart';

part 'login_bloc.g.dart';

@lazySingleton
class LoginBloc extends BaseBloc<LoginEvent, LoginState> {
  final UserRepository _userRepository;

  LoginBloc(this._userRepository) : super(LoginState.init()) {
    on<LoginEvent>((LoginEvent event, Emitter<LoginState> emit) async {
      await event.when(
        started: () => _onStarted(emit),
        login: (String email, String password) =>
            _onLogin(emit, email, password),
      );
    });
  }

  Future<void> _onStarted(Emitter<LoginState> emit) async {
    emit(LoginState.init());
  }

  Future<void> _onLogin(
    Emitter<LoginState> emit,
    String email,
    String password,
  ) async {
    emit(LoginState.loading());

    final result = await _userRepository.logIn(email, password);

    print(result);

    result.fold(
      (l) {
        l.when(
          httpInternalServerError: (String errorBody) {
            emit(
              LoginState.failed(errorBody),
            );
          },
          httpUnAuthorizedError: () {
            emit(
              LoginState.failed('UnAuthorized Error'),
            );
          },
          httpUnknownError: (String message) {
            LoginState.failed(message);
          },
        );
      },
      (r) {
        if(r == null) {
          emit(LoginState.failed('Email or password is incorrect'));
          return;
        }
        emit(LoginState.success(r.userId));
      },
    );
  }
}
