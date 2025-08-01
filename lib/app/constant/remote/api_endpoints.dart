class ApiEndpoints {
  ApiEndpoints._();

  // Timeouts
  static const connectionTimeout = Duration(seconds: 30);
  static const receiveTimeout = Duration(seconds: 30);

  // http://10.0.2.2:3000 - for emulator
  // http://192.168.1.14 - for device

  static const String serverAddress = "http://10.84.77.244:5050";

  static const String baseUrl = "$serverAddress/api/";
  static const String imageUrl = "$serverAddress/uploads/";

  //==============Auth ==============
  static const String login = "auth/login";
  static const String register = "auth/register";

  //  =================user ================
  static const String getUser = "user/me";
  static const String updateUser = "user/update";
  static const String deleteUser = 'user/delete';

  // ========== trails =======
  static const String getAllTrails = "/trail";
  static const String createTrail = '/trail';
  static const String completeTrail = "/trail/joined/:joinedTrailId/complete";
  static const String cancelTrail = "/trail/joined/:joinedTrailId/cancel";
  static const String joinedTrailDate = '/trail/:id/join-with-date';

  // ===groups ===============
  // Group Endpoints
  static const String groups = "/group";
  static const String createGroup = "$groups/create";

  // Dynamic Endpoints
  static String groupById(String groupId) => "$groups/$groupId";

  static String requestToJoin(String groupId) =>
      "$groups/$groupId/request-join";

  // Admin-only endpoints - good to have them defined anyway
  static String approveRequest(String groupId, String requestId) =>
      "$groups/$groupId/requests/$requestId/approve";

  static String denyRequest(String groupId, String requestId) =>
      "$groups/$groupId/requests/$requestId/deny";
  static String pendingRequests = "$groups/requests/pending";

  // ================ Messages (HTTP) ================
  // The base path for message-related endpoints.
  static const String messages = "messages";

  static String getMessagesForGroup(String groupId) => "$messages/$groupId";

  static const String socketJoinGroup = "joinGroup";
  static const String socketLeaveGroup = "leaveGroup";
  static const String socketSendMessage = "sendMessage";
  static const String newMessage = "newMessage";

  // ===============checklist ===============
  static const String generateCheckList = 'checklist/generate';

  // ==============sensor for api to count the number of steps =======
  static const String saveSteps = "steps";
  static const String totalSteps = "steps/total";

  // ==== chatbot API endpoints ====
  static const String chatQuery = '/v1/chatbot/query';

  static const String updateMyStats = 'users/me/stats';
}
