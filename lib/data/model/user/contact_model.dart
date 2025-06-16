
import 'package:base_bloc_3/features/conversation/domain/entity/contact_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_model.g.dart';
part 'contact_model.freezed.dart';

@freezed
class ContactModel with _$ContactModel {
  const factory ContactModel({
    String? contactId,
    String? userId,
    String? contactUserId,
  } ) = _ContactModel;

  factory ContactModel.fromJson(Map<String, dynamic> json) => _$ContactModelFromJson(json);

  factory ContactModel.fromEntity(ContactEntity entity) {
    return ContactModel(
      contactId: entity.contactId,
      userId: entity.userId,
      contactUserId: entity.contactUserId,
    );
  }
}
