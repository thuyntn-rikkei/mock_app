class RouteName {
  static const String home = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String example = '/example';
  static const String talkerScreen = '/talkerScreen';
  static const String contactList = '/contactList';
  static const String addContact = '/addContact';
  static const String conversationDetails = '/conversations/:conversationId';
  static const String personalInformation = '/personalInformation';

  static String conversationDetailsPath(String conversationId) =>
      '/conversations/$conversationId';

  static const publicRoutes = [
    login,
    register,
  ];
}
