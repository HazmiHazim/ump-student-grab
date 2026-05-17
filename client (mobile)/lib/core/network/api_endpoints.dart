class ApiEndpoints {
  // Auth
  static const String signup = '/api/auth/register';
  static const String login = '/api/auth/login';
  static const String logout = '/api/auth/logout';
  static const String forgotPassword = '/api/auth/forgot-password';
  static String userById(int id) => '/api/users/$id';

  // Attachments
  static String attachment(int id) => '/api/attachments/$id';

  // Chat
  static String chatsByUser(int userId) => '/api/chats/details/$userId';
  static String messages(int chatId, int userId, int participantId) =>
      '/api/chats/message/$chatId/$userId/$participantId';

  // Location
  static String createLocation(int userId) => '/api/locations/createLocation/$userId';

  // Places (proxied through backend)
  static const String placesAutocomplete = '/api/places/autocomplete';
  static const String placesSearch = '/api/places/search';
  static const String placesDirections = '/api/places/directions';

  // WebSocket
  static const String chatWs = '/ws/chat';
  static const String locationWs = '/location';
}
