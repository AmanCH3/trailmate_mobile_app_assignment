class ApiEndpoints {
  ApiEndpoints._();

  // Timeouts
  static const connectionTimeout = Duration(seconds: 30);
  static const receiveTimeout = Duration(seconds: 30);

  static const String serverAddress = "http://192.168.1.14:5050";

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
}
