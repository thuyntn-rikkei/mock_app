import 'package:base_bloc_3/base/bloc/index.dart';
import 'package:base_bloc_3/common/index.dart';
import 'package:base_bloc_3/features/example/domain/use_case/use_case.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';

import '../../../../base/network/errors/error.dart';
import '../../data/model/index.dart';

part 'example_bloc.freezed.dart';
part 'example_bloc.g.dart';
part 'example_event.dart';
part 'example_state.dart';

@injectable
class ExampleBloc extends BaseBloc<ExampleEvent, ExampleState>
    with BaseCommonMethodMixin {
  ExampleBloc(this._coreUseCase) : super(ExampleState.init()) {
    on<ExampleEvent>((ExampleEvent event, Emitter<ExampleState> emit) async {
      await event.when(
        getData: () => onGetData(emit),
        showMessage: () => onShowMessage(emit),
        getPlayers: (List<Player> players, int offset) =>
            onGetPlayers(emit, players, offset),
      );
    });
  }

  final ExampleUseCase _coreUseCase;
  final PagingController<int, Player> pagingController =
      PagingController(firstPageKey: 0);

  Future onGetData(Emitter<ExampleState> emit) async {
    emit(state.copyWith(attribute: none()));
    final Either<BaseError, List<Player>> result =
        await _coreUseCase.getData(limit: 25, offset: 0);
    emit(
      result.fold(
        (l) => state.copyWith(status: BaseStateStatus.failed, message: "Error"),
        (r) => state.copyWith(status: BaseStateStatus.failed, message: "Error"),
      ),
    );
  }

  Future onShowMessage(Emitter<ExampleState> emit) async {
    emit(state.copyWith(message: "Error"));
  }

  Future onGetPlayers(
      Emitter<ExampleState> emit, List<Player> players, int offset) async {
    final res = await _coreUseCase.getData(offset: offset, limit: 25);
    pagingControllerOnLoad(offset, pagingController, res, onSuccess: () {
      emit(state.copyWith(players: pagingController.itemList));
    });
  }
}
