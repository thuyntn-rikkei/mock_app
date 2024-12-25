import 'package:base_bloc_3/import.dart';

part 'app_pages.gr.dart';

@singleton
@AutoRouterConfig()
class AppPages extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();
  @override
  final List<AutoRoute> routes = [
    AutoRoute(path: AppRoutes.initial, page: ExampleRoute.page),
  ];
}
