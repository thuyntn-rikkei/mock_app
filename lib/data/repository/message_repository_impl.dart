import 'package:base_bloc_3/base/network/errors/error.dart';
import 'package:base_bloc_3/common/external_lib.dart';
import 'package:base_bloc_3/data/firebase/conversation/message_remote_datasource.dart';
import 'package:base_bloc_3/data/model/message/message_model.dart';
import 'package:base_bloc_3/features/conversation/domain/repository/message_repository.dart';
import 'package:base_bloc_3/features/dashboard/domain/entity/message_entity.dart';
import 'package:base_bloc_3/generated/l10n.dart';

@Injectable(as: MessageRepository)
class MessageRepositoryImpl implements MessageRepository {
  final MessageRemoteDatasource _messageRemoteDatasource;

  MessageRepositoryImpl(this._messageRemoteDatasource);

  // @override
  // Future<Either<BaseError, MessageEntity>> createMessage(MessageEntity messageEntity) {
  //   try {
  //     final result = await _messageRemoteDatasource.cr
  //     if (result == null) {
  //       return left(BaseError.httpUnknownError(S.current.not_found));
  //     }
  //     final messages = result.map((e) => MessageEntity.fromModel(e)).toList();
  //     return right(messages);
  //   } on FirebaseException catch (exception) {
  //     return left(BaseError.httpUnknownError(
  //         exception.message ?? S.current.error_unknown));
  //   } catch (exception) {
  //     return left(BaseError.httpUnknownError(S.current.error_unknown));
  //   }
  // }

  @override
  Future<Either<BaseError, List<MessageEntity>>> fetchMessagesByConversationId(
    String conversationId,
  ) async {
    try {
      final result = await _messageRemoteDatasource.fetchMessagesByConversationId(conversationId);
      if (result == null) {
        return left(BaseError.httpUnknownError(S.current.not_found));
      }
      final messages = result.map((e) => MessageEntity.fromModel(e)).toList();
      return right(messages);
    } on FirebaseException catch (exception) {
      return left(
        BaseError.httpUnknownError(
          exception.message ?? S.current.error_unknown,
        ),
      );
    } catch (exception) {
      return left(BaseError.httpUnknownError(S.current.error_unknown));
    }
  }

  @override
  Future<Either<BaseError, MessageEntity>> sendMessage(
    MessageEntity messageEntity,
  ) async {
    try {
      final result = await _messageRemoteDatasource
          .sendMessage(MessageModel.fromEntity(messageEntity));
      if (result == null) {
        return left(BaseError.httpUnknownError(S.current.not_found));
      }
      return right(MessageEntity.fromModel(result));
    } on FirebaseException catch (exception) {
      return left(
        BaseError.httpUnknownError(
          exception.message ?? S.current.error_unknown,
        ),
      );
    } catch (exception) {
      return left(BaseError.httpUnknownError(S.current.error_unknown));
    }
  }
}
