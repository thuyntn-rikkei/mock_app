import 'package:base_bloc_3/base/network/errors/error.dart';
import 'package:base_bloc_3/common/external_lib.dart';
import 'package:base_bloc_3/data/firebase/conversation/conversation_remote_datasource.dart';
import 'package:base_bloc_3/data/model/conversation/conversation_model.dart';
import 'package:base_bloc_3/data/model/message/text_message_model.dart';
import 'package:base_bloc_3/features/dashboard/domain/entity/conversation_entity.dart';
import 'package:base_bloc_3/features/dashboard/domain/repository/conversation_repository.dart';
import 'package:base_bloc_3/generated/l10n.dart';

@Injectable(as: ConversationRepository)
class ConversationRepositoryImpl implements ConversationRepository {
  final ConversationRemoteDatasource _conversationRemoteDatasource;
  ConversationRepositoryImpl(this._conversationRemoteDatasource);

  @override
  Future<Either<BaseError, ConversationEntity>> createConversation(ConversationEntity conversationEntity) async {
    try {
      final result = await _conversationRemoteDatasource.create(ConversationModel.fromEntity(conversationEntity));
      if (result == null) {
        return left(BaseError.httpUnknownError(S.current.not_found));
      }
      return right(ConversationEntity.fromModel(result));
    } on FirebaseException catch (exception) {
      return left(BaseError.httpUnknownError(exception.message ?? S.current.error_unknown));
    } catch (exception) {
      return left(BaseError.httpUnknownError(S.current.error_unknown));
    }
  }

  @override
  Future<Either<BaseError, List<ConversationEntity>>> fetchConversations(String userId) async {
    try {
      final result = await _conversationRemoteDatasource.fetchConversationsByUserId(userId);
      return right(result.map((e) => ConversationEntity.fromModel(e)).toList());
    } on FirebaseException catch (exception) {
      return left(BaseError.httpUnknownError(exception.message ?? S.current.error_unknown));
    } catch (exception) {
      return left(BaseError.httpUnknownError(S.current.error_unknown));
    }
  }
}
