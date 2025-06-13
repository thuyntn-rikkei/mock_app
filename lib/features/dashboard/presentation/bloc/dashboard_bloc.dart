import 'package:base_bloc_3/base/bloc/base_bloc.dart';
import 'package:base_bloc_3/base/bloc/base_bloc_state.dart';
import 'package:base_bloc_3/base/bloc/bloc_status.dart';
import 'package:base_bloc_3/common/external_lib.dart';
import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';
part 'dashboard_bloc.freezed.dart';
part 'dashboard_bloc.g.dart';

@lazySingleton
class  DashboardBloc extends BaseBloc< DashboardEvent,  DashboardState> {
  DashboardBloc() : super( DashboardState.init()) {
    on< DashboardEvent>(( DashboardEvent event, Emitter< DashboardState> emit) async {
      await event.when(
        started: () => _onStarted(emit),
        selected: (index) => _onSelected(index, emit),
      );
    });
  }

  Future<void> _onStarted(Emitter< DashboardState> emit) async {
    emit(state.copyWith(status: BaseStateStatus.init));
  }

  Future<void> _onSelected(int index, Emitter< DashboardState> emit) async {
    emit(state.copyWith(status: BaseStateStatus.success, pageIndex: index));
  }
}