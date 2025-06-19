class HomeState {
  final int selectedIndex;

  const HomeState({required this.selectedIndex});

  // Initial state
  static HomeState initial() => const HomeState(selectedIndex: 0);

  HomeState copyWith({int? selectedIndex}) {
    return HomeState(selectedIndex: selectedIndex ?? this.selectedIndex);
  }
}
