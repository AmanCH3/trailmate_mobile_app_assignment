// FILE: lib/feature/grouplist/data/data_source/remote/chat_remote_data_source_impl.dart
// (Or wherever this file is located)

import 'dart:async';
import 'package:dio/dio.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:trailmate_mobile_app_assignment/app/constant/remote/api_endpoints.dart';
import 'package:trailmate_mobile_app_assignment/app/shared_pref/token_shared_prefs.dart';
import 'package:trailmate_mobile_app_assignment/core/error/failure.dart';
import 'package:trailmate_mobile_app_assignment/core/network/remote/api_service.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/data/data_source/chat_data_source.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/data/model/message_api_model.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/domain/entity/message_entity.dart';

class ChatRemoteDataSourceImpl implements IChatDataSource {
  final ApiService _apiService;
  final TokenSharedPrefs _tokenSharedPrefs;

  late IO.Socket _socket;
  final StreamController<MessageApiModel> _messageStreamController =
      StreamController.broadcast();
  bool _isInitialized = false;

  ChatRemoteDataSourceImpl({
    required ApiService apiService,
    required TokenSharedPrefs tokenSharedPrefs,
  }) : _apiService = apiService,
       _tokenSharedPrefs = tokenSharedPrefs;

  @override
  Stream<MessageApiModel> get newMessageStream =>
      _messageStreamController.stream;

  @override
  void connectAndListen(String groupId) {
    if (_isInitialized) {
      print('Socket already initialized. Re-joining group: $groupId');
      joinGroup(groupId);
      return;
    }

    _socket = IO.io(ApiEndpoints.serverAddress, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    _isInitialized = true;

    _socket.onConnectError((data) => print('❗️ Connection Error: $data'));
    _socket.onConnect((_) {
      print('✅ Socket connected: ${_socket.id}');
      joinGroup(groupId);
    });
    _socket.on(ApiEndpoints.newMessage, (data) {
      print('📩 New message received: $data');
      _messageStreamController.add(MessageApiModel.fromJson(data));
    });
    _socket.onDisconnect((_) => print('❌ Socket disconnected'));

    _socket.connect();
  }

  @override
  void joinGroup(String groupId) {
    if (!_isInitialized) {
      print('⚠️ Cannot join group, socket has not been initialized.');
      return;
    }
    if (_socket.connected) {
      _socket.emit(ApiEndpoints.socketJoinGroup, groupId);
      print('🤝 Emitted joinGroup event for: $groupId');
    } else {
      print(
        '⚠️ Cannot join group, socket is not connected. Waiting for connect event.',
      );
      // The onConnect handler will automatically call joinGroup.
    }
  }

  @override
  Future<void> sendMessage(Map<String, dynamic> messageData) async {
    // This safety check is now robust.
    if (!_isInitialized || !_socket.connected) {
      final errorMessage =
          'Cannot send message. Socket is not initialized or not connected.';
      print('⚠️ ERROR: $errorMessage');
      throw ApiFailure(message: errorMessage, statusCode: 503);
    }

    print('🚀 Emitting sendMessage event with data: $messageData');
    _socket.emit(ApiEndpoints.socketSendMessage, messageData);
  }

  @override
  void dispose() {
    print('Disposing ChatDataSource...');
    if (_isInitialized) {
      _socket.dispose();
      _isInitialized = false; // Reset for next time (if app stays alive)
    }
    _messageStreamController.close();
    print('ChatDataSource disposed.');
  }

  // --- No changes needed for getMessageHistory ---
  @override
  Future<List<MessageApiModel>> getMessageHistory(String groupId) async {
    // Your existing implementation is fine
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

  @override
  // TODO: implement newMessagesStream
  Stream<MessageEntity> get newMessagesStream => throw UnimplementedError();
}
