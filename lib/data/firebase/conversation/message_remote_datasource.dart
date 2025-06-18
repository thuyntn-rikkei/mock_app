import 'package:base_bloc_3/common/external_lib.dart';
import 'package:base_bloc_3/data/model/message/image_message_model.dart';
import 'package:base_bloc_3/data/model/message/message_model.dart';
import 'package:base_bloc_3/data/model/message/message_type_enum.dart';
import 'package:base_bloc_3/data/model/message/text_message_model.dart';
import 'package:firebase_database/firebase_database.dart';

@injectable
class MessageRemoteDatasource {
  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;

  DatabaseReference get messageRef => _firebaseDatabase.ref('messages/');

  Future<List<MessageModel>?> fetchMessagesByConversationId(
      String conversationId,
      ) async {
    final query = messageRef.orderByChild('conversationId').equalTo(conversationId);
    final snapshot = await query.once();

    if (snapshot.snapshot.exists) {
      final data = snapshot.snapshot.value as Map<dynamic, dynamic>;

      final messages = data.values.map((value) {
        final map = Map<String, dynamic>.from(value);
        if (map['type'] == 'text') {
          return TextMessageModel.fromJson(map);
        } else {
          return ImageMessageModel.fromJson(map);
        }
      }).toList();

      return messages;
    } else {
      return [];
    }
  }


  Future<MessageModel?> sendMessage(MessageModel messageModel) async {
    final newRef = messageRef.push();

    if (newRef.key == null) return null;

    switch (messageModel.type) {
      case MessageType.text:
        var newMessage = (messageModel as TextMessageModel).copyWith(messageId: newRef.key!);
        await newRef.set(newMessage.toJson());
        return newMessage;
      case MessageType.image:
        var newMessage = (messageModel as ImageMessageModel).copyWith(messageId: newRef.key!);
        await newRef.set(newMessage.toJson());
        return newMessage;
      default:
        return null;
    }
  }

  Stream<MessageModel> listenToMessages(String conversationId, String currentUserId) {
    return messageRef
        .orderByChild('conversationId')
        .equalTo(conversationId)
        .onChildAdded
        .map((event) {
      final map = Map<String, dynamic>.from(event.snapshot.value as Map);
      final messageType = map['type'];

      MessageModel message;
      if (messageType == 'text') {
        message = TextMessageModel.fromJson(map);
      } else {
        message = ImageMessageModel.fromJson(map);
      }

      return message;
    });
  }
}
