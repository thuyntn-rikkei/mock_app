import 'package:base_bloc_3/features/authen/domain/repository/authen_repository.dart';
import 'package:base_bloc_3/import.dart';

part 'auth_bloc.freezed.dart';
part 'auth_bloc.g.dart';
part 'auth_event.dart';
part 'auth_state.dart';

@lazySingleton
class AuthBloc extends BaseBloc<AuthEvent, AuthState> {
  final AuthenRepository _authRepository = getIt<AuthenRepository>();
  final LocalStorage _localStorage = getIt<LocalStorage>();
  AuthBloc() : super(AuthState.init()) {
    on<AuthEvent>((AuthEvent event, Emitter<AuthState> emit) async {
      await event.when(
        onAuthStarted: () => _onStarted(emit),
        onLoginEvent: (LoginRequest request) => _onLoginStarted(emit, request),
        onRegisterEvent: (RegisterRequest request) =>
            _onRegisterStarted(emit, request),
        onLogoutEvent: () => _onAuthLogoutStarted(emit),
      );
    });
  }

  Future<void> _onStarted(Emitter<AuthState> emit) async {
    final isExpried = await _checkExpiredToken();
    if (!isExpried) {
      emit(
        state.copyWith(
          isLogin: true,
          status: BaseStateStatus.success,
        ),
      );
    } else {
      emit(
        state.copyWith(
          isLogin: false,
          status: BaseStateStatus.success,
        ),
      );
    }
  }

  Future<void> _onLoginStarted(
    Emitter<AuthState> emit,
    LoginRequest request,
  ) async {
    emit(
      state.copyWith(status: BaseStateStatus.loading, isLoginSuccess: false),
    );

    await Future.delayed(const Duration(seconds: 2), () {});
    emit(
      state.copyWith(
        status: BaseStateStatus.success,
        isLogin: true,
        isLoginSuccess: true,
        isLogoutSuccess: false,
      ),
    );

    // emit(
    //   state.copyWith(status: BaseStateStatus.loading, isLoginSuccess: false),
    // );

    // final result = await _authRepository.login(
    //   request,
    // );
    // result.fold(
    //     (l) => emit(
    //           state.copyWith(
    //             status: BaseStateStatus.failed,
    //             isLoginSuccess: false,
    //           ),
    //         ), (r) async {
    //   // save token
    //   await _localStorage.save(PrefKeys.accessToken, r.accessToken);
    //   emit(
    //     state.copyWith(
    //       status: BaseStateStatus.success,
    //       isLoginSuccess: true,
    //       isLogoutSuccess: false,
    //     ),
    //   );
    // });
  }

  Future<void> _onRegisterStarted(
    Emitter<AuthState> emit,
    RegisterRequest request,
  ) async {
    emit(
      state.copyWith(
        status: BaseStateStatus.loading,
        isRegisterSuccess: false,
      ),
    );
    await Future.delayed(const Duration(seconds: 2), () {});
    emit(
      state.copyWith(
        status: BaseStateStatus.success,
        isRegisterSuccess: true,
      ),
    );

    // emit(
    //   state.copyWith(
    //     status: BaseStateStatus.loading,
    //     isRegisterSuccess: false,
    //   ),
    // );
    // final result = await _authRepository.register(
    //   request,
    // );
    // result.fold(
    //     (l) => emit(
    //           state.copyWith(
    //             status: BaseStateStatus.failed,
    //             isRegisterSuccess: false,
    //           ),
    //         ), (r) async {
    //   emit(
    //     state.copyWith(
    //       status: BaseStateStatus.success,
    //       isRegisterSuccess: true,
    //     ),
    //   );
    // });
  }

  Future<void> _onAuthLogoutStarted(
    Emitter<AuthState> emit,
  ) async {
    await _localStorage.remove(PrefKeys.accessToken);
    emit(state.copyWith(isLogoutSuccess: true, isLogin: false));
  }

  Future<bool> _checkExpiredToken() async {
    final String? accessToken = await _localStorage.get(PrefKeys.accessToken);

    if (accessToken != null && accessToken.isNotEmpty) {
      bool isTokenExpired = JwtDecoder.isExpired(accessToken);
      if (!isTokenExpired) {
        return false;
      } else {
        return true;
      }
    } else {
      return true;
    }
  }
}
