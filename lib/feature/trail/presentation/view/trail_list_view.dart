import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailmate_mobile_app_assignment/feature/trail/presentation/view/trail_card.dart';
import 'package:trailmate_mobile_app_assignment/feature/trail/presentation/view/trail_detail_view.dart';

import '../../domain/entity/trail_entity.dart';
import '../view_model/trail_event.dart';
import '../view_model/trail_state.dart';
import '../view_model/trail_view_model.dart';

class TrailsListView extends StatefulWidget {
  const TrailsListView({Key? key}) : super(key: key);

  @override
  State<TrailsListView> createState() => _TrailsListViewState();
}

class _TrailsListViewState extends State<TrailsListView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load trails when the view initializes
    context.read<TrailViewModel>().add(const LoadAllTrailsEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Trails'),
      //   backgroundColor: Colors.green,
      //   foregroundColor: Colors.white,
      //   elevation: 0,
      // ),
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search trails by name or location...',
                      prefixIcon: const Icon(Icons.search, color: Colors.green),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onChanged: (value) {
                      context.read<TrailViewModel>().add(
                        SearchTrailsEvent(value),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  // onPressed: () => _showFilterDialog(context),
                  onPressed: () {},
                  icon: const Icon(Icons.tune, color: Colors.green),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Trails List
          Expanded(
            child: BlocBuilder<TrailViewModel, TrailState>(
              builder: (context, state) {
                if (state is TrailLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    ),
                  );
                }

                if (state is TrailErrorState) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error: ${state.message}',
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<TrailViewModel>().add(
                              const RefreshTrailsEvent(),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is TrailLoadedState) {
                  if (state.filteredTrails.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.hiking,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            state.trails.isEmpty
                                ? 'No trails available'
                                : 'No trails match your search criteria',
                            style: const TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          if (state.trails.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                _searchController.clear();
                                context.read<TrailViewModel>().add(
                                  const SearchTrailsEvent(''),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Clear Search'),
                            ),
                          ],
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<TrailViewModel>().add(
                        const RefreshTrailsEvent(),
                      );
                    },
                    color: Colors.green,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.filteredTrails.length,
                      itemBuilder: (context, index) {
                        final trail = state.filteredTrails[index];
                        return TrailCard(
                          trail: trail,
                          onTap: () => _navigateToTrailDetails(context, trail),
                        );
                      },
                    ),
                  );
                }

                return const Center(child: Text('Something went wrong'));
              },
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToTrailDetails(BuildContext context, TrailEnitiy trail) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => TrailDetailsView(trail: trail)),
    );
  }

  // void _showFilterDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder:
  //         (context) => BlocProvider.value(
  //           value: context.read<TrailViewModel>(),
  //           child: const FilterDialog(),
  //         ),
  //   );
  // }
}
