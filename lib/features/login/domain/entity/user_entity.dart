import 'package:base_bloc_3/data/model/user/user_model.dart';

class UserEntity {
  String userId;
  String email;
  String fullName;
  String password;
  String avatarUrl;

  UserEntity({
    required this.userId,
    required this.email,
    required this.fullName,
    required this.password,
    required this.avatarUrl,
  });

  factory UserEntity.fromModel(UserModel model) {
    return UserEntity(
      userId: model.userId,
      email: model.email ?? "",
      fullName: model.fullName ?? "",
      password: model.password ?? "",
      avatarUrl: model.avatarUrl ?? "",
    );
  }
}
