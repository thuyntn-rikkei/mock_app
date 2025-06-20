part of 'add_new_contact_bloc.dart';

@freezed
class AddNewContactEvent with _$AddNewContactEvent {
  const factory AddNewContactEvent.started() = _Started;
  const factory AddNewContactEvent.addNewContact({required String userId, required String contactUserId}) = _AddNewContact;
  const factory AddNewContactEvent.search({required String query}) = _Search;
  const factory AddNewContactEvent.loadContactList({required String userId}) = _LoadContactList;
  const factory AddNewContactEvent.addMyself() = _AddMyself;
  const factory AddNewContactEvent.addExistingContact(String userName) = _AddExistingContact;
}
