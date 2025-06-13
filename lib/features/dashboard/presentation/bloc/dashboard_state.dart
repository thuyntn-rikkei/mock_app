part of 'dashboard_bloc.dart';

@CopyWith()
class  DashboardState extends BaseBlocState {
  final int pageIndex;

  const  DashboardState({
    required super.status,
    super.message,
    this.pageIndex = 0,
  });

  factory  DashboardState.init() {
    return const  DashboardState(
      status: BaseStateStatus.init,
      pageIndex: 0,
    );
  }

  factory  DashboardState.success() {
    return const  DashboardState(
      status: BaseStateStatus.success,
    );
  }

  factory  DashboardState.failed(
      String message,
      ) {
    return  DashboardState(
      status: BaseStateStatus.failed,
      message: message,
    );
  }

  factory  DashboardState.loading() {
    return const  DashboardState(
      status: BaseStateStatus.loading,
    );
  }

  @override
  List get props => [status, message, pageIndex];
}
