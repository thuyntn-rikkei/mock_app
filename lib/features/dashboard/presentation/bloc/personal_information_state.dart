part of 'personal_information_bloc.dart';

@CopyWith()
class PersonalInformationState extends BaseBlocState {
  final UserEntity? user;

  const PersonalInformationState({
    required super.status,
    super.message,
    this.user,
  });

  factory PersonalInformationState.init() {
    return const PersonalInformationState(
      status: BaseStateStatus.init,
    );
  }

  @override
  List get props => [status, message, user];
}
