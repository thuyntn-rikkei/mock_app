import 'package:base_bloc_3/common/external_lib.dart';
import 'package:base_bloc_3/data/model/user/user_model.dart';
import 'package:base_bloc_3/features/login/domain/entity/user_entity.dart';
import 'package:firebase_database/firebase_database.dart';

@injectable
class UserRemoteDatasource {
  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;

  DatabaseReference get userRef => _firebaseDatabase.ref('users/');

  Future<void> createUser() async {
    userRef.push().set({
      'name': 'John Doe',
    });
  }

  Future<UserEntity?> logIn(String email, String password) async {
    try {
      final query = userRef.orderByChild('email').equalTo(email);
      final snapshot = await query.once();

      if (snapshot.snapshot.exists) {
        final data = snapshot.snapshot.value as Map<dynamic, dynamic>;

        for (final entry in data.entries) {
          final user = entry.value as Map<dynamic, dynamic>;

          if (user['password'] == password) {
            return UserEntity(
              userId: user['userId'],
              email: user['email'],
              fullName: user['fullName'],
              password: user['password'],
              avatarUrl: user['avatarUrl'],
            );
          }
        }

        return null;
      } else {
        return null;
      }
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  Future<UserModel?> signUp(String email, String password, String fullName) async {
    final newRef = userRef.push();
    final newUserId = newRef.key;

    if (newUserId != null) {
      final newUser = UserModel(
        userId: newUserId,
        email: email,
        fullName: fullName,
        password: password,
        avatarUrl: "",
      );

      await newRef.set(newUser.toJson());
      return newUser;
    } else {
      return null;
    }
  }

}