
import 'package:firebase_database/firebase_database.dart';

class UserRemoteDatasource {
  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;

  DatabaseReference get userRef => _firebaseDatabase.ref('users');

  Future<void> createUser() async {

  }
}