import 'package:trailmate_mobile_app_assignment/feature/home/data/model/bot_model_response.dart';
import 'package:trailmate_mobile_app_assignment/feature/home/domain/entity/bot_entity.dart';

abstract interface class BotDataSource {
  Future<ChatResponseModel> getChatReply({
    required String query,
    required List<ChatMessageEntity> history,
    String? token,
  });
}
