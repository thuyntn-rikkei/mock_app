
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
    final query = contactRef.orderByChild('userId').equalTo(userId);
    final snapshot = await query.once();

    if (snapshot.snapshot.exists) {
      final data = snapshot.snapshot.value as Map<dynamic, dynamic>;
      return data.values
          .whereType<Map<Object?, Object?>>()
          .map((value) => Map<String, dynamic>.from(value))
          .map(ContactModel.fromJson)
          .toList();
    } else {
      return [];
    }
  }
}





















