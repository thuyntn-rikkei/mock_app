part of 'add_new_contact_bloc.dart';

@freezed
class AddNewContactEvent with _$AddNewContactEvent {
  const factory AddNewContactEvent.started() = _Started;
  const factory AddNewContactEvent.addNewContact({required String userId, required String contactUserId}) = _AddNewContact;
}
