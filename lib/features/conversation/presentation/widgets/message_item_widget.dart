import 'package:base_bloc_3/common/external_lib.dart';
import 'package:base_bloc_3/common/utils/functions/date_time_formatter.dart';
import 'package:base_bloc_3/data/model/message/message_type_enum.dart';
import 'package:base_bloc_3/features/conversation/presentation/widgets/message_card_item.dart';
import 'package:base_bloc_3/features/dashboard/domain/entity/message_entity.dart';

Widget buildMessageItem({
  required BuildContext context,
  required MessageEntity message,
  required bool isOwnMessage,
}) {
  Widget content;

  final formattedDateTime = formatMessageTime(
    DateTime.fromMillisecondsSinceEpoch(message.timestamp),
  );

  if (message.type == MessageType.text) {
    if(isOwnMessage){
      content = OwnMessageCard(
        key: ValueKey(message.messageId),
        message: (message as TextMessageEntity).text,
        time: formattedDateTime,
      );
    }else{
      content = OtherMessageCard(
        key: ValueKey(message.messageId),
        message: (message as TextMessageEntity).text,
        time: formattedDateTime,
      );
    }
  } else if (message.type == MessageType.image) {
    content = Image.network(
      (message as ImageMessageEntity).imageUrl,
      width: 100,
      height: 100,
      fit: BoxFit.cover,
    );
  } else {
    content = const SizedBox();
  }
  return Padding(
    padding: const EdgeInsets.all(8),
    child: content,
  );
}
