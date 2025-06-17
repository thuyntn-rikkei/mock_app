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
import 'package:base_bloc_3/features/login/presentation/bloc/login_bloc.dart';

class ConversationDetailsPage extends StatefulWidget {
  final String conversationId;

  const ConversationDetailsPage({super.key, required this.conversationId});

  @override
  State<StatefulWidget> createState() {
    return _ConversationDetailsPageState();
  }
}

class _ConversationDetailsPageState extends BaseShareState<
    ConversationDetailsPage,
    ConversationDetailsEvent,
    ConversationDetailsState,
    ConversationDetailsBloc> {
  @override
  void initState() {
    super.initState();
    bloc.add(
      ConversationDetailsEvent.loadConversationDetails(
        conversationId: widget.conversationId,
      ),
    );
  }

  @override
  void listener(BuildContext context, ConversationDetailsState state) {
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
      bloc.add(
        ConversationDetailsEvent.loadConversationDetails(
          conversationId: widget.conversationId,
        ),
      );
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
    return const BaseAppBar(
      title: 'Message',
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
