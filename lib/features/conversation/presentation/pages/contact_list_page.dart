import 'package:base_bloc_3/base/base_widget.dart';
import 'package:base_bloc_3/common/external_lib.dart';
import 'package:base_bloc_3/common/widgets/base_appbar.dart';
import 'package:base_bloc_3/common/widgets/base_scaffold.dart';
import 'package:base_bloc_3/di/di_setup.dart';
import 'package:base_bloc_3/features/conversation/presentation/bloc/contact_list_bloc.dart';
import 'package:base_bloc_3/features/login/presentation/bloc/login_bloc.dart';

class ContactListPage extends StatefulWidget{
  const ContactListPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ContactListPageState();
  }
}

class _ContactListPageState extends BaseState<ContactListPage,
    ContactListEvent, ContactListState, ContactListBloc> {

  @override
  void initState() {
    super.initState();
    final authState = getIt<LoginBloc>().state;
    bloc.add(ContactListEvent.loadContactList(userId: authState.userId));
  }

  @override
  Widget renderUI(BuildContext context) {
    return blocBuilder((context, state) {
      return BaseScaffold(
        appBar: _buildAppBar(),
        body: _buildBody(),
      );
    });
  }

  Widget _buildAppBar() {
    return BaseAppBar(
      title: 'Contact List',
      actions: [
        IconButton(
          onPressed: () {},
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
    return blocBuilder((context, state) {
      return ListView.builder(
        itemCount: 0,
        itemBuilder: (BuildContext context, int index) {},
      );
    });
  }

  Widget _buildContactItem(BuildContext context, Message message) {
    return Container();
  }
}