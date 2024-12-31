import 'package:base_bloc_3/import.dart';

@RoutePage()
class ExamplePage extends StatefulWidget {
  const ExamplePage({Key? key}) : super(key: key);

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState
    extends BaseState<ExamplePage, ExampleEvent, ExampleState, ExampleBloc>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    bloc.pagingController.addPageRequestListener(
      (pageKey) => bloc.add(
        ExampleEvent.getPlayers(
          players: bloc.state.players,
          offset: pageKey,
        ),
      ),
    );
  }

  @override
  Widget renderUI(BuildContext context) {
    return BaseScaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Base Bloc"),
            AppButton(
              title: "Call API",
              onPressed: () => bloc.add(const ExampleEvent.getData()),
            ),
            AppButton(
              title: "Talker Screen",
              onPressed: () => context.router.pushWidget(
                TalkerScreen(
                  talker: getIt<Talker>(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
