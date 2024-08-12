import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';
import 'package:base_bloc_3/base/bloc/index.dart';
import 'package:base_bloc_3/common/index.dart';
import 'package:base_bloc_3/features/example/domain/use_case/use_case.dart';

import 'package:base_bloc_3/base/network/errors/error.dart';
import 'package:base_bloc_3/features/example/domain/entity/player_entity.dart';

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
        getPlayers: (List<PlayerEntity> players, int offset) =>
            onGetPlayers(emit, players, offset),
      );
    });
  }

  final ExampleUseCase _coreUseCase;
  final PagingController<int, PlayerEntity> pagingController =
      PagingController(firstPageKey: 0);

  Future onGetData(Emitter<ExampleState> emit) async {
    emit(state.copyWith(attribute: none()));
    final Either<BaseError, List<PlayerEntity>> result =
        await _coreUseCase.getData(limit: 25, offset: 0);
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
    final res = await _coreUseCase.getData(offset: offset, limit: 25);
    pagingControllerOnLoad(
      offset,
      pagingController,
      res,
      onSuccess: (data) {
        emit(state.copyWith(players: pagingController.itemList));
      },
    );
  }
}
