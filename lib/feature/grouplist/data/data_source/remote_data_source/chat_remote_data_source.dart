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

  ChatRemoteDataSourceImpl({
    required ApiService apiService,
    required TokenSharedPrefs tokenSharedPrefs,
  }) : _apiService = apiService,
       _tokenSharedPrefs = tokenSharedPrefs;

  Stream<MessageApiModel> get newMessageStream =>
      _messageStreamController.stream;

  @override
  void connectAndListen(String groupId) {
    _socket = IO.io(ApiEndpoints.serverAddress, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    _socket.connect();

    _socket.onConnect((_) {
      print('Socket connected: ${_socket.id}');
      joinGroup(groupId);
    });

    _socket.on(ApiEndpoints.newMessage, (data) {
      print('New message received: $data');
      final message = MessageApiModel.fromJson(data);
      _messageStreamController.add(message);
    });

    _socket.onDisconnect((_) => print('Socket disconnected'));
    _socket.onError((error) => print('Socket error: $error'));
  }

  @override
  void joinGroup(String groupId) {
    if (_socket.connected) {
      _socket.emit(ApiEndpoints.socketJoinGroup, groupId);
      print('Joining group: $groupId');
    } else {
      print('Cannot join group, socket is not connected.');
    }
  }

  @override
  Future<List<MessageApiModel>> getMessageHistory(String groupId) async {
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
        final messages =
            (response.data['data'] as List)
                .map((msgJson) => MessageApiModel.fromJson(msgJson))
                .toList();
        return messages;
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
  Future<void> sendMessage(Map<String, dynamic> messageData) async {
    _socket.emit(ApiEndpoints.socketSendMessage, messageData);
  }

  @override
  void dispose() {
    _messageStreamController.close();
    _socket.dispose();
    print('ChatDataSource disposed.');
  }

  @override
  Stream<MessageEntity> get newMessagesStream => throw UnimplementedError();
}
