import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailmate_mobile_app_assignment/feature/trail/presentation/view_model/trail_event.dart';
import 'package:trailmate_mobile_app_assignment/feature/trail/presentation/view_model/trail_view_model.dart'
    show TrailViewModel;

class TrailView extends StatelessWidget {
  const TrailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search trails...',
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 16,
                      ),
                    ),
                    onChanged: (value) {
                      // Handle search through ViewModel event
                      context.read<TrailViewModel>().add(
                        SearchTrailsEvent(value),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF66BB6A),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.tune, color: Colors.white),
                    onPressed: () {
                      // Handle filter through ViewModel event
                      // context.read<TrailViewModel>().add(OpenFilterEvent());
                    },
                  ),
                ),
              ],
            ),
          ),
          // You can add BlocBuilder here to listen to state changes
          // BlocBuilder<TrailViewModel, TrailState>(
          //   builder: (context, state) {
          //     // Return appropriate widget based on state
          //   },
          // ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.green.shade700),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 14.0, color: Colors.black54),
        ),
      ],
    );
  }
}
