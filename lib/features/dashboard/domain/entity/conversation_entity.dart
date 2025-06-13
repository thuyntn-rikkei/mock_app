
import 'package:base_bloc_3/data/model/conversation/conversation_model.dart';
import 'package:base_bloc_3/features/dashboard/domain/entity/message_entity.dart';
import 'package:base_bloc_3/features/login/domain/entity/user_entity.dart';

class ConversationEntity {
  String conversationId;
  MessageEntity? lastMessage;
  List<UserEntity>? members;

  ConversationEntity({
    required this.conversationId,
    required this.lastMessage,
    required this.members,
  });

  factory ConversationEntity.fromModel(ConversationModel model) {
    return ConversationEntity(
      conversationId: model.conversationId,
      lastMessage: (model.lastMessage != null) ? TextMessageEntity.fromModel(model.lastMessage!) : null,
      members: model.members?.map((e) => UserEntity.fromModel(e)).toList(),
    );
  }
}

