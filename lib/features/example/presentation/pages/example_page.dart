import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:base_bloc_3/base/base_widget.dart';

import 'package:base_bloc_3/common/index.dart';
import 'package:base_bloc_3/features/example/presentation/bloc/example_bloc.dart';

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
    return const BaseScaffold(
      body: Center(
        child: Text("Base Bloc"),
      ),
    );
  }
}
