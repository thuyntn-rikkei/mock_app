
import 'package:base_bloc_3/common/external_lib.dart';
import 'package:base_bloc_3/di/di_setup.dart';
import 'package:base_bloc_3/features/login/domain/entity/user_entity.dart';
import 'package:base_bloc_3/features/login/presentation/bloc/login_bloc.dart';

Widget buildUserItem({
  required BuildContext context,
  required UserEntity user,
  required VoidCallback onTap,
}) {
  return ListTile(
    leading: CircleAvatar(
      backgroundImage: NetworkImage(user.avatarUrl),
    ),
    title: Text(user.fullName),
    subtitle: Text(user.email),
    onTap: onTap,
  );
}

Widget buildUserItem2({
  required BuildContext context,
  required UserEntity user,
  required VoidCallback onTap,
  required Widget trailing,
}) {
  return ListTile(
    leading: CircleAvatar(
      backgroundImage: NetworkImage(user.avatarUrl),
    ),
    title: Text(user.fullName),
    subtitle: Text(user.email),
    trailing: trailing,
    onTap: onTap,
  );
}