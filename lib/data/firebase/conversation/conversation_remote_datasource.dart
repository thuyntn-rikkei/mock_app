import 'package:base_bloc_3/common/external_lib.dart';
import 'package:base_bloc_3/data/model/conversation/conversation_model.dart';
import 'package:base_bloc_3/data/model/user/user_model.dart';
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
      final conversationKey = generateConversationKey(conversation.memberIds?[0] ?? '', conversation.memberIds?[1] ?? '');

      final newConversation = ConversationModel(
        conversationKey,
        createdTimestamp: DateTime.now().millisecondsSinceEpoch,
        updatedTimestamp: DateTime.now().millisecondsSinceEpoch,
        lastMessage: null,
        memberIds: conversation.memberIds,
      );

      await newRef.set(newConversation.toJson());
      return newConversation;
    } else {
      return null;
    }
  }


  Future<List<ConversationModel>> fetchConversationsByUserId(
      String userId) async {
    final query = conversationRef.orderByChild('members/$userId').equalTo(true);
    final snapshot = await query.once();

    if (snapshot.snapshot.exists) {
      final data = snapshot.snapshot.value as Map<dynamic, dynamic>;
      return data.values
          .map((value) => ConversationModel.fromJson(value))
          .toList();
    } else {
      return [];
    }
  }

  Future<ConversationModel?> checkIfConversationExists(
      String userId1, String userId2) async {
    final key = generateConversationKey(userId1, userId2);
    final query = conversationRef.orderByChild('conversationId').equalTo(key);
    final snapshot = await query.once();

    if (snapshot.snapshot.exists) {
      final data = snapshot.snapshot.value as Map<dynamic, dynamic>;
      final first = data.values.first as Map<dynamic, dynamic>;
      return ConversationModel.fromJson(Map<String, dynamic>.from(first));
    } else {
      return null;
    }
  }

  String generateConversationKey(String userId1, String userId2) {
    final sorted = [userId1, userId2]..sort();
    return '${sorted[0]}_${sorted[1]}';
  }

  Future<ConversationModel> createIfNotExists(String userId1, String userId2) async {
    final existingConversation = await checkIfConversationExists(userId1, userId2);

    if (existingConversation != null) {
      return existingConversation;
    } else {
      final newConversation = ConversationModel(
        "",
        memberIds: [userId1, userId2],
      );
      await create(newConversation);
      return newConversation;
    }
  }
}
