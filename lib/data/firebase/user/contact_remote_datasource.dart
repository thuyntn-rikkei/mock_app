import 'package:base_bloc_3/common/external_lib.dart';
import 'package:base_bloc_3/data/model/user/contact_model.dart';
import 'package:firebase_database/firebase_database.dart';

@injectable
class ContactRemoteDatasource {
  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;

  DatabaseReference get contactRef => _firebaseDatabase.ref('contacts/');

  Future<ContactModel?> createContact(ContactModel contactModel) async {
    final newRef = contactRef.push();

    final newContact = contactModel.copyWith(contactId: newRef.key);

    await newRef.set(newContact.toJson());

    return newContact;
  }

  Future<List<ContactModel>> fetchContactsByUserId(String userId) async {
    final query1 = contactRef.orderByChild('userId').equalTo(userId);
    final snapshot1 = await query1.once();

    final query2 = contactRef.orderByChild('contactUserId').equalTo(userId);
    final snapshot2 = await query2.once();

    final allData = <ContactModel>[];

    if (snapshot1.snapshot.exists && snapshot1.snapshot.value is Map) {
      final data1 = snapshot1.snapshot.value as Map;
      allData.addAll(data1.values
          .whereType<Map<Object?, Object?>>()
          .map((e) => Map<String, dynamic>.from(e))
          .map(ContactModel.fromJson));
    }

    if (snapshot2.snapshot.exists && snapshot2.snapshot.value is Map) {
      final data2 = snapshot2.snapshot.value as Map;
      allData.addAll(
        data2.values
            .whereType<Map<Object?, Object?>>()
            .map((e) => Map<String, dynamic>.from(e))
            .map(ContactModel.fromJson),
      );
    }

    final uniqueContacts = {
      for (var contact in allData) contact.contactId: contact,
    }.values.toList();

    return uniqueContacts;
  }
}
