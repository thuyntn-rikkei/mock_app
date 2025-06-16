part of 'contact_list_bloc.dart';

@CopyWith()
class ContactListState extends BaseBlocState {
  final List<ContactEntity>? contactList;

  const ContactListState({
    required super.status,
    super.message,
    this.contactList = const [],
  });

  factory ContactListState.init() {
    return const ContactListState(
      status: BaseStateStatus.init,
    );
  }

  factory ContactListState.success() {
    return const ContactListState(
      status: BaseStateStatus.success,
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

  @override
  List get props => [status, message, contactList];
}
