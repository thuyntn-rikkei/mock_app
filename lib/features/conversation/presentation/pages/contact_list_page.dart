import 'package:base_bloc_3/base/base_widget.dart';
import 'package:base_bloc_3/base/bloc/bloc_status.dart';
import 'package:base_bloc_3/common/dialog/dialog_utils.dart';
import 'package:base_bloc_3/common/external_lib.dart';
import 'package:base_bloc_3/common/widgets/base_appbar.dart';
import 'package:base_bloc_3/common/widgets/base_scaffold.dart';
import 'package:base_bloc_3/di/di_setup.dart';
import 'package:base_bloc_3/features/conversation/domain/entity/contact_entity.dart';
import 'package:base_bloc_3/features/conversation/presentation/bloc/contact_list_bloc.dart';
import 'package:base_bloc_3/features/conversation/presentation/widgets/user_item_widget.dart';
import 'package:base_bloc_3/features/login/presentation/bloc/login_bloc.dart';
import 'package:base_bloc_3/routes/app_routes.dart';

class ContactListPage extends StatefulWidget {
  const ContactListPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ContactListPageState();
  }
}

class _ContactListPageState extends BaseShareState<ContactListPage,
    ContactListEvent, ContactListState, ContactListBloc> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;
  final int _debounceDelay = 500;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    final authState = getIt<LoginBloc>().state;
    bloc.add(ContactListEvent.loadContactList(userId: authState.userId));
  }

  void _onSearchChanged() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(
      Duration(milliseconds: _debounceDelay),
      () {
        bloc.add(
          ContactListEvent.search(query: _searchController.text),
        );
      },
    );
  }

  @override
  void listener(BuildContext context, ContactListState state) async {
    super.listener(context, state);
    if (state.status == BaseStateStatus.redirecting) {
      await context
          .push(RouteName.conversationDetailsPath(state.conversationId ?? ''));
      print(state.toString());
    }
  }

  @override
  Widget renderUI(BuildContext context) {
    return blocBuilder(
      builder: (context, state) {
        return BaseScaffold(
          appBar: _buildAppBar(),
          body: _buildBody(),
        );
      },
    );
  }

  Widget _buildAppBar() {
    return BaseAppBar(
      title: 'Contact List',
      actions: [
        IconButton(
          onPressed: () async {
            await context.push(RouteName.addContact);
            bloc.add(ContactListEvent.loadContactList(
                userId: getIt<LoginBloc>().state.userId));
          },
          icon: const Icon(Icons.add_circle),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSearchBar(),
          Expanded(child: _buildContactList()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return SearchBar(
      hintText: 'Search contact',
      leading: const Icon(Icons.search),
      padding: const WidgetStatePropertyAll<EdgeInsets>(
        EdgeInsets.symmetric(horizontal: 16),
      ),
      elevation: const WidgetStatePropertyAll(0),
      controller: _searchController,
      trailing: _searchController.text.isNotEmpty
          ? [
              IconButton(
                onPressed: () {
                  _searchController.clear();
                  bloc.add(const ContactListEvent.search(query: ''));
                },
                icon: const Icon(Icons.close),
              ),
            ]
          : null,
    );
  }

  Widget _buildContactList() {
    final users = bloc.state.searchedUserList;
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (BuildContext context, int index) {
        return buildUserItem(
          context: context,
          user: users[index],
          onTap: () {
            final userId1 = getIt<LoginBloc>().state.userId;
            final userId2 = users[index].userId;
            bloc.add(
              ContactListEvent.openConversation(
                userId1: userId1,
                userId2: userId2,
              ),
            );
          },
        );
      },
    );
  }
}
