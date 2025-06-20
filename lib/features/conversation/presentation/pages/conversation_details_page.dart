import 'package:base_bloc_3/base/base_widget.dart';
import 'package:base_bloc_3/base/bloc/bloc_status.dart';
import 'package:base_bloc_3/common/dialog/dialog_utils.dart';
import 'package:base_bloc_3/common/external_lib.dart';
import 'package:base_bloc_3/common/widgets/base_appbar.dart';
import 'package:base_bloc_3/common/widgets/base_scaffold.dart';
import 'package:base_bloc_3/di/di_setup.dart';
import 'package:base_bloc_3/features/conversation/presentation/bloc/conversation_details_bloc.dart';
import 'package:base_bloc_3/features/conversation/presentation/widgets/chat_input_item.dart';
import 'package:base_bloc_3/features/conversation/presentation/widgets/message_item_widget.dart';
import 'package:base_bloc_3/features/login/domain/entity/user_entity.dart';
import 'package:base_bloc_3/features/login/presentation/bloc/login_bloc.dart';

class ConversationDetailsPage extends StatefulWidget {
  final String conversationId;

  const ConversationDetailsPage({super.key, required this.conversationId});

  @override
  State<StatefulWidget> createState() {
    return _ConversationDetailsPageState();
  }
}

class _ConversationDetailsPageState extends BaseState<
    ConversationDetailsPage,
    ConversationDetailsEvent,
    ConversationDetailsState,
    ConversationDetailsBloc> {
  @override
  void initState() {
    super.initState();
    bloc.add(
      ConversationDetailsEvent.listenToMessages(
        conversationId: widget.conversationId,
        currentUserId: getIt<LoginBloc>().state.userId,
      ),
    );
    bloc.add(
      ConversationDetailsEvent.getConversationDetails(
          conversationId: widget.conversationId),
    );
  }


  @override
  void dispose() {
    super.dispose();
    bloc.messageSubscription?.cancel();
  }

  @override
  Widget renderUI(BuildContext context) {
    return blocBuilder(
      (context, state) {
        return BaseScaffold(
          appBar: _buildAppBar(state),
          body: _buildBody(),
        );
      },
    );
  }

  Widget _buildAppBar(ConversationDetailsState state) {
    if(state.status == BaseStateStatus.success){
      return BaseAppBar(
        appBarWidget: _buildMessageAppBar(state.members.first),
      );
    }
    else{
      return const BaseAppBar(
        title: 'Conversation Details',
      );
    }
  }

  Widget _buildMessageAppBar(UserEntity user){
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(user.avatarUrl),
      ),
      title: Text(
        user.fullName,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        )
      ),
    );
  }

  Widget _buildBody() {
    TextEditingController textController = TextEditingController();
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(child: _buildMessages()),
          chatInput(
            context: context,
            textController: textController,
            isUploading: false,
            onSend: (String message) {
              var senderId = getIt<LoginBloc>().state.userId;
              bloc.add(
                ConversationDetailsEvent.sendMessage(
                  message: message,
                  conversationId: widget.conversationId,
                  senderId: senderId,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMessages() {
    final messages = bloc.state.messages;
    final currentUserId = getIt<LoginBloc>().state.userId;
    return ListView.builder(
      itemCount: messages.length,
      reverse: true,
      itemBuilder: (BuildContext context, int index) {
        final message = messages[index];
        final isOwnMessage = message.senderId == currentUserId;
        return buildMessageItem(
          context: context,
          message: message,
          isOwnMessage: isOwnMessage,
        );
      },
    );
  }
}
