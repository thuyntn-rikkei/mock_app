import 'package:base_bloc_3/common/widgets/not_found_screen.dart';
import 'package:base_bloc_3/features/authen/presentation/bloc/auth_bloc.dart';
import 'package:base_bloc_3/import.dart';

final router = GoRouter(
  errorBuilder: (context, state) =>
      NotFoundScreen(uri: state.extra as String? ?? ''),
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: RouteName.home,
      pageBuilder: (BuildContext context, GoRouterState state) =>
          MaterialPage<void>(key: state.pageKey, child: const HomeScreen()),
    ),
    GoRoute(
      path: RouteName.login,
      pageBuilder: (BuildContext context, GoRouterState state) =>
          MaterialPage<void>(key: state.pageKey, child: const LoginScreen()),
    ),
    GoRoute(
      path: RouteName.register,
      pageBuilder: (BuildContext context, GoRouterState state) =>
          MaterialPage<void>(key: state.pageKey, child: const RegisterScreen()),
    ),
    GoRoute(
      path: RouteName.example,
      pageBuilder: (BuildContext context, GoRouterState state) =>
          MaterialPage<void>(key: state.pageKey, child: const ExamplePage()),
    ),
    GoRoute(
      path: RouteName.talkerScreen,
      pageBuilder: (BuildContext context, GoRouterState state) =>
          MaterialPage<void>(
        child: TalkerScreen(
          talker: getIt<Talker>(),
        ),
      ),
    ),
  ],
  redirect: (context, state) {
     final isLoggedIn = getIt<AuthBloc>().state.isLogin;
    if (RouteName.publicRoutes.contains(state.fullPath)) {
      return null;
    }
    if (isLoggedIn) {
      return null;
    }

    return RouteName.login;
  },
);
