import 'package:base_bloc_3/base/base_widget.dart';
import 'package:base_bloc_3/common/index.dart';
import 'package:base_bloc_3/common/utils/functions/date_time_formatter.dart';
import 'package:base_bloc_3/data/model/message/message_type_enum.dart';
import 'package:base_bloc_3/data/model/message/text_message_model.dart';
import 'package:base_bloc_3/di/di_setup.dart';
import 'package:base_bloc_3/features/dashboard/domain/entity/conversation_entity.dart';
import 'package:base_bloc_3/features/dashboard/domain/entity/message_entity.dart';
import 'package:base_bloc_3/features/dashboard/presentation/bloc/message_list_bloc.dart';
import 'package:base_bloc_3/features/login/domain/entity/user_entity.dart';
import 'package:base_bloc_3/features/login/presentation/bloc/login_bloc.dart';
import 'package:base_bloc_3/features/setting_app/bloc/setting_bloc.dart';
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
  @override
  void initState() {
    super.initState();
    final authState = getIt<LoginBloc>().state;
    bloc.add(MessageListEvent.fetch(userId: authState.userId));
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
          onPressed: () {
            context.push(RouteName.contactList);
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
    final currentUserId = getIt<LoginBloc>().state.userId;
    return blocBuilder((context, state) {
      return ListView.builder(
        itemCount: state.conversations.length,
        itemBuilder: (BuildContext context, int index) {
          final conversation = state.conversations[index];
          return _buildConversationItem(
              conversation, state.users, currentUserId);
        },
      );
    });
  }

  Widget _buildConversationItem(ConversationEntity conversation,
      List<UserEntity> users, String currentUserId) {
    final formattedDateTime = formatMessageTime(
      DateTime.fromMillisecondsSinceEpoch(conversation.lastMessage!.timestamp),
    );

    final user = users.firstWhere((user) => user.userId != currentUserId);

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
              ? Text(
                  (conversation.lastMessage as TextMessageEntity).text,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
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
      onTap: () {
        context.push(RouteName.conversationDetailsPath(conversation.conversationId));
      },
    );
  }
}
