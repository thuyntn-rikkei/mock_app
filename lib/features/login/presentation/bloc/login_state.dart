part of 'login_bloc.dart';

@CopyWith()
class LoginState extends BaseBlocState {
  final String userId;

  const LoginState({
    required super.status,
    super.message,
    this.userId = '',
  });

  factory LoginState.init() {
    return const LoginState(
      status: BaseStateStatus.init,
    );
  }

  factory LoginState.success(String newUserId) {
    return LoginState(
      status: BaseStateStatus.success,
      userId: newUserId,
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
  List get props => [status, message, userId];
}
