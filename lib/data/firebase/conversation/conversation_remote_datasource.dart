import 'package:base_bloc_3/common/external_lib.dart';
import 'package:base_bloc_3/data/model/conversation/conversation_model.dart';
import 'package:firebase_database/firebase_database.dart';

@injectable
class ConversationRemoteDatasource {
  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;

  DatabaseReference get conversationRef =>
      _firebaseDatabase.ref('conversations/');

  Future<ConversationModel?> create(ConversationModel conversation) async {
    final newRef = conversationRef.push();
    final newConversationId = newRef.key;

    if (newConversationId != null) {
      final newConversation = ConversationModel(
        newConversationId,
        createdTimestamp: DateTime
            .now()
            .millisecondsSinceEpoch,
        updatedTimestamp: DateTime
            .now()
            .millisecondsSinceEpoch,
        lastMessage: conversation.lastMessage,
        members: conversation.members,
      );

      await newRef.set(newConversation.toJson());
      return newConversation;
    } else {
      return null;
    }
  }


  Future<List<ConversationModel>> fetch() async {
    final snapshot = await conversationRef.once();
    final data = snapshot.snapshot.value as Map<String, dynamic>?;

    if (data != null) {
      final conversations = data.values
          .map((json) =>
          ConversationModel.fromJson(json as Map<String, dynamic>))
          .toList();
      return conversations;
    }
    return [];
  }
}
