part of 'message_list_bloc.dart';

@freezed
class MessageListEvent with _$MessageListEvent {
  const factory MessageListEvent.started() = _Started;
  const factory MessageListEvent.fetch() = _Fetch;
}
