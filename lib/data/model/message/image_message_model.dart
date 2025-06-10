import 'package:base_bloc_3/data/model/message/message_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'image_message_model.g.dart';
part 'image_message_model.freezed.dart';

@freezed
class ImageMessageModel with _$ImageMessageModel implements MessageModel {
  const factory ImageMessageModel({
    required String messageId,
    String? conversationId,
    String? senderId,
    String? receiverId,
    bool? isRead,
    int? timestamp,
    String? imageUrl,
  }) = _ImageMessageModel;

  factory ImageMessageModel.fromJson(Map<String, dynamic> json) =>
      _$ImageMessageModelFromJson(json);
}
