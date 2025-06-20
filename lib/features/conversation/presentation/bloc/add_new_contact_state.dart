part of 'add_new_contact_bloc.dart';

@CopyWith()
class AddNewContactState extends BaseBlocState {
  final List<UserEntity> users;
  final List<UserEntity> searchedUsers;

  const AddNewContactState({
    required super.status,
    super.message,
    this.users = const [],
    this.searchedUsers = const [],
  });

  factory AddNewContactState.init() {
    return const AddNewContactState(
      status: BaseStateStatus.init,
    );
  }

  factory AddNewContactState.success() {
    return const AddNewContactState(
      status: BaseStateStatus.success,
    );
  }

  factory AddNewContactState.failed(
    String message,
  ) {
    return AddNewContactState(
      status: BaseStateStatus.failed,
      message: message,
    );
  }

  factory AddNewContactState.loading() {
    return const AddNewContactState(
      status: BaseStateStatus.loading,
    );
  }

  factory AddNewContactState.loadedListUsers(List<UserEntity> newUsers) {
    return AddNewContactState(
      status: BaseStateStatus.init,
      users: newUsers,
    );
  }

  @override
  List get props => [status, message, users, searchedUsers];
}
