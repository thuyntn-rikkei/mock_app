part of 'contact_list_bloc.dart';

@freezed
class ContactListEvent with _$ContactListEvent {
  const factory ContactListEvent.started() = _Started;

  const factory ContactListEvent.loadContactList({required String userId}) = _LoadContactList;
}
