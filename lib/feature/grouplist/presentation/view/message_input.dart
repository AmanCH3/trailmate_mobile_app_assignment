// FILE: lib/feature/grouplist/presentation/view/message_input.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/presentation/view_model/chat_event.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/presentation/view_model/chat_state.dart'; // 1. IMPORT CHAT_STATE
import 'package:trailmate_mobile_app_assignment/feature/grouplist/presentation/view_model/chat_view_model.dart';

class MessageInput extends StatefulWidget {
  final String groupId;
  final String currentUserId;

  const MessageInput({
    super.key,
    required this.groupId,
    required this.currentUserId,
  });

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      context.read<ChatViewModel>().add(
        SendMessage(
          groupId: widget.groupId,
          senderId: widget.currentUserId,
          content: text,
        ),
      );
      _controller.clear();
      FocusScope.of(context).requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    // 2. USE BlocBuilder to react to state changes.
    //    This is more efficient than context.watch as it rebuilds only this small part.
    return BlocBuilder<ChatViewModel, ChatState>(
      builder: (context, state) {
        // 3. DETERMINE if the UI should be enabled.
        final bool isEnabled =
            state.connectionStatus == ConnectionStatus.connected;

        return Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: const [
              BoxShadow(
                offset: Offset(0, -1),
                blurRadius: 4,
                color: Colors.black12,
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  // 4. ENABLE/DISABLE the text field based on the state.
                  enabled: isEnabled,
                  decoration: InputDecoration(
                    // 5. CHANGE the hint text to give user feedback.
                    hintText: isEnabled ? 'Type a message...' : 'Connecting...',
                    border: InputBorder.none,
                  ),
                  // 6. ONLY allow submitting if enabled.
                  onSubmitted: isEnabled ? (_) => _sendMessage() : null,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                // 7. SET onPressed to null to automatically disable the button and change its color.
                onPressed: isEnabled ? _sendMessage : null,
              ),
            ],
          ),
        );
      },
    );
  }
}
