part of 'contact_list_bloc.dart';

@CopyWith()
class ContactListState extends BaseBlocState {
  final List<ContactEntity> contactList;
  final List<UserEntity> userList;
  final String? conversationId;
  final List<UserEntity> searchedUserList;

  const ContactListState({
    required super.status,
    super.message,
    this.contactList = const [],
    this.userList = const [],
    this.conversationId,
    this.searchedUserList = const [],
  });

  factory ContactListState.init() {
    return const ContactListState(
      status: BaseStateStatus.init,
    );
  }

  factory ContactListState.success({required String conversationId}) {
    return ContactListState(
      status: BaseStateStatus.success,
      conversationId: conversationId,
    );
  }

  factory ContactListState.failed(
    String message,
  ) {
    return ContactListState(
      status: BaseStateStatus.failed,
      message: message,
    );
  }

  factory ContactListState.loading() {
    return const ContactListState(
      status: BaseStateStatus.loading,
    );
  }

  factory ContactListState.loadedUserList({required List<UserEntity> userList}) {
    return ContactListState(
      status: BaseStateStatus.init,
      userList: userList,
      searchedUserList: userList,
    );
  }

  @override
  List get props => [status, message, contactList, userList, searchedUserList];
}
