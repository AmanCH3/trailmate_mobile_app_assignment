import 'package:trailmate_mobile_app_assignment/feature/grouplist/data/model/message_api_model.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/domain/entity/message_entity.dart';

abstract interface class IChatDataSource {
  Future<List<MessageApiModel>> getMessageHistory(String groupId);

  Future<void> sendMessage(Map<String, dynamic> messageData);

  Stream<MessageEntity> get newMessagesStream;

  void connectAndListen(String groupId);

  void joinGroup(String groupId);

  void dispose();
}
