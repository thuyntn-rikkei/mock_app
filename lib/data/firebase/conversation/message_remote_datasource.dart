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
      return data.values.map((value) {
        if (value['type'] == 'text') {
          return TextMessageModel.fromJson(Map<String, dynamic>.from(value));
        } else {
          return ImageMessageModel.fromJson(Map<String, dynamic>.from(value));
        }
      }).toList();
    } else {
      return [];
    }
  }

  Future<MessageModel?> sendMessage(MessageModel messageModel) async {
    final newRef = messageRef.push();

    if (newRef.key == null) return null;

    switch (messageModel.type) {
      case MessageType.text:
        var newMessage = messageModel as TextMessageModel;
        await newRef.set(newMessage.copyWith(messageId: newRef.key!).toJson());
        return newMessage;
      case MessageType.image:
        var newMessage = messageModel as ImageMessageModel;
        await newRef.set(newMessage.copyWith(messageId: newRef.key!).toJson());
        return newMessage;
      default:
        return null;
    }
  }
}
