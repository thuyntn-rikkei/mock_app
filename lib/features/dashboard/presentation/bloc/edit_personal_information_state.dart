part of 'edit_personal_information_bloc.dart';

@CopyWith()
class EditPersonalInformationState extends BaseBlocState {
  final UserEntity? user;

  const EditPersonalInformationState({
    required super.status,
    super.message,
    this.user,
  });

  factory EditPersonalInformationState.init() {
    return const EditPersonalInformationState(
      status: BaseStateStatus.init,
    );
  }

  @override
  List get props => [status, message, user];
}

