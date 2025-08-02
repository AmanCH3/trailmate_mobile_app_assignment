import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

// Your imports
import 'package:trailmate_mobile_app_assignment/app/shared_pref/token_shared_prefs.dart';
import 'package:trailmate_mobile_app_assignment/app/usecase/usecase.dart';
import 'package:trailmate_mobile_app_assignment/core/error/failure.dart';
import 'package:trailmate_mobile_app_assignment/feature/home/domain/entity/bot_entity.dart';
import 'package:trailmate_mobile_app_assignment/feature/home/domain/repository/bot_repository.dart';

class GetChatReplyUsecase
    implements UseCaseWithParams<ChatMessageEntity, GetChatReplyParams> {
  final BotRepository repository;
  final TokenSharedPrefs tokenSharedPrefs;

  GetChatReplyUsecase(this.repository, this.tokenSharedPrefs);

  @override
  Future<Either<Failure, ChatMessageEntity>> call(
    GetChatReplyParams params,
  ) async {
    // 1. Get the token result, which is an `Either<Failure, String?>`.
    final Either<Failure, String?> tokenResult =
        await tokenSharedPrefs.getToken();

    // 2. Use .fold() to handle both possible outcomes of the token fetch.
    return tokenResult.fold(
      (failure) async {
        // --- FAILURE CASE ---
        // If getting the token fails (e.g., a cache error), we have two options:
        // Option A (Safer): Propagate the failure.
        return Left(failure);

        // Option B (Graceful): Proceed as a guest. Uncomment this and comment out Option A if you prefer this.
        /*
        print("Could not get token due to ${failure.toString()}, proceeding as guest.");
        return await repository.getChatReply(
          query: params.query,
          history: params.history,
          token: null, // Pass null because we failed to get a token
        );
        */
      },
      (token) async {
        // --- SUCCESS CASE ---
        // If we successfully get a value (which could be a token string or null),
        // we pass it to the repository.
        return await repository.getChatReply(
          query: params.query,
          history: params.history,
          token: token, // Pass the unwrapped token (String or null)
        );
      },
    );
  }
}

/// Parameters class for the usecase.
class GetChatReplyParams extends Equatable {
  final String query;
  final List<ChatMessageEntity> history;

  const GetChatReplyParams({required this.query, required this.history});

  @override
  List<Object?> get props => [query, history];
}
