import 'package:auto_route/auto_route.dart';
import 'package:base_bloc_3/features/example/presentation/pages/example_page.dart';
import 'package:injectable/injectable.dart';
import 'package:base_bloc_3/routes/app_routes.dart';

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
