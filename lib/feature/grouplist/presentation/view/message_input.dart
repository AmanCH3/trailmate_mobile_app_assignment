import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/presentation/view_model/chat_event.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/presentation/view_model/chat_state.dart';
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
      // Keep the keyboard focus after sending for a better user experience
      FocusScope.of(context).requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    // BlocBuilder listens to state changes in the ChatViewModel and rebuilds the UI.
    return BlocBuilder<ChatViewModel, ChatState>(
      // We only want this widget to rebuild if the connectionStatus changes.
      // This is an optimization to prevent unnecessary rebuilds when new messages arrive.
      buildWhen:
          (previous, current) =>
              previous.connectionStatus != current.connectionStatus,
      builder: (context, state) {
        // This is the core logic: determine if the UI should be enabled.
        // It's true only when the state's status is 'connected'.
        final bool isEnabled =
            state.connectionStatus == ConnectionStatus.connected;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                  enabled: isEnabled,
                  decoration: InputDecoration(
                    hintText: isEnabled ? 'Type a message...' : 'Connecting...',
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                  ),
                  onSubmitted: isEnabled ? (_) => _sendMessage() : null,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: isEnabled ? _sendMessage : null,
                color:
                    isEnabled
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).disabledColor,
              ),
            ],
          ),
        );
      },
    );
  }
}
