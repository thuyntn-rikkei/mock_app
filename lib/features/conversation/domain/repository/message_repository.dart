
import 'package:base_bloc_3/base/network/errors/error.dart';
import 'package:base_bloc_3/features/dashboard/domain/entity/message_entity.dart';
import 'package:dartz/dartz.dart';

abstract class MessageRepository {
  // Future<Either<BaseError, MessageEntity>> createMessage(MessageEntity messageEntity);
  Future<Either<BaseError, List<MessageEntity>>> fetchMessagesByConversationId(String conversationId);
  Future<Either<BaseError, MessageEntity>> sendMessage(MessageEntity messageEntity);
  Stream<MessageEntity> listenToMessages(String conversationId, String currentUserId);
}