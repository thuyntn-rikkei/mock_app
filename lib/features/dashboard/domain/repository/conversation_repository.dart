import 'package:base_bloc_3/base/network/errors/error.dart';
import 'package:base_bloc_3/features/dashboard/domain/entity/conversation_entity.dart';
import 'package:dartz/dartz.dart';

abstract class ConversationRepository {
  Future<Either<BaseError, ConversationEntity>> createConversation(ConversationEntity conversationEntity);
  Future<Either<BaseError, List<ConversationEntity>>> fetchConversations(String userId);
  Future<Either<BaseError, ConversationEntity?>> createIfNotExists(String userId1, String userId2);
}