import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/presentation/view_model/group_view_model.dart';

import '../../domain/entity/group_entity.dart';
import '../../domain/usecase/request_to_join_usecase.dart';
import '../view_model/group_event.dart';
import 'chat_screen.dart';

class GroupListItem extends StatelessWidget {
  final GroupEntity group;

  const GroupListItem({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    final userId = context.read<GroupViewModel>().currentUserId;
    final isJoined = group.participants.any((p) => p.id == userId);

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Group Photo Banner
          SizedBox(
            height: 180,
            width: double.infinity,
            child:
                group.photos.isNotEmpty
                    ? Image.network(
                      group.photos.first,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) => const Icon(
                            Icons.broken_image,
                            size: 50,
                            color: Colors.grey,
                          ),
                    )
                    : Container(
                      color: Colors.grey.shade300,
                      child: const Icon(
                        Icons.groups,
                        size: 60,
                        color: Colors.grey,
                      ),
                    ),
          ),
          // Group Details
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  group.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.person, size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text('Led by ${group.leader?.name}'),
                    const Spacer(),
                    Icon(Icons.hiking, size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(group.difficulty),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(DateFormat.yMMMd().format(group.date)),
                    const Spacer(),
                    Icon(
                      Icons.people_alt,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${group.participants.length}/${group.maxSize} members',
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Action Button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(isJoined ? Icons.chat : Icons.add),
                label: Text(isJoined ? 'Go to Chat' : 'Request to Join'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  if (isJoined) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder:
                            (_) => ChatScreen(
                              groupId: group.id,
                              currentUserId: userId.toString(),
                            ),
                      ),
                    );
                  } else {
                    final params = RequestToJoinGroupParams(groupId: group.id);
                    context.read<GroupViewModel>().add(
                      RequestToJoinGroupEvent(params: params, groupId: ''),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
