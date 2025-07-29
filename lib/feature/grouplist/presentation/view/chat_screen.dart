// FILE: lib/feature/grouplist/presentation/view/chat_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailmate_mobile_app_assignment/app/service_locator/service_locator.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/presentation/view_model/chat_view_model.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/presentation/view_model/chat_event.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/presentation/view_model/chat_state.dart';
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
                  if (state is ChatLoading && state.messages.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is ChatFailure && state.messages.isEmpty) {
                    return Center(child: Text('Error: ${state.error}'));
                  }

                  if (state.messages.isEmpty) {
                    return const Center(
                      child: Text('No messages yet. Say hi!'),
                    );
                  }

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
            // Pass the required data to the MessageInput widget
            MessageInput(groupId: groupId, currentUserId: currentUserId),
          ],
        ),
      ),
    );
  }
}
