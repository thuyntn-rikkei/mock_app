part of 'contact_list_bloc.dart';

@freezed
class ContactListEvent with _$ContactListEvent {
  const factory ContactListEvent.started() = _Started;

  const factory ContactListEvent.loadContactList({required String userId}) = _LoadContactList;

  const factory ContactListEvent.openConversation({required String userId1, required String userId2}) = _OpenConversation;

  const factory ContactListEvent.search({required String query}) = _Search;
}
