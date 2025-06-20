part of 'edit_personal_information_bloc.dart';

@freezed
class EditPersonalInformationEvent with _$EditPersonalInformationEvent {
  const factory EditPersonalInformationEvent.started() = _Started;
  const factory EditPersonalInformationEvent.loadUser({required String userId}) = _LoadUser;
}
