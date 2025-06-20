part of 'personal_information_bloc.dart';

@freezed
class PersonalInformationEvent with _$PersonalInformationEvent {
  const factory PersonalInformationEvent.started() = _Started;
  const factory PersonalInformationEvent.loadUser({required String userId}) = _LoadUser;
}
