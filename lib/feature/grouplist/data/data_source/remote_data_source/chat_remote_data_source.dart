import 'dart:async';

import 'package:dio/dio.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:trailmate_mobile_app_assignment/app/constant/remote/api_endpoints.dart';
import 'package:trailmate_mobile_app_assignment/app/shared_pref/token_shared_prefs.dart';
import 'package:trailmate_mobile_app_assignment/core/error/failure.dart';
import 'package:trailmate_mobile_app_assignment/core/network/remote/api_service.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/data/data_source/chat_data_source.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/data/model/message_api_model.dart';

import '../../../domain/entity/message_entity.dart';

class ChatRemoteDataSourceImpl implements IChatDataSource {
  final ApiService _apiService;
  final TokenSharedPrefs _tokenSharedPrefs;

  // Use IO.Socket? to make it nullable. We will create and destroy it as needed.
  IO.Socket? _socket;

  // Make the StreamController private, only expose the stream.
  final StreamController<MessageApiModel> _messageStreamController =
      StreamController.broadcast();

  ChatRemoteDataSourceImpl({
    required ApiService apiService,
    required TokenSharedPrefs tokenSharedPrefs,
  }) : _apiService = apiService,
       _tokenSharedPrefs = tokenSharedPrefs;

  @override
  Stream<MessageEntity> get newMessagesStream {
    return _messageStreamController.stream.map(
      (messageApiModel) => messageApiModel.toEntity(),
    );
  }

  // --- FIX 2: REMOVE THE `_isInitialized` LOGIC FOR ROBUSTNESS ---
  @override
  void connectAndListen(String groupId) {
    // If a socket already exists, dispose of it first to ensure a clean slate.
    if (_socket != null) {
      _socket!.dispose();
    }

    // Create a new socket instance every time.
    _socket = IO.io(ApiEndpoints.serverAddress, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false, // We connect manually
    });

    // Attach all listeners to the new socket instance.
    _socket!.onConnectError((data) => print('❗️ Connection Error: $data'));
    _socket!.onConnect((_) {
      print('✅ Socket connected: ${_socket!.id}');
      // It's safe to call joinGroup here.
      joinGroup(groupId);
    });
    _socket!.on(ApiEndpoints.newMessage, (data) {
      print('📩 New message received: $data');
      try {
        _messageStreamController.add(MessageApiModel.fromJson(data));
      } catch (e) {
        print('Error parsing message from socket: $e');
      }
    });
    _socket!.onDisconnect((_) => print('❌ Socket disconnected'));

    // Manually trigger the connection attempt.
    _socket!.connect();
  }

  @override
  void joinGroup(String groupId) {
    // The check now is simple: is the socket instance not null and connected?
    if (_socket != null && _socket!.connected) {
      _socket!.emit(ApiEndpoints.socketJoinGroup, groupId);
      print('🤝 Emitted joinGroup event for: $groupId');
    } else {
      print(
        '⚠️ Cannot join group, socket is not connected. Waiting for onConnect callback.',
      );
      // The onConnect handler will automatically call joinGroup, so this is fine.
    }
  }

  @override
  Future<void> sendMessage(Map<String, dynamic> messageData) async {
    if (_socket == null || !_socket!.connected) {
      final errorMessage = 'Cannot send message. Socket is not connected.';
      print('⚠️ ERROR: $errorMessage');
      throw ApiFailure(message: errorMessage, statusCode: 503);
    }
    print('🚀 Emitting sendMessage event with data: $messageData');
    _socket!.emit(ApiEndpoints.socketSendMessage, messageData);
  }

  @override
  void dispose() {
    print('Disposing ChatDataSource...');
    _socket?.dispose(); // Safely dispose if it exists
    _socket = null; // Set to null
    // It's generally better to not close the broadcast controller if the app might reuse it.
    // However, if the DataSource is disposed for good, closing is correct.
    // _messageStreamController.close();
    print('ChatDataSource disposed.');
  }

  // --- No changes needed for getMessageHistory ---
  @override
  Future<List<MessageApiModel>> getMessageHistory(String groupId) async {
    // ... your existing implementation is fine
    try {
      final token = (await _tokenSharedPrefs.getToken()).getOrElse(
        () =>
            throw ApiFailure(
              message: "No token found. Please login.",
              statusCode: 401,
            ),
      );
      final response = await _apiService.dio.get(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.getMessagesForGroup(groupId)}',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        return (response.data['data'] as List)
            .map((msgJson) => MessageApiModel.fromJson(msgJson))
            .toList();
      } else {
        throw ApiFailure(
          message: 'Failed to load message history',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw ApiFailure(message: e.toString(), statusCode: 500);
    }
  }
}
