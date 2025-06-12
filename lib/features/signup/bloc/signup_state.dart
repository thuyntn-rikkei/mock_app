part of 'signup_bloc.dart';

@CopyWith()
class SignupState extends BaseBlocState {
  final UserEntity? user;
  final bool? isAgreeWithTerms;

  const SignupState({
    required super.status,
    super.message,
    this.user,
    this.isAgreeWithTerms,
  });

  factory SignupState.init() {
    return const SignupState(
      status: BaseStateStatus.init,
      isAgreeWithTerms: false,
    );
  }

  factory SignupState.success() {
    return const SignupState(
      status: BaseStateStatus.success,
    );
  }

  factory SignupState.failed(
      String message,
      ) {
    return SignupState(
      status: BaseStateStatus.failed,
      message: message,
    );
  }

  factory SignupState.loading() {
    return const SignupState(
      status: BaseStateStatus.loading,
    );
  }

  @override
  List get props => [status, message, user, isAgreeWithTerms];
}
