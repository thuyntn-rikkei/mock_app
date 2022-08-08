part of 'example_bloc.dart';

@CopyWith()
class ExampleState extends BaseBlocState {
  final Option<String>? attribute;
  final List<PlayerEntity> players;

  const ExampleState({
    required super.status,
    super.message,
    this.players = const [],
    this.attribute,
  });

  factory ExampleState.init() {
    return const ExampleState(status: BaseStateStatus.init);
  }

  @override
  List get props => [status, players, message, attribute];
}
