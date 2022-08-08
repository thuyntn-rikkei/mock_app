part of 'example_bloc.dart';

@freezed
class ExampleEvent with _$ExampleEvent {
  const factory ExampleEvent.getData() = GetData;
  const factory ExampleEvent.showMessage() = ShowMessage;
  const factory ExampleEvent.getPlayers({
    required List<PlayerEntity> players,
    required int offset,
  }) = GetPlayers;
}
