import 'package:base_bloc_3/features/authen/presentation/bloc/auth_bloc.dart';
import 'package:base_bloc_3/import.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(
        title: "Home_Screen",
        hasBack: false,
        actions: [
          BlocListener<AuthBloc, AuthState>(
            bloc: getIt<AuthBloc>(),
            listener: (context, state) {
              if (state.isLoginSuccess) {
                context.go(RouteName.login);
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white),
                ),
                child: IconButton(
                  onPressed: () {
                    getIt<AuthBloc>().add(const AuthEvent.onLogoutEvent());
                  },
                  icon: const Icon(Icons.logout_rounded),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome 🎉",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 10),
            Text(
              "You are logged in",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                context.push(RouteName.example);
              },
              child: const Text("Open Example"),
            ),
          ],
        ),
      ),
    );
  }
}
