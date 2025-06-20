import 'package:base_bloc_3/base/base_widget.dart';
import 'package:base_bloc_3/common/external_lib.dart';
import 'package:base_bloc_3/common/widgets/base_scaffold.dart';
import 'package:base_bloc_3/features/conversation/presentation/pages/contact_list_page.dart';
import 'package:base_bloc_3/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:base_bloc_3/features/dashboard/presentation/pages/message_list_screen.dart';
import 'package:base_bloc_3/features/dashboard/presentation/pages/personal_information_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _DashboardScreenState();
  }
}

class _DashboardScreenState extends BaseState<DashboardScreen, DashboardEvent,
    DashboardState, DashboardBloc> {
  final List<Widget> _pages = const <Widget>[
    MessageListScreen(),
    ContactListPage(),
    PersonalInformationScreen(),
  ];

  List<NavigationDestination> destinations = const <NavigationDestination>[
    NavigationDestination(
      selectedIcon: Badge(child: Icon(Icons.message_sharp)),
      icon: Badge(child: Icon(Icons.message_outlined)),
      label: 'Messages',
    ),
    NavigationDestination(
      selectedIcon: Icon(Icons.people_alt_sharp),
      icon: Icon(Icons.people_alt_outlined),
      label: 'Friends',
    ),
    NavigationDestination(
      selectedIcon: Icon(Icons.person),
      icon: Icon(Icons.person_outline),
      label: 'Personal',
    ),
  ];

  @override
  Widget renderUI(BuildContext context) {
    return blocBuilder((context, state) {
      return BaseScaffold(
        body: _pages[state.pageIndex],
        bottomNavigation: NavigationBar(
          onDestinationSelected: (index) {
            bloc.add(DashboardEvent.selected(index));
          },
          selectedIndex: state.pageIndex,
          destinations: destinations,
        ),
      );
    });
  }

  Widget _buildBottomNavigation() {
    return NavigationBar(
      onDestinationSelected: (index) {},
      selectedIndex: 0,
      destinations: destinations,
    );
  }
}
