part of 'login_bloc.dart';

@CopyWith()
class LoginState extends BaseBlocState {
  const LoginState({
    required super.status,
    super.message,
  });

  factory LoginState.init() {
    return const LoginState(
      status: BaseStateStatus.init,
    );
  }

  factory LoginState.success() {
    return const LoginState(
      status: BaseStateStatus.success,
    );
  }

  factory LoginState.failed(
    String message,
  ) {
    return LoginState(
      status: BaseStateStatus.failed,
      message: message,
    );
  }

  factory LoginState.loading() {
    return const LoginState(
      status: BaseStateStatus.loading,
    );
  }

  @override
  List get props => [status, message];
}
