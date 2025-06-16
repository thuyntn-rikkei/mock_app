import 'package:base_bloc_3/data/model/message/message_model.dart';
import 'package:base_bloc_3/data/model/message/message_type_enum.dart';
import 'package:base_bloc_3/features/dashboard/domain/entity/message_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'image_message_model.g.dart';
part 'image_message_model.freezed.dart';

@freezed
class ImageMessageModel with _$ImageMessageModel implements MessageModel {
  const factory ImageMessageModel({
    required String messageId,
    String? conversationId,
    String? senderId,
    bool? isRead,
    int? timestamp,
    String? imageUrl,
    MessageType? type,
  }) = _ImageMessageModel;

  factory ImageMessageModel.fromJson(Map<String, dynamic> json) =>
      _$ImageMessageModelFromJson(json);

  factory ImageMessageModel.fromEntity(ImageMessageEntity entity) {
    return ImageMessageModel(
        messageId: entity.messageId,
        conversationId: entity.conversationId,
        senderId: entity.senderId,
        isRead: entity.isRead,
        imageUrl: entity.imageUrl,
        type: entity.type,
    );
  }
}
