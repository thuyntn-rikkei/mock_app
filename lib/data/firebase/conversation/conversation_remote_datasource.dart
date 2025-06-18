import 'package:base_bloc_3/common/external_lib.dart';
import 'package:base_bloc_3/data/model/conversation/conversation_model.dart';
import 'package:base_bloc_3/data/model/message/image_message_model.dart';
import 'package:base_bloc_3/data/model/message/message_model.dart';
import 'package:base_bloc_3/data/model/message/text_message_model.dart';
import 'package:base_bloc_3/data/model/user/user_model.dart';
import 'package:firebase_database/firebase_database.dart';

@injectable
class ConversationRemoteDatasource {
  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;

  DatabaseReference get conversationRef =>
      _firebaseDatabase.ref('conversations/');

  Future<ConversationModel?> create(ConversationModel conversation) async {
    try {
      final newRef = conversationRef.push();
      final newConversationId = newRef.key;

      if (newConversationId != null && conversation.memberIds != null) {
        final memberIdsList = conversation.memberIds?.keys.toList();

        if (memberIdsList!.isEmpty) {
          print('Error: Cannot create conversation without members');
          return null;
        }

        final conversationKey = memberIdsList.length >= 2
            ? generateConversationKey(memberIdsList[0], memberIdsList[1])
            : generateConversationKey(memberIdsList[0], '');

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
        print(
            'Error: Failed to generate conversation ID or no members provided');
        return null;
      }
    } catch (e) {
      print('Error creating conversation: $e');
      return null;
    }
  }

  Future<List<ConversationModel>> fetchConversationsByUserId(
    String userId,
  ) async {
    final query =
        conversationRef.orderByChild('memberIds/$userId').equalTo(true);
    final snapshot = await query.once();

    if (snapshot.snapshot.exists) {
      final data = snapshot.snapshot.value as Map<dynamic, dynamic>;
      return data.entries.map(
        (entry) {
          final rawData = entry.value as Map<dynamic, dynamic>;
          final processedData = preprocessConversationData(rawData);
          return ConversationModel.fromJson(processedData);
        },
      ).toList();
    } else {
      return [];
    }
  }

  Future<ConversationModel?> checkIfConversationExists(
    String userId1,
    String userId2,
  ) async {
    final key = generateConversationKey(userId1, userId2);
    final query = conversationRef.orderByChild('conversationId').equalTo(key);
    final snapshot = await query.once();

    if (snapshot.snapshot.exists) {
      final data = snapshot.snapshot.value as Map<dynamic, dynamic>;
      final conversationEntry = data.entries.first;
      final rawData = conversationEntry.value as Map<dynamic, dynamic>;

      final processedData = preprocessConversationData(rawData);

      return ConversationModel.fromJson(processedData);
    } else {
      return null;
    }
  }

  String generateConversationKey(String userId1, String userId2) {
    final sorted = [userId1, userId2]..sort();
    return '${sorted[0]}_${sorted[1]}';
  }

  Future<ConversationModel> createIfNotExists(
      String userId1, String userId2) async {
    final existingConversation =
        await checkIfConversationExists(userId1, userId2);

    if (existingConversation != null) {
      return existingConversation;
    } else {
      final newConversation =
          ConversationModel("", memberIds: {userId1: true, userId2: true});
      await create(newConversation);
      return newConversation;
    }
  }

  Future<ConversationModel?> updateLastMessage(
      String conversationId, MessageModel message) async {
    final query =
        conversationRef.orderByChild('conversationId').equalTo(conversationId);
    final snapshot = await query.once();

    if (snapshot.snapshot.exists) {
      final data = snapshot.snapshot.value as Map<dynamic, dynamic>;

      final conversationKey = data.keys.first;
      final conversationData = Map<String, dynamic>.from(data[conversationKey]);

      final lastMessageData = conversationData['lastMessage'];

      if (lastMessageData != null) {
        final messageType = lastMessageData['type'];
        final lastMessageModel = messageType == 'text'
            ? TextMessageModel.fromJson(
                Map<String, dynamic>.from(lastMessageData))
            : ImageMessageModel.fromJson(
                Map<String, dynamic>.from(lastMessageData));

        if ((lastMessageModel.timestamp ?? 0) < (message.timestamp ?? 0)) {
          final updatedConversation = ConversationModel.fromJson(
            preprocessConversationData(conversationData),
          ).copyWith(
            lastMessage: message,
            updatedTimestamp: DateTime.now().millisecondsSinceEpoch,
          );

          await conversationRef.child(conversationKey).update(
            updatedConversation.toJson(),
          );

          return updatedConversation;
        } else {
          return null;
        }
      } else {
        final existingConversation = ConversationModel.fromJson(
            preprocessConversationData(conversationData));
        final updatedConversation = existingConversation.copyWith(
          lastMessage: message,
        );
        await conversationRef
            .child(conversationKey)
            .update(updatedConversation.toJson());
        return updatedConversation;
      }
    } else {
      return null;
    }
  }

  dynamic convertFirebaseData(dynamic data) {
    if (data is Map) {
      final converted = <String, dynamic>{};
      data.forEach((key, value) {
        converted[key.toString()] = convertFirebaseData(value);
      });
      return converted;
    } else if (data is List) {
      return data.map((item) => convertFirebaseData(item)).toList();
    } else {
      return data;
    }
  }

  Map<String, dynamic> preprocessConversationData(
      Map<dynamic, dynamic> firebaseData) {
    return convertFirebaseData(firebaseData) as Map<String, dynamic>;
  }
}
