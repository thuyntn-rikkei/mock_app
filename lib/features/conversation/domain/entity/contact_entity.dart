import 'package:base_bloc_3/data/model/user/contact_model.dart';

class ContactEntity{
  String contactId;
  String userId;
  String contactUserId;

  ContactEntity({
    required this.contactId,
    required this.userId,
    required this.contactUserId,
  });

  factory ContactEntity.fromModel(ContactModel model) {
    return ContactEntity(
      contactId: model.contactId ?? "",
      userId: model.userId ?? "",
      contactUserId: model.contactUserId ?? "",
    );
  }
}