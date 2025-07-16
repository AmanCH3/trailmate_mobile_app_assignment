import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailmate_mobile_app_assignment/app/service_locator/service_locator.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/presentation/view_model/chat_view_model.dart';

import '../view_model/chat_event.dart';
import '../view_model/chat_state.dart';
import 'message_bubble.dart';
import 'message_input.dart';

class ChatScreen extends StatelessWidget {
  final String groupId;
  final String currentUserId;

  const ChatScreen({
    super.key,
    required this.groupId,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Create the BLoC and immediately initialize it.
      create:
          (context) =>
              serviceLocator<ChatViewModel>()..add(
                InitializeChat(groupId: groupId, currentUserId: currentUserId),
              ),
      child: Scaffold(
        appBar: AppBar(title: const Text('Group Chat')),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatViewModel, ChatState>(
                builder: (context, state) {
                  // Show loading indicator only when initially loading with no messages
                  if (state is ChatLoading && state.messages.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Show error state if there's an error
                  if (state is ChatFailure && state.messages.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Error: ${state.error}'),
                          ElevatedButton(
                            onPressed: () {
                              // Retry loading
                              context.read<ChatViewModel>().add(
                                InitializeChat(
                                  groupId: groupId,
                                  currentUserId: currentUserId,
                                ),
                              );
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  // Show empty state only when successfully loaded but no messages
                  if (state is ChatSuccess && state.messages.isEmpty) {
                    return const Center(
                      child: Text('No messages yet. Say hi!'),
                    );
                  }

                  // Show messages list
                  return ListView.builder(
                    reverse: true, // Shows latest messages at the bottom
                    padding: const EdgeInsets.all(8.0),
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final message = state.messages[index];
                      return MessageBubble(
                        message: message,
                        currentUserId: currentUserId,
                      );
                    },
                  );
                },
              ),
            ),
            // Message input widget at the bottom
            const MessageInput(),
          ],
        ),
      ),
    );
  }
}
