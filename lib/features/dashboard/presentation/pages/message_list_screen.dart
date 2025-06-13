import 'package:base_bloc_3/base/base_widget.dart';
import 'package:base_bloc_3/common/index.dart';
import 'package:base_bloc_3/features/dashboard/presentation/bloc/message_list_bloc.dart';
import 'package:base_bloc_3/features/setting_app/bloc/setting_bloc.dart';

class MessageListScreen extends StatefulWidget {
  const MessageListScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MessageListScreenState();
  }
}

class _MessageListScreenState extends BaseState<MessageListScreen,
    MessageListEvent, MessageListState, MessageListBloc> {

  @override
  void initState() {
    super.initState();
    bloc.add(const MessageListEvent.fetch());
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
      title: 'Message List',
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.add_circle),
        ),
      ],
      hasBack: false,
    );
  }

  Widget _buildBody() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSearchBar(),
          Expanded(child: _buildMessageList()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return const SearchBar(
      hintText: 'Search message',
      leading: Icon(Icons.search),
      padding: WidgetStatePropertyAll<EdgeInsets>(
        EdgeInsets.symmetric(horizontal: 16),
      ),
      elevation: WidgetStatePropertyAll(0),
    );
  }

  Widget _buildMessageList() {
    return blocBuilder((context, state) {
      return ListView.builder(
        itemCount: 0,
        itemBuilder: (BuildContext context, int index) {},
      );
    });
  }

  Widget _buildMessageItem(BuildContext context, Message message) {
    return Container();
  }
}
