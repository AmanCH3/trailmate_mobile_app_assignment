class ApiEndpoints {
  ApiEndpoints._();

  // Timeouts
  static const connectionTimeout = Duration(seconds: 1000);
  static const receiveTimeout = Duration(seconds: 1000);

  // For Android Emulator
  static const String serverAddress = "http://10.0.2.2:5000";

  static const String baseUrl = "$serverAddress/api/";
  static const String imageUrl = "$serverAddress/uploads/";

  //==============Auth ==============
  static const String login = "auth/login";
  static const String register = "auth/register";

  // ========== trails =======
  static const String getAllTrails = "/trail";
  static const String createTrail = '/trail';
}
