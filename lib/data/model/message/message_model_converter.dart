import 'package:base_bloc_3/common/external_lib.dart';
import 'package:base_bloc_3/data/model/message/image_message_model.dart';
import 'package:base_bloc_3/data/model/message/message_model.dart';
import 'package:base_bloc_3/data/model/message/message_type_enum.dart';
import 'package:base_bloc_3/data/model/message/text_message_model.dart';

class MessageModelConverter implements JsonConverter<MessageModel, Map<String, dynamic>> {
  const MessageModelConverter();

  @override
  MessageModel fromJson(Map<String, dynamic> json) {
    if(json["type"] == MessageType.text.name){
      return TextMessageModel.fromJson(json);
    } else if (json["type"] == MessageType.image.name) {
      return ImageMessageModel.fromJson(json);
    }
    throw UnimplementedError('Unknown message type: ${json['type']}');
  }

  @override
  Map<String, dynamic> toJson(MessageModel object){
    if (object is TextMessageModel) {
      return object.toJson();
    } else if (object is ImageMessageModel) {
      return object.toJson();
    } else {
      throw UnimplementedError('Unknown message type: ${object.runtimeType}');
    }
  }
}