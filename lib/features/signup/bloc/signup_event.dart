part of 'signup_bloc.dart';

@freezed
class SignupEvent with _$SignupEvent {
  const factory SignupEvent.started() = _Started;

  const factory SignupEvent.signup({required String email, required String password, required String fullName}) = _Signup;

  const factory SignupEvent.agreeWithTerms({required bool isAgreeWithTerms}) = _AgreeWithTerms;
}
