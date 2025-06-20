import 'package:base_bloc_3/base/base_widget.dart';
import 'package:base_bloc_3/base/bloc/bloc_status.dart';
import 'package:base_bloc_3/common/dialog/dialog_utils.dart';
import 'package:base_bloc_3/common/external_lib.dart';
import 'package:base_bloc_3/common/widgets/base_appbar.dart';
import 'package:base_bloc_3/common/widgets/base_scaffold.dart';
import 'package:base_bloc_3/di/di_setup.dart';
import 'package:base_bloc_3/features/conversation/presentation/bloc/add_new_contact_bloc.dart';
import 'package:base_bloc_3/features/conversation/presentation/widgets/user_item_widget.dart';
import 'package:base_bloc_3/features/login/domain/entity/user_entity.dart';
import 'package:base_bloc_3/features/login/presentation/bloc/login_bloc.dart';

class AddNewContactPage extends StatefulWidget {
  const AddNewContactPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AddNewContactPageState();
  }
}

class _AddNewContactPageState extends BaseShareState<AddNewContactPage,
    AddNewContactEvent, AddNewContactState, AddNewContactBloc> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;
  final int _debounceDelay = 500;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);

    bloc.add(const AddNewContactEvent.started());
  }

  void _onSearchChanged() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(
      Duration(milliseconds: _debounceDelay),
      () {
        bloc.add(
          AddNewContactEvent.search(query: _searchController.text),
        );
      },
    );
  }

  @override
  void listener(BuildContext context, AddNewContactState state) {
    super.listener(context, state);

    if (state.status == BaseStateStatus.success) {
      context.pop();
    }
  }

  @override
  Widget renderUI(BuildContext context) {
    return blocBuilder(
      builder: (BuildContext c, AddNewContactState s) {
        return BaseScaffold(
          appBar: _buildAppBar(),
          body: _buildBody(),
        );
      },
    );
  }

  Widget _buildAppBar() {
    return BaseAppBar(
      title: 'Add New Contact',
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
          Expanded(child: _buildUserList()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return SearchBar(
      hintText: 'Search user',
      leading: const Icon(Icons.search),
      padding: const WidgetStatePropertyAll<EdgeInsets>(
        EdgeInsets.symmetric(horizontal: 16),
      ),
      elevation: const WidgetStatePropertyAll(0),
      controller: _searchController,
    );
  }

  Widget _buildUserList() {
    final users = bloc.state.searchedUsers;
    final contacts = bloc.state.contacts;
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (BuildContext context, int index) {
        final user = users[index];
        final currentUserId = getIt<LoginBloc>().state.userId;
        final trailingWidget = user.userId == currentUserId
            ? const Text(
                'You',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              )
            : (contacts.any((element) => element.contactUserId == user.userId)
                ? const Text(
                    'Friend',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.green,
                    ),
                  )
                : const Icon(Icons.add));

        final onTap = user.userId == currentUserId
            ? () {
                bloc.add(const AddNewContactEvent.addMyself());
              }
            : (contacts.any((element) => element.contactUserId == user.userId)
                ? () {
                    bloc.add(
                      AddNewContactEvent.addExistingContact(
                        user.fullName,
                      ),
                    );
                  }
                : () {
                    final userId = getIt<LoginBloc>().state.userId;
                    final user = users[index];
                    bloc.add(
                      AddNewContactEvent.addNewContact(
                        userId: userId,
                        contactUserId: user.userId,
                      ),
                    );
                  });

        return buildUserItem2(
          context: context,
          user: users[index],
          onTap: onTap,
          trailing: trailingWidget,
        );
      },
    );
  }
}
