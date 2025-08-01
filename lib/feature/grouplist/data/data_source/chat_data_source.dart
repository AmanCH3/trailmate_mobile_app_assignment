import 'package:trailmate_mobile_app_assignment/feature/grouplist/data/model/message_api_model.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/domain/entity/message_entity.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/presentation/view_model/chat_state.dart';

abstract interface class IChatDataSource {
  Future<List<MessageApiModel>> getMessageHistory(String groupId);

  Future<void> sendMessage(Map<String, dynamic> messageData);

  Stream<ConnectionStatus> get connectionStatusStream;

  Stream<MessageEntity> get newMessagesStream;

  void connectAndListen(String groupId);

  void joinGroup(String groupId);

  void dispose();
}
