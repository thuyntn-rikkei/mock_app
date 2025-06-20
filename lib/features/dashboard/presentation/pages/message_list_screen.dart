import 'package:base_bloc_3/base/base_widget.dart';
import 'package:base_bloc_3/common/index.dart';
import 'package:base_bloc_3/common/utils/functions/date_time_formatter.dart';
import 'package:base_bloc_3/data/model/message/message_type_enum.dart';
import 'package:base_bloc_3/di/di_setup.dart';
import 'package:base_bloc_3/features/dashboard/domain/entity/conversation_entity.dart';
import 'package:base_bloc_3/features/dashboard/domain/entity/message_entity.dart';
import 'package:base_bloc_3/features/dashboard/presentation/bloc/message_list_bloc.dart';
import 'package:base_bloc_3/features/login/domain/entity/user_entity.dart';
import 'package:base_bloc_3/features/login/presentation/bloc/login_bloc.dart';
import 'package:base_bloc_3/routes/app_routes.dart';

class MessageListScreen extends StatefulWidget {
  const MessageListScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MessageListScreenState();
  }
}

class _MessageListScreenState extends BaseState<MessageListScreen,
    MessageListEvent, MessageListState, MessageListBloc> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;
  final int _debounceDelay = 500;

  @override
  void initState() {
    super.initState();
    final authState = getIt<LoginBloc>().state;
    _searchController.addListener(_onSearchChanged);
    bloc.add(MessageListEvent.listenConversation(userId: authState.userId));
  }

  void _onSearchChanged() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(
      Duration(milliseconds: _debounceDelay),
      () {
        bloc.add(
          MessageListEvent.search(query: _searchController.text),
        );
      },
    );
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
          onPressed: () async {
            await context.push(
              RouteName.contactList,
              extra: {
                'fromMessageList': true,
              },
            );
            // bloc.add(MessageListEvent.fetch(userId: getIt<LoginBloc>().state.userId));
          },
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
    return SearchBar(
      hintText: 'Search message',
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
                  bloc.add(const MessageListEvent.search(query: ''));
                },
                icon: const Icon(Icons.close),
              ),
            ]
          : null,
    );
  }

  Widget _buildMessageList() {
    final currentUserId = getIt<LoginBloc>().state.userId;
    return blocBuilder((context, state) {
      final conversations = state.searchedConversations;
      final users = state.users;
      return ListView.builder(
        itemCount: conversations.length,
        itemBuilder: (BuildContext context, int index) {
          final conversation = conversations[index];
          return _buildConversationItem(
            conversation,
            users,
            currentUserId,
          );
        },
      );
    });
  }

  Widget _buildConversationItem(
    ConversationEntity conversation,
    List<UserEntity> users,
    String currentUserId,
  ) {
    final formattedDateTime = formatMessageTime(
      DateTime.fromMillisecondsSinceEpoch(conversation.lastMessage!.timestamp),
    );

    final user = users.firstWhere((user) =>
        user.userId != currentUserId &&
        conversation.memberIds!.keys.contains(user.userId));

    final isText = conversation.lastMessage?.type == MessageType.text;

    final isRead = conversation.lastMessage?.isRead ?? false;

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          user.avatarUrl,
        ),
      ),
      title: Text(
        user.fullName,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Row(
        children: [
          isText
              ? Expanded(
                  child: Text(
                    (conversation.lastMessage as TextMessageEntity).text,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                      color: isRead ? Colors.grey : Colors.black,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
              : const Icon(Icons.image),
        ],
      ),
      trailing: Text(
        formattedDateTime,
        style: const TextStyle(
          fontSize: 13,
        ),
      ),
      onTap: () async {
        await context.push(
            RouteName.conversationDetailsPath(conversation.conversationId));
        // bloc.add(MessageListEvent.fetch(userId: currentUserId));
      },
    );
  }
}
