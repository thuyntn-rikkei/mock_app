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
  @override
  void initState() {
    super.initState();
    final authState = getIt<LoginBloc>().state;
    bloc.add(ContactListEvent.loadContactList(userId: authState.userId));
  }

  @override
  void listener(BuildContext context, ContactListState state) {
    if (state.status == BaseStateStatus.failed) {
      if (state.message != null && state.message!.isNotEmpty) {
        DialogUtils.showDialog(content: state.message!);
      }
    }
    if (state.status == BaseStateStatus.loading) {
      DialogUtils.showLoading();
    } else {
      DialogUtils.hideLoading();
    }

    if (state.status == BaseStateStatus.success) {
      context.push(RouteName.conversationDetailsPath(state.conversationId ?? ''));
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
          onPressed: () {
            context.push(RouteName.addContact);
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
    return const SearchBar(
      hintText: 'Search contact',
      leading: Icon(Icons.search),
      padding: WidgetStatePropertyAll<EdgeInsets>(
        EdgeInsets.symmetric(horizontal: 16),
      ),
      elevation: WidgetStatePropertyAll(0),
    );
  }

  Widget _buildContactList() {
    final users = bloc.state.userList;
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
