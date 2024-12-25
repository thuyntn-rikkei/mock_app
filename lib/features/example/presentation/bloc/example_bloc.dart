import 'package:base_bloc_3/import.dart';

part 'example_bloc.freezed.dart';
part 'example_bloc.g.dart';
part 'example_event.dart';
part 'example_state.dart';

@injectable
class ExampleBloc extends BaseBloc<ExampleEvent, ExampleState>
    with BaseCommonMethodMixin {
  ExampleBloc(this._repo) : super(ExampleState.init()) {
    on<ExampleEvent>((ExampleEvent event, Emitter<ExampleState> emit) async {
      await event.when(
        getData: () => onGetData(emit),
        showMessage: () => onShowMessage(emit),
        getPlayers: (List<PlayerEntity> players, int offset) =>
            onGetPlayers(emit, players, offset),
      );
    });
  }

  final ExampleRepo _repo;
  final PagingController<int, PlayerEntity> pagingController =
      PagingController(firstPageKey: 0);

  Future onGetData(Emitter<ExampleState> emit) async {
    emit(state.copyWith(attribute: none()));
    final Either<BaseError, List<PlayerEntity>> result =
        await _repo.getData(request: state.request);
    emit(
      result.fold(
        (l) => state.copyWith(status: BaseStateStatus.failed, message: "Error"),
        (r) => state.copyWith(status: BaseStateStatus.idle),
      ),
    );
  }

  Future onShowMessage(Emitter<ExampleState> emit) async {
    emit(state.copyWith(message: "Error"));
  }

  Future onGetPlayers(
    Emitter<ExampleState> emit,
    List<PlayerEntity> players,
    int offset,
  ) async {
    final res = await _repo.getData(request: state.request);
    pagingControllerOnLoad(
      offset,
      pagingController,
      res,
      onSuccess: (data) {
        emit(state.copyWith(players: pagingController.itemList ?? []));
      },
    );
  }
}
