part of 'example_bloc.dart';

@CopyWith()
class ExampleState extends BaseBlocState {
  final Option<String>? attribute;
  final List<PlayerEntity> players;
  final GetPlayerRequest request;
  const ExampleState({
    required super.status,
    super.message,
    this.players = const [],
    this.attribute,
    required this.request,
  });

  factory ExampleState.init() {
    return ExampleState(
      status: BaseStateStatus.init,
      request: GetPlayerRequest.init(),
    );
  }

  @override
  List get props => [status, players, message, attribute];
}
